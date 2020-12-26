import 'package:firebase_auth/firebase_auth.dart';

import '../utils/common_utils.dart';

// TODO: Use & Update this model class to get detail about a User from any API.
//  Using single class to obtain user data will provide easy integration
//  of new features without changing the existing ones.

/// A model class that represents a user for this app.
///
/// This model contains following data:
///   - Full name of the user
///   - Profile picture URL for this user
///   - Email of the user
///
/// Any of the above data can be absent at any point
class AppUser {
  // TODO: Add or remove new user properties here
  final String name;
  final String profilePictureUrl;
  final String email;

  AppUser({this.name, this.profilePictureUrl, this.email});

  /// This method creates [AppUser] instance from the Firebase user instance
  ///
  /// Note: Purpose of this method is only for this demo app
  factory AppUser.fromFirebaseUser(User firebaseUser) {
    return AppUser(
      name: firebaseUser.displayName,
      profilePictureUrl: firebaseUser.photoURL,
      email: firebaseUser.email,
    );
  }

  get isEmptyUserData =>
      isEmpty(name) && isEmpty(email) && isEmpty(profilePictureUrl);
}
