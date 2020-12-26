import 'package:flutter/material.dart';

// TODO: Add any input text field related methods or helper properties here

// TODO update this validator as per the requirement, current one will work in most cases
final FormFieldValidator<String> fullNameValidator = (String value) {
  var nameLength = (value?.length ?? 0);

  if (nameLength < 3) {
    return "must be at least 3 characters long";
  }
  // if (!value.contains(' ')) {
  //   return "at least one blank space between first and last name is required";
  // }
  return null;
};

// TODO update this validator as per the requirement, current one will work in most cases
final FormFieldValidator<String> emailValidator = (String value) {
  final isValidEmail = RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(value);
  if (!isValidEmail) {
    return "invalid email";
  }
  return null;
};

// TODO update this validator as per the requirement
final FormFieldValidator<String> passwordValidator = (String value) {
  var passwordLength = (value?.length ?? 0);

  if (passwordLength <= 5) {
    return "password length must be at least 6 characters";
  }

  // if (!value.contains('@')) {
  //   return "must contain one Capital letter & one @";
  // }
  return null;
};

// TODO update this validator as per the requirement, current one will work in most cases
final String Function(String value1, String value2) confirmPasswordValidator =
    (String value1, String value2) {
  final validation3 = value1 != null && value1 == value2;
  if (!validation3) {
    return "Confirm password must match with New Password";
  }
  return null;
};
