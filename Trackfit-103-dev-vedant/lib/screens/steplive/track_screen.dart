import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart' hide PermissionStatus;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarckfit/widgets/Sliding.dart';
import 'package:tarckfit/widgets/track_control_button.dart';
import '../../data/activiy_hive.dart';
import '../../data/hive_service.dart';
import '../../providers/tracking_provider.dart';

const themeColor = Color(0xFF661FCC);

class TrackScreen extends ConsumerStatefulWidget {
  const TrackScreen({super.key});

  @override
  ConsumerState<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends ConsumerState<TrackScreen> {
  int _steps = 0;
  int? _stepBaseline;
  double _distance = 0.0;
  int _calories = 0;
  Duration _timeElapsed = Duration.zero;
  DateTime? _startTime;

  final MapController _mapController = MapController();
  final Location _location = Location();
  LatLng _initialPosition = const LatLng(40.730610, -73.935242);

  final List<LatLng> _trackedPath = [];
  final List<Marker> _markers = [];

  bool _hasPermission = false;
  StreamSubscription<StepCount>? _stepSubscription;
  StreamSubscription<LocationData>? _locationSubscription;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkPermissions().then((_) => _initPedometer());
  }

  @override
  void dispose() {
    _stepSubscription?.cancel();
    _locationSubscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initPedometer() async {
    try {
      if (await Permission.activityRecognition.request().isGranted) {
        _stepSubscription = Pedometer.stepCountStream.listen(
          _onStepCount,
          onError: (err) => debugPrint("Pedometer error: $err"),
          cancelOnError: false,
        );
        debugPrint("✅ Pedometer initialized successfully");
      } else {
        debugPrint("🚫 Activity Recognition Permission Denied");
      }
    } catch (e) {
      debugPrint("❌ Error initializing pedometer: $e");
    }
  }

  void _onStepCount(StepCount event) {
    final isTracking = ref.read(trackingStateProvider);
    if (!isTracking) return;

    final int rawSteps = event.steps;
    _stepBaseline ??= rawSteps;
    final int deltaSteps =
    (rawSteps - (_stepBaseline ?? rawSteps)).clamp(0, 1000000);
    if (!mounted) return;

    setState(() {
      _steps = deltaSteps;
      _distance = _computeDistanceFromSteps(_steps);
      _calories = (_steps * 0.04).toInt();
      if (_startTime != null) {
        _timeElapsed = DateTime.now().difference(_startTime!);
      }
    });
  }

  double _computeDistanceFromSteps(int steps) => steps * 0.0008;

  Future<void> _checkPermissions() async {
    final status = await Permission.location.request();
    if (!status.isGranted) {
      debugPrint("🚫 Location Permission Denied");
      return;
    }

    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        debugPrint("🚫 Location Service Disabled");
        return;
      }
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    await _location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
      distanceFilter: 1,
    );

