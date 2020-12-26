import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'common_utils.dart';
import 'resources.dart';

/// This method is used to send an HTTP POST request
/// with given [url]. The response will be
/// provided as a string, whether it is a plain text or a json response.
///
/// This method will execute a network request with request type
/// based on the provided [isPost] and [isJsonRequest] flags.
///
///
/// Note: If one of the above described flag is set to true then
/// the request will be sent as an 'Http Post' request.
///
/// For ex. if isPost=false but isJsonRequest=true
///  then what is asked is an 'Http Get' request with json parameters,
///   but in Get request the body parameter is not allowed. so all the parameters
///   must be included in the url for them to work.
///
/// To handle this scenario, this method will send request to given
/// url as an 'Http Post' request if it is declared as post request
/// or if declared as a json request
Future<String> getDataFromNetwork({
  String url,
  dynamic parameters,
  Map<String, String> headerData,
  bool isPost = false,
  bool isJsonRequest = false,
  Duration timeOut = defaultTimeoutDuration,
  void Function() onTimeOut,
  Function(dynamic) onError,
}) async {
  assert(isNotEmpty(url), 'URL can not be empty or null!!');
  //check if request is to be sent as a json request
  if (isJsonRequest) {
    if (isNotEmpty(headerData)) {
      headerData = appendJSONHeaders(headerData);
    } else {
      headerData = getJSONHeaders();
    }
  }

  http.Response response;
  if (isPost || isJsonRequest) {
    response = await executePostRequest(
      url,
      headerData: headerData,
      parameters: parameters,
      timeOut: timeOut,
      onTimeOut: onTimeOut,
      onError: onError,
    );
  } else {
    response = await executeGetRequest(
      url,
      headerData: headerData,
      timeOut: timeOut,
      onTimeOut: onTimeOut,
      onError: onError,
    );
  }

  if (response == null) {
    return null;
  }
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return response.body;
  }
}

Map<String, dynamic> appendJSONHeaders(Map<String, dynamic> headerData) {
  headerData.addAll(getJSONHeaders());
  return headerData;
}

/// This method will execute an HTTP Get request
///
/// Note: additional parameters must be included in the URL before
/// sending request
Future<http.Response> executeGetRequest(
  String url, {
  Map<String, String> headerData,
  Duration timeOut = const Duration(seconds: 60),
  void Function() onTimeOut,
  Function(dynamic) onError,
}) {
  return http
      .get(
        url,
        headers: headerData,
      )
      .timeout(timeOut)
      .catchError((dynamic error) {
    if (error is TimeoutException) {
      onTimeOut?.call();
    } else {
      onError?.call(error);
    }
  });
}

/// This method will execute an HTTP Post request
Future<http.Response> executePostRequest(
  String url, {
  Map<String, String> headerData,
  dynamic parameters,
  Duration timeOut = const Duration(seconds: 60),
  void Function() onTimeOut,
  Function(dynamic) onError,
}) {
  return http
      .post(
        url,
        headers: headerData,
        body: parameters,
      )
      .timeout(timeOut)
      .catchError((dynamic error) {
    if (error is TimeoutException) {
      onTimeOut?.call();
    } else {
      onError?.call(error);
    }
  });
}

/// This method is used for providing a map containing the header
/// values for a json request
Map<String, String> getJSONHeaders() {
  return <String, String>{
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
  };
}

/// Method to check if the connection is live or not
Future<bool> isConnectionLive(String url, {bool isPost = false}) async {
  var connectionStatus = false;
  try {
    http.Response response;
    if (isPost) {
      response = await executePostRequest(url);
    } else {
      response = await executeGetRequest(url);
    }
    connectionStatus = response.statusCode == HttpStatus.ok;
  } catch (e, s) {
    print('isConnectionLive() : $e \n$s');
  }
  return connectionStatus;
}

String convertJsonToNormal(Map<String, dynamic> json) {
  StringBuffer buffer = StringBuffer();

  json.keys.forEach((key) {
    buffer.write('&');
    buffer.write('$key=${json[key]}');
  });

  final params = buffer.toString().substring(1);
  return params;
}
