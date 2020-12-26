import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_linkedin/data_model/auth_error_response.dart';
import 'package:flutter_linkedin/linkedloginflutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../data/user.dart';
import '../../../../utils/utils.dart';
import '../../api_service.dart';
// TODO: This file includes general implementation of Google, Facebook & linked in login.

/// It is Ready to use after required configurations are done for each.
///
/// Google: Google login configuration with Firebase authentication
/// Facebook: Facebook login configuration with Facebook developer api & Firebase authentication
/// Linkedin: Linkedin login configuration with LinkedIn developer api

/// Implementation of the Api Service for Google sign-in
///
/// Note: If firebase configuration is done correctly, then google sign-in
/// should work without any code changes.
class GoogleApiServiceImpl extends ApiService<AppUser> {
  GoogleApiServiceImpl(onApiError) : super(onApiError);

  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Future<AppUser> signIn(Map<String, dynamic> requestData) async {
    final userCred = await signInWithGoogle().catchError(_catchError);

    if (isEmpty(userCred)) return null;
    return AppUser.fromFirebaseUser(userCred.user);
  }

  _catchError(e) {
    var string = "Couldn't obtain user data from Google";
    if (e is FirebaseAuthException) {
      string += "\nreason: " + e.message;
    } else {
      string += "\nreason: " + e.toString();
    }
    showToast(string);
    onError?.call(e);
    return null;
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Future<void> signOut() async {
    await googleSignIn.disconnect();
    return null;
  }
}

/// Implementation of the Api Service for Facebook sign-in
///
/// Note: If firebase and facebook configuration is done correctly,
/// then facebook sign-in should work without any code changes.
class FacebookApiServiceImpl extends ApiService<AppUser> {
  FacebookApiServiceImpl(onApiError) : super(onApiError);

  final facebookAuth = FacebookAuth.instance;

  static const String FB_NAME = 'name';
  static const String FB_EMAIL = 'email';
  static const String FB_PICTURE = 'picture';
  static const String FB_PICTURE_DATA = 'data';
  static const String FB_PICTURE_URL = 'url';

  @override
  Future<AppUser> signIn(Map<String, dynamic> requestData) async {
    final userCred = await signInWithFacebook().catchError(_catchError);

    if (isEmpty(userCred)) return null;

    final userData = await facebookAuth.getUserData();

    // Fetch User Data
    final name = userData[FB_NAME];
    final email = userData[FB_EMAIL];
    final pictureUrl = userData[FB_PICTURE][FB_PICTURE_DATA][FB_PICTURE_URL];

    // Create user from the user's data
    return AppUser(name: name, email: email, profilePictureUrl: pictureUrl);
  }

  _catchError(e) {
    var string = "Couldn't obtain user data from facebook";
    if (e is Exception) {
      string += "\nreason: " + e.toString();
    }
    showToast(string);
    onError?.call(e);
    return null;
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow

    final AccessToken accessToken = await facebookAuth.login(
      loginBehavior: LoginBehavior.NATIVE_WITH_FALLBACK,
    );

    if (accessToken == null) {
      throw Exception("Couldn't obtain access token from facebook, try again.");
    }
    // Create a credential from the access token
    final FacebookAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(accessToken.token);

    if (facebookAuthCredential == null) {
      throw Exception("Couldn't authenticate user from facebook, try again.");
    }
    // Once signed in, return the UserCredential
    var facebookCred = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential)
        .catchError(onError);
    if (facebookCred == null) {
      throw Exception("Couldn't obtain user data from facebook, try again.");
    }
    return facebookCred;
  }

  @override
  Future<void> signOut() {
    return facebookAuth.logOut();
  }
}

/// Implementation of the Api Service for LinkedIn sign-in
///
/// Note: If LinkedIn app configuration is done correctly, then LinkedIn sign-in
/// should work without any code changes.
class LinkedInApiServiceImpl extends ApiService<AppUser> {
  final pageTitle;

  LinkedInApiServiceImpl(this.pageTitle, onApiError) : super(onApiError);

  Future<String> _initializeLinkedIn() {
    return LinkedInLogin.loginForAccessToken(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
    ).then((token) => accessTokenLinkedIn = token);
  }

  @override
  Future<AppUser> signIn(Map<String, dynamic> requestData) async {
    String accessToken = await _initializeLinkedIn().catchError(_catchError);

    if (isEmpty(accessToken)) return null;

    final emailDoc = await LinkedInLogin.getEmail(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
    );
    final profileDoc = await LinkedInLogin.getProfile(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
    );

    if (emailDoc == null || profileDoc == null) return null;

    final email = emailDoc.elements.first.elementHandle.emailAddress;
    final profilePictureUrl = profileDoc.profilePicture
        .profilePictureDisplayImage.elements.first.identifiers.first.identifier;
    final fullName =
        '${profileDoc.firstName.localized.enUs} ${profileDoc.lastName.localized.enUs}';
    return AppUser(
        name: fullName, profilePictureUrl: profilePictureUrl, email: email);
  }

  _catchError(e) {
    var string = "Couldn't obtain user data from LinkedIn";
    if (e is AuthorizationErrorResponse) {
      string += "\nreason: " + e.error.toString();
    } else {
      string += "\nreason: " + e.toString();
    }
    showToast(string);
    onError?.call(e);
    return null;
  }

  @override
  Future<void> signOut() {
    return null;
  }
}
