import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simple provider to hold tracking state (playing or paused)
final trackingStateProvider = StateProvider<bool>((ref) => false);
