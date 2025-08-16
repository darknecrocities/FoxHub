import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    } else {
      throw UnsupportedError(
        'DefaultFirebaseOptions are only supported for Android & Web in this project.',
      );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAgtzq7hhfFykWUyKsAk8LFbb0x6ukh0cY',
    appId: '1:54567040829:android:be2cea3517b439f6f83754',
    messagingSenderId: '54567040829',
    projectId: 'foxhub-3b7bb',
    storageBucket: 'foxhub-3b7bb.appspot.com',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAgtzq7hhfFykWUyKsAk8LFbb0x6ukh0cY',
    appId: '1:54567040829:web:e01a91d47a664383f83754',
    messagingSenderId: '54567040829',
    projectId: 'foxhub-3b7bb',
    storageBucket: 'foxhub-3b7bb.appspot.com',
  );
}
