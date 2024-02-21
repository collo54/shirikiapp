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
    apiKey: 'AIzaSyBBY6tdcDTXPu6lbF2GQRjBIGLdkMGlqh8',
    appId: '1:419762667916:web:4dd1895fc374adfb2fd6a9',
    messagingSenderId: '419762667916',
    projectId: 'shirikiapp',
    authDomain: 'shirikiapp.firebaseapp.com',
    storageBucket: 'shirikiapp.appspot.com',
    measurementId: 'G-3QNTJ8F2NS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDhHQUOqe4dH0kK8u2qCVKQ5jSGvBxFp5I',
    appId: '1:419762667916:android:5425ff1290ea6e612fd6a9',
    messagingSenderId: '419762667916',
    projectId: 'shirikiapp',
    storageBucket: 'shirikiapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBqjsnLUoAIPjMG2L9-8roH2MgzHRunUak',
    appId: '1:419762667916:ios:36a6487206b9d61a2fd6a9',
    messagingSenderId: '419762667916',
    projectId: 'shirikiapp',
    storageBucket: 'shirikiapp.appspot.com',
    iosClientId: '419762667916-vdcg6039k1iidiutt6052l0mu5vt9mfe.apps.googleusercontent.com',
    iosBundleId: 'com.example.shiriki',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBqjsnLUoAIPjMG2L9-8roH2MgzHRunUak',
    appId: '1:419762667916:ios:fc127687ef4d7c7f2fd6a9',
    messagingSenderId: '419762667916',
    projectId: 'shirikiapp',
    storageBucket: 'shirikiapp.appspot.com',
    iosClientId: '419762667916-6pahps9ilanpmkbup7eo1uptjlcpniil.apps.googleusercontent.com',
    iosBundleId: 'com.example.shiriki.RunnerTests',
  );
}