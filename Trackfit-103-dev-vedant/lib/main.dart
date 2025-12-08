import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tarckfit/data/hive_service.dart';
import 'package:tarckfit/routes/app_route.dart';

import 'data/activiy_hive.dart';
import 'data/prefs_hive_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); // ✅ Required for hive_flutter

  if (!Hive.isAdapterRegistered(ActivityAdapter().typeId)) {
    Hive.registerAdapter(ActivityAdapter());
  }

  await HiveActivityService.init();
  await HiveService2.initHive();
  await HiveActivityService.loadCustomSampleData();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.authStateChanges().first;

  runApp(ProviderScope(child:MyApp()));
}

class MyApp extends StatelessWidget {
  final MyAppRoutes _appRoutes = MyAppRoutes();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411, 914), // Base design size (e.g. Pixel 3 XL)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: _appRoutes.router,
        );
      },
    );
  }
}
