
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.

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
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDZ_QbaOImpXwmgwdlwKXUyz6h6UTt1NJA',
    appId: '1:676266590002:web:b0a9056b63aa521a56a12b',
    messagingSenderId: '676266590002',
    projectId: 'fingerprint-attendance-s-1471d',
    authDomain: 'fingerprint-attendance-s-1471d.firebaseapp.com',
    databaseURL:
        'https://fingerprint-attendance-s-1471d-default-rtdb.firebaseio.com',
    storageBucket: 'fingerprint-attendance-s-1471d.appspot.com',
    measurementId: 'G-WT080WED4F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA88oQ7UPHXLdfjp91xRZd2EglhLSMTM2c',
    appId: '1:676266590002:android:483a654e0c1ec68e56a12b',
    messagingSenderId: '676266590002',
    projectId: 'fingerprint-attendance-s-1471d',
    databaseURL:
        'https://fingerprint-attendance-s-1471d-default-rtdb.firebaseio.com',
    storageBucket: 'fingerprint-attendance-s-1471d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAQjdFNF9CAFk8UnGQTs_ufQeqUJ89LRck',
    appId: '1:676266590002:ios:41efc13d18140adc56a12b',
    messagingSenderId: '676266590002',
    projectId: 'fingerprint-attendance-s-1471d',
    databaseURL:
        'https://fingerprint-attendance-s-1471d-default-rtdb.firebaseio.com',
    storageBucket: 'fingerprint-attendance-s-1471d.appspot.com',
    iosBundleId: 'com.example.untitled3',
  );
}
