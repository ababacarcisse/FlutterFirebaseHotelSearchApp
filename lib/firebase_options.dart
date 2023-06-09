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
        return macos;
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
    apiKey: 'AIzaSyC5iRTJ7f4Mhyic9_uHCO0ZnbMmut2j_6U',
    appId: '1:554647393627:web:993c0c24f8bfe3966a767e',
    messagingSenderId: '554647393627',
    projectId: 'test2-a4ff8',
    authDomain: 'test2-a4ff8.firebaseapp.com',
    storageBucket: 'test2-a4ff8.appspot.com',
    measurementId: 'G-9P9EV90373',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBZZKEFi3DK7XlkTzs5FuVw0FMoD6XAVRA',
    appId: '1:554647393627:android:82a8b5a57c2ca4146a767e',
    messagingSenderId: '554647393627',
    projectId: 'test2-a4ff8',
    storageBucket: 'test2-a4ff8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDbh2KKiqwxjn60MSsutcH-u6W7sQqyNws',
    appId: '1:554647393627:ios:6abb06ec274d10e66a767e',
    messagingSenderId: '554647393627',
    projectId: 'test2-a4ff8',
    storageBucket: 'test2-a4ff8.appspot.com',
    androidClientId: '554647393627-aftgq924e9g9ilagrfifrspf58ahff5j.apps.googleusercontent.com',
    iosClientId: '554647393627-m3i9n15b4bjpv42bsgcoe4sdeaplh6va.apps.googleusercontent.com',
    iosBundleId: 'com.example.travelApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDbh2KKiqwxjn60MSsutcH-u6W7sQqyNws',
    appId: '1:554647393627:ios:0ce6bd441165b1326a767e',
    messagingSenderId: '554647393627',
    projectId: 'test2-a4ff8',
    storageBucket: 'test2-a4ff8.appspot.com',
    androidClientId: '554647393627-aftgq924e9g9ilagrfifrspf58ahff5j.apps.googleusercontent.com',
    iosClientId: '554647393627-gar1druc6daq8agjrnbrj45gaga0c82q.apps.googleusercontent.com',
    iosBundleId: 'com.example.travelApp.RunnerTests',
  );
}
