typedef APICallback<T> = Future<T> Function(Map<String, dynamic> requestData);
typedef AuthCallback<T> = Future<void> Function(T value);
typedef AuthErrorCallback = Future<void> Function(Error error);

class AuthService {}

class AuthError extends Error {
  ///Message describing the authentication error
  final Object message;

  AuthError([this.message]);
}

class APIError extends Error {
  ///Message describing the API error
  final Object message;

  APIError([this.message]);
}
