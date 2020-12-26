// TODO: Implement this class to integrate your custom api easily in this app

/// The Api services used in this app must extend this class for easy integration to
/// any custom apis or 3rd party features.
///
/// Login page, Registration page and Social media sign in buttons depend on the structure
/// of this class.
///
///
/// This class supports following actions:
///   - Sign in/Login (required)
///   - Sign up/Register (Optional)
///   - reset password (Optional)
///   - Sign Out from current login (Optional)
///
/// You can add mandatory or optional functions in this class as required.
/// Functions like reset password, forgot password, send verification code or verify code, etc
///   can be added & implemented to achieve the functionality required.
///
/// If Possible create a Singleton instance of the apiService class to
/// manage the user login easily.
///
/// Current implementations of this class:
///   - [GoogleApiServiceImpl] for google login
///   - [FacebookApiServiceImpl] for facebook login
///   - [LinkedInApiServiceImpl] for LinkedIn login
///   - [CustomApiService] for login using email and password, Demo only
///
///  Refer to the above classes to get more idea about how to use implement ApiService
abstract class ApiService<T> {
  /// This is the callback which can be used to handle any exceptions in the
  /// flow of any api interactions
  final Function onError;

  /// constructor of the api service
  ApiService(this.onError) {
    initialize();
  }

  /// Method to perform any initializations for api service
  ///
  /// It will be called as soon as the instance of api service is created
  void initialize() {}

  /// Method to perform sign in.
  ///
  /// This method should contain the complete flow of contacting an api
  /// and processing sign in.
  ///
  /// [requestData] should provide any data for login process,
  /// like, email, phone number or user id & password or whatever data is required
  /// for login
  ///
  /// The data changes as per the api's requirement
  ///
  /// Implementation of this method will change for each sign-in methods included
  /// in this app, including the social media sign-ins
  ///
  /// This method must be implemented.
  Future<T> signIn(Map<String, dynamic> requestData);

  /// Method to perform sign up.
  ///
  /// This method should contain the complete flow of contacting an api
  /// and processing sign up.
  ///
  /// [requestData] should provide any data for registration process,
  /// like, User name or user id, email, phone number, password or whatever data is required
  /// for registration
  ///
  /// The data changes as per the api's requirement
  ///
  /// Implementation of this method will change for each sign-up methods included
  /// in this app
  ///
  /// Implementing this method is optional if app does not contain manual registration
  /// flow
  Future<T> signUp(Map<String, dynamic> requestData) {
    return null;
  }

  /// Method to perform sign out process for currently
  /// logged in user.
  ///
  /// Implementing this method is optional if app does not contain sign in or
  /// depends on 3rd party sign-in and it does not provide sign out functions.
  Future<void> signOut() {
    return null;
  }

  /// Method to perform forgot password.
  ///
  /// [requestData] should provide any data for this process,
  /// like, User name or user id, email, phone number or whatever data is required
  /// for this process
  ///
  /// The data changes as per the api's requirement
  ///
  /// Implementation of this method will change according to the api's implementation
  ///
  /// Implementing this method is optional if app does not contain manual forget
  /// password flow
  Future<Map<String, dynamic>> forgotPassword(
      Map<String, dynamic> requestData) async {
    return null;
  }

  Future<dynamic> catchErrorImpl(e, s) async {
    var message = "Couldn't obtain user data from api";
    if (e is Exception) {
      message += "\nreason: " + e.toString();
    }
    onError?.call(Exception(message), s);
    return null;
  }
}
