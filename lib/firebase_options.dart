// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyCWA6tYFOX4jZDIBidhFDNZtGB9kbN2mE4',
    appId: '1:338855993523:web:c5b345fd98cfaa73db90c6',
    messagingSenderId: '338855993523',
    projectId: 'meowdoro-e203f',
    authDomain: 'meowdoro-e203f.firebaseapp.com',
    storageBucket: 'meowdoro-e203f.appspot.com',
    measurementId: 'G-M4ZNGQQDNJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA1bxMdzr_RWQgK5DHkvCR5P5DM7nr_zmk',
    appId: '1:338855993523:android:ae8bd7d51f3dffbbdb90c6',
    messagingSenderId: '338855993523',
    projectId: 'meowdoro-e203f',
    storageBucket: 'meowdoro-e203f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAmoFNmYKSZqfdev8RHMd5Ct94TLq8S9Lc',
    appId: '1:338855993523:ios:713b52051732b7eddb90c6',
    messagingSenderId: '338855993523',
    projectId: 'meowdoro-e203f',
    storageBucket: 'meowdoro-e203f.appspot.com',
    iosBundleId: 'com.example.meowdoro',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAmoFNmYKSZqfdev8RHMd5Ct94TLq8S9Lc',
    appId: '1:338855993523:ios:713b52051732b7eddb90c6',
    messagingSenderId: '338855993523',
    projectId: 'meowdoro-e203f',
    storageBucket: 'meowdoro-e203f.appspot.com',
    iosBundleId: 'com.example.meowdoro',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCWA6tYFOX4jZDIBidhFDNZtGB9kbN2mE4',
    appId: '1:338855993523:web:84b5561478966829db90c6',
    messagingSenderId: '338855993523',
    projectId: 'meowdoro-e203f',
    authDomain: 'meowdoro-e203f.firebaseapp.com',
    storageBucket: 'meowdoro-e203f.appspot.com',
    measurementId: 'G-L7XHECD5S9',
  );
}
