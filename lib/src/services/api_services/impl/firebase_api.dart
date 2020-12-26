import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/user.dart';
import '../../../utils/utils.dart';
import '../api_service.dart';

/// Implementation of the Api Service for sign-in & sign-up using the Firebase
/// service.
///
/// This implementation is specific to this demo app.
/// However it will work for general sign-in & sign-up use-case.
class FirebaseApiService extends ApiService {
  FirebaseApiService(onError) : super(onError);

  @override
  Future<AppUser> signIn(Map<String, dynamic> requestData) async {
    // extract data
    final email = requestData[KEY_EMAIL];
    final password = requestData[KEY_PASSWORD];

    // sign in with firebase service
    final userCred =
        await _signInWithEmail(email, password).catchError(catchErrorImpl);

    if (userCred == null) return null;
    // get user data and create AppUser instance for this app
    return AppUser.fromFirebaseUser(userCred.user);
  }

  @override
  Future<AppUser> signUp(Map<String, dynamic> requestData) async {
    // extract data
    final email = requestData[KEY_EMAIL];
    final password = requestData[KEY_PASSWORD];
    final fullName = requestData[KEY_FULL_NAME];

    // sign up with firebase service
    final userCred = await _signUpWithEmail(email, password, fullName)
        .catchError(catchErrorImpl);

    // update user's full name in user credentials
    await userCred.user
        .updateProfile(displayName: fullName)
        .catchError(catchErrorImpl);

    // trigger a reload to update the user data
    await userCred.user.reload();

    // do not use `userCred` as it is not updated with full name
    // get the current user from firebase instead to get updated user data
    final user = _auth.currentUser;
    if (user == null) return null;
    return AppUser.fromFirebaseUser(user);
  }

  Future<UserCredential> _signUpWithEmail(email, password, fullName) async {
    // Get user credentials from firebase using email and password
    final userCredential =
        _auth.createUserWithEmailAndPassword(email: email, password: password);

    return userCredential;
  }

  Future<UserCredential> _signInWithEmail(email, password) async {
    final userCredential =
        _auth.signInWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }

  @override
  Future<void> signOut() {
    /// sign out using firebase service
    return _auth.signOut();
  }

  @override
  Future<Map<String, dynamic>> forgotPassword(
      Map<String, dynamic> requestData) async {
    // extract data
    final email = requestData[KEY_EMAIL];

    final response = await _auth.sendPasswordResetEmail(email: email).then((_) {
      return true;
    }).catchError(catchErrorImpl);
    return _processForgotPasswordResponse(
        'An Email has been sent to your registered email to reset password.',
        response != null);
  }

  Map<String, dynamic> _processForgotPasswordResponse(
      String message, bool isSuccess) {
    return {
      KEY_MESSAGE: message,
      KEY_SUCCESS: isSuccess,
    };
  }

  /// Getter for Firebase authentication instance
  FirebaseAuth get _auth => FirebaseAuth.instance;
}
