// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyBDb8l9mDVP5WEPzhkT-iJwCHR-_0BN-6g',
    appId: '1:329850816884:web:5c004fce81769d9b4b0421',
    messagingSenderId: '329850816884',
    projectId: 'localroots-c9e7c',
    authDomain: 'localroots-c9e7c.firebaseapp.com',
    storageBucket: 'localroots-c9e7c.appspot.com',
    measurementId: 'G-LLF8LL20F4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC2Ku_iNqZsPHkfRvhovdB7ziCAM-7wC38',
    appId: '1:329850816884:android:d3f54bb9a62042944b0421',
    messagingSenderId: '329850816884',
    projectId: 'localroots-c9e7c',
    storageBucket: 'localroots-c9e7c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA5z_fdJd1tK-SXx4k6dJu9UCO9qjANhvk',
    appId: '1:329850816884:ios:eab7a0b6ce2439394b0421',
    messagingSenderId: '329850816884',
    projectId: 'localroots-c9e7c',
    storageBucket: 'localroots-c9e7c.appspot.com',
    iosClientId: '329850816884-b8mibsuu8r52ueai3fh8jrvq55is5iu1.apps.googleusercontent.com',
    iosBundleId: 'com.u6amtech.flutterGrocery',
  );
}