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

  // API Key diambil dari google-services.json baris ke-18
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBwLGE6y4Eb7OFkNbAgP1DkiLTMZ2LxKA4',
    appId: '1:383172501172:android:3b517a7c9fbf81edd8c1e1',
    messagingSenderId: '383172501172',
    projectId: 'maknyus-18a42',
    storageBucket: 'maknyus-18a42.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBwLGE6y4Eb7OFkNbAgP1DkiLTMZ2LxKA4',
    appId:
        '1:383172501172:ios:3b517a7c9fbf81edd8c1e1', // Asumsi ID serupa untuk iOS
    messagingSenderId: '383172501172',
    projectId: 'maknyus-18a42',
    storageBucket: 'maknyus-18a42.firebasestorage.app',
    iosBundleId: 'com.example.maknyus',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBwLGE6y4Eb7OFkNbAgP1DkiLTMZ2LxKA4',
    appId: '1:383172501172:web:3b517a7c9fbf81edd8c1e1',
    messagingSenderId: '383172501172',
    projectId: 'maknyus-18a42',
    authDomain: 'maknyus-18a42.firebaseapp.com',
    storageBucket: 'maknyus-18a42.firebasestorage.app',
  );
}
