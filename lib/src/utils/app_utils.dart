import 'package:flutter/material.dart';
import 'package:flutter_toast_plugin/flutter_toast_plugin.dart';

// TODO: Add any app related methods or helper properties here

/// Helper method to show any flutter widget page
///
/// [showAsReplacement] flag is used to decide the whether the new page will be
/// added on top of the current page or will replace the current page
Future<T> showPage<T>(
  BuildContext context,
  MaterialPageRoute<T> pageRoute, {
  bool showAsReplacement = false,
}) async {
  final navigator = Navigator.of(context);
  if (showAsReplacement) {
    return navigator.pushReplacement(pageRoute);
  } else {
    return navigator.push(pageRoute);
  }
}

void showToast(String msg) => FlutterToastPlugin.showToast(msg);
