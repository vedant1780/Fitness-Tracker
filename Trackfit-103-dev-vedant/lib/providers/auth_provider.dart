import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// ✅ StreamProvider to listen for authentication state changes
final authStateProvider = StreamProvider<User?>(
      (ref) => FirebaseAuth.instance.authStateChanges(),
);

/// ✅ AuthNotifier manages authentication logic and logout
class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(FirebaseAuth.instance.currentUser) {
    // Keep user state in sync with FirebaseAuth
    FirebaseAuth.instance.authStateChanges().listen((user) {
      state = user;
    });
  }

  /// ✅ Sign out from both Google and Firebase
  Future<void> signOut() async {
    try {
      final googleSignIn = GoogleSignIn();
      final isSignedIn = await googleSignIn.isSignedIn();

      if (isSignedIn) {
        // ✅ This clears the cached Google account so the "Choose account" appears next time
        await googleSignIn.disconnect();
        await googleSignIn.signOut();
      }

      await FirebaseAuth.instance.signOut();
      state = null; // reset Riverpod state
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

}

/// ✅ Provider for AuthNotifier
final authNotifierProvider =
StateNotifierProvider<AuthNotifier, User?>((ref) => AuthNotifier());
