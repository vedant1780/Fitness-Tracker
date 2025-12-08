import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HiveService2 {
  static const String _boxName = "userPrefs";
  static late Box _box;

  /// Initialize Hive for all platforms
  static Future<void> initHive() async {
    await Hive.initFlutter(); // Works on Web, Android, iOS, Desktop
    _box = await Hive.openBox(_boxName);
  }

  /// Set a preference and update Firestore
  static Future<void> setPreference(String key, dynamic value) async {
    await _box.put(key, value);
    print("✅ Updated $key locally: $value");

    // Also update Firestore if user is logged in
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({key: value});
        print("☁️ Synced $key to Firestore for ${user.uid}");
      } catch (e) {
        print("⚠️ Firestore sync failed for $key: $e");
      }
    }
  }

  /// Get a preference value
  static dynamic getPreference(String key) {
    return _box.get(key);
  }

  /// Remove a preference
  static Future<void> removePreference(String key) async {
    await _box.delete(key);
    print("🗑️ Removed $key locally");

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({key: FieldValue.delete()});
        print("🗑️ Removed $key from Firestore");
      } catch (e) {
        print("⚠️ Firestore delete failed: $e");
      }
    }
  }

  /// Clear all preferences
  static Future<void> clearAll() async {
    await _box.clear();
    print("🧹 Cleared all preferences locally");

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({}, SetOptions(merge: false));
        print("🧹 Cleared all user data in Firestore");
      } catch (e) {
        print("⚠️ Firestore clear failed: $e");
      }
    }
  }

  /// Get all stored preferences
  static Map<String, dynamic> getAllPreferences() {
    return _box.toMap().map((key, value) => MapEntry(key.toString(), value));
  }
}
