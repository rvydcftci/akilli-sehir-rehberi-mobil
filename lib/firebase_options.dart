// File: lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAqJrHRH8_-wXLZZzH2wlQbjMAEJlvXvVA',
    authDomain: 'akilli-sehir-rehberi-mobil.firebaseapp.com',
    projectId: 'akilli-sehir-rehberi-mobil',
    storageBucket: 'akilli-sehir-rehberi-mobil.firebasestorage.app',
    messagingSenderId: '100839965102',
    appId: '1:100839965102:web:9851182c5902951d55483f',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAqJrHRH8_-wXLZZzH2wlQbjMAEJlvXvVA',
    appId: '1:100839965102:web:9851182c5902951d55483f',
    messagingSenderId: '100839965102',
    projectId: 'akilli-sehir-rehberi-mobil',
    storageBucket: 'akilli-sehir-rehberi-mobil.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAqJrHRH8_-wXLZZzH2wlQbjMAEJlvXvVA',
    appId: '1:100839965102:web:9851182c5902951d55483f',
    messagingSenderId: '100839965102',
    projectId: 'akilli-sehir-rehberi-mobil',
    storageBucket: 'akilli-sehir-rehberi-mobil.firebasestorage.app',
    iosBundleId: 'com.ruveyda.akilli_sehir_rehberi_mobil',
  );
}
