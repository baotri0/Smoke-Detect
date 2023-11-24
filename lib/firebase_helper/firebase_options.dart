import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (Platform.isIOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        // appId: '1:961639543233:ios:d72fee70b74e7fc6a7bf40',
        // apiKey: 'AIzaSyBpolA9B5RuiC9dDDbdtYSMDK02483dE6A',
        // projectId: 'detect-smoke',
        // messagingSenderId: '961639543233',
        // iosBundleId: 'detect-smoke.appspot.com',
        appId: '',
        apiKey: '',
        projectId: '',
        messagingSenderId: '',
        iosBundleId: '',
      );
    } else {
      // Android
      return const FirebaseOptions(
        appId: '1:961639543233:android:2cac5d3256293e9ba7bf40',
        apiKey: 'AIzaSyCXPiOkFvpBPy9n61MuOcbgTnriunoZ0lo',
        projectId: 'detect-smoke',
        messagingSenderId: '961639543233',
        storageBucket: "detect-smoke.appspot.com",
      );
    }
  }
}