    final locData = await _location.getLocation();
    if (!mounted) return;
    setState(() {
      _initialPosition = LatLng(
        locData.latitude ?? _initialPosition.latitude,
        locData.longitude ?? _initialPosition.longitude,
      );
      _hasPermission = true;
    });
    _updateCurrentMarker(_initialPosition);
  }

  void _updateCurrentMarker(LatLng position, {bool tracking = false}) {
    // Always update current live position marker
    _markers.removeWhere((m) => m.key == const ValueKey('current_position'));
    _markers.add(
      Marker(
        key: const ValueKey('current_position'),
        point: position,
        width: 50,
        height: 50,
        child: const Icon(Icons.location_on, color: themeColor, size: 40),
      ),
    );

    // Remove send marker while tracking
    if (tracking) {
      _markers.removeWhere((m) => m.key == const ValueKey('send_marker'));
    }

    setState(() {});
  }

  void _startTracking() {
    ref.read(trackingStateProvider.notifier).state = true;

    setState(() {
      _steps = 0;
      _stepBaseline = null;
      _distance = 0;
      _calories = 0;
      _timeElapsed = Duration.zero;
      _startTime = DateTime.now();
      _trackedPath.clear();
      _trackedPath.add(_initialPosition);
    });

    // Start with only current marker
    _updateCurrentMarker(_initialPosition, tracking: true);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _startTime == null) return;
      setState(() {
        _timeElapsed = DateTime.now().difference(_startTime!);
      });
    });

    _locationSubscription?.cancel();
    _locationSubscription = _location.onLocationChanged.listen((locData) {
      final isTracking = ref.read(trackingStateProvider);
      if (!isTracking ||
          locData.latitude == null ||
          locData.longitude == null) return;

      final LatLng latLng = LatLng(locData.latitude!, locData.longitude!);
      _trackedPath.add(latLng);

      // Update only current marker (send marker appears after stop)
      _updateCurrentMarker(latLng, tracking: true);

      try {
        _mapController.move(latLng, 15.0);
      } catch (_) {}
    });
  }

  Future<void> _stopTracking() async {
    ref.read(trackingStateProvider.notifier).state = false;

    _locationSubscription?.cancel();
    _timer?.cancel();
    _timer = null;

    // Add send marker at the endpoint
    if (_trackedPath.isNotEmpty) {
      final LatLng endPosition = _trackedPath.last;
      _markers.removeWhere((m) => m.key == const ValueKey('send_marker'));
      _markers.add(
        Marker(
          key: const ValueKey('send_marker'),
          point: endPosition,
          width: 40,
          height: 40,
          child: const Icon(Icons.send, color: themeColor, size: 35),
        ),
      );
      setState(() {});
    }

    if (_steps == 0) {
      debugPrint("⚠️ No steps detected — activity not saved.");
      return;
    }

    try {
      final activity = Activity(
        date: DateTime.now().toIso8601String().split('T').first,
        steps: _steps,
        time: _timeElapsed.inMinutes,
        calories: _calories,
        location: _distance,
      );

      await HiveActivityService.addActivity(activity);
      debugPrint("✅ Activity saved successfully to Hive.");
    } catch (e) {
      debugPrint("❌ Error saving activity: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTracking = ref.watch(trackingStateProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Track",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        leading: InkWell(
          onTap: () => GoRouter.of(context).go('/apphome'),
          child: Padding(
            padding: EdgeInsets.only(left: 26.w),
            child: Image.asset(
              "assets/icons/Image (12).png",
              height: 23.h,
              width: 24.w,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: Colors.black, size: 24.sp),
          ),
        ],
      ),
      body: SafeArea(
        child: !_hasPermission
            ? const Center(
          child: Text("Grant location permission to continue"),
        )
            : Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _initialPosition,
                initialZoom: 15.0,
                interactionOptions:
                const InteractionOptions(flags: InteractiveFlag.all),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.tarckfit',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _trackedPath,
                      strokeWidth: 6,
                      color: themeColor,
                    ),
                  ],
                ),
                MarkerLayer(markers: _markers),
              ],
            ),
            SafeArea(
              child: Positioned(
                bottom: 110.h,
                right: 10.w,
                child: FloatingActionButton(
                  onPressed: () {
                    if (_markers.isNotEmpty) {
                      final target = _trackedPath.isNotEmpty
                          ? _trackedPath.last
                          : _initialPosition;
                      _mapController.move(target, 15.0);
                    }
                  },
                  backgroundColor: themeColor,
                  shape: const CircleBorder(),
                  child: Icon(Icons.my_location,
                      color: Colors.white, size: 28.sp),
                ),
              ),
            ),
            isTracking
                ? SlidingStatsPanel(
              steps: _steps,
              distance: _distance,
              calories: _calories,
              timeElapsed: _timeElapsed,
              onStop: _stopTracking,
            )
                : SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: TrackControlButton(
                    text: "START",
                    onPressed: _startTracking,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}