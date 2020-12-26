import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../data/user.dart';
import 'api_services/api_service.dart';

/// ********** Custom callback alias *********** ///
typedef APICallback<T> = Future<T> Function(
    ApiService apiService, Map<String, dynamic> requestData);
typedef AuthCallback = Future<void> Function(AppUser user);
typedef AuthErrorCallback = Function(Object error, [StackTrace stacktrace]);
typedef SimpleCallback<T> = Future<void> Function(T value);
typedef SimpleCallback2<T, R> = Future<R> Function(T value);

/// ********** Custom callback alias *********** ///

/// Method to sign out from all apis that we have
/// Google, facebook and firebase which is used in our custom api
Future signOutFromAll() async {
  final firebase = FirebaseAuth.instance;
  final google = GoogleSignIn();
  final facebook = FacebookAuth.instance;

  var signedIn = await google.isSignedIn();
  if (signedIn) {
    await google.disconnect();
  }
  signedIn = !((await facebook.isLogged)?.isExpired ?? false);
  if (signedIn) {
    await facebook.logOut();
  }
  firebase.signOut();
}
