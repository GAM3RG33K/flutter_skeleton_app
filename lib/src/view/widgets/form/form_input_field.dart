import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

// TODO: To customize style of this widget, provide a input decoration or change the input decoration theme in [ThemeUtils] class

/// This is a custom input field widget which is used
/// to take input from the user on login page registration page.
///
/// Note: Make sure this field is Wrapped with [Form] widget at any level above this
/// field, otherwise the validations will not work.
class FormInputField extends StatefulWidget {
  /// The Title of the Input field, this should be a short string
  final String title;

  /// This is the text value which will be pre-filled in the input area, by default it's empty
  final String initialText;

  /// This Function is the validator function for this input field, if this validation
  /// function returns a non-null String then input field will show  given [errorText]
  /// and will reflect the error with changing the border color
  final FormFieldValidator<String> validator;

  /// This function is the final callback which is used when the field is finally submitted
  /// for validation this will be called when user changes focus to another field for input
  final Function(String value) onSubmit;

  /// This function is the final callback which is used when the form calls
  /// [FormState.save] method which triggers this callback on all field included in the
  /// form.
  ///
  /// This method should provide only validated string value as parameter.
  /// Value provided by this callback is used as final value to be used outside the form
  /// for either login or sign up process.
  final Function(String value) onSaved;

  /// This function is called when the value of input changes.
  ///
  /// This method may not provide validated string value as parameter.
  /// Value provided by this callback must validated before being used directly.
  final Function(String value) onChange;

  /// Defines what type of keyboard should be displayed
  ///
  /// Full alpha-numeric - [TextInputType.text],
  /// Email - [TextInputType.emailAddress],
  /// Simple numeric - [TextInputType.number],
  /// Advanced numeric - [TextInputType.numberWithOptions],
  /// etc.
  final TextInputType inputType;

  /// Defines what action to be done and what icon to display on 'return'/'enter'
  /// button on the keyboard
  ///
  /// Go to next field - [TextInputAction.next],
  /// Search - [TextInputAction.search],
  /// Done - [TextInputAction.done],
  /// etc.
  ///
  final TextInputAction inputAction;

  /// UI decoration of the Field,
  /// Any customization in the input decoration should be provided in this
  /// parameter.
  ///
  /// Note that any customization will replace the default one.
  final InputDecoration inputDecoration;

  /// Flag to define if to display the text in the input field or to hide it
  ///
  /// Useful in fields like Password and OTP.
  final bool obscureText;

  /// Define if to validate the string automatically when user leaves the
  /// field, this does not require a manual trigger using [FormState.validate]
  ///
  /// It can be:
  ///  always enabled - [AutovalidateMode.always]
  ///  enabled only on user interaction - [AutovalidateMode.onUserInteraction]
  ///  always disabled - [AutovalidateMode.disabled]
  final AutovalidateMode autoValidateMode;

  /// prefix icon to show before the input text, useful for defining UX
  final Widget prefixIcon;

  /// suffix icon to show after the input text, useful for providing
  /// additional functionality
  final Widget suffixIcon;

  /// Text that will be displayed on error, Can be something which shows the exact
  /// error or provides a hint for preventing such error
  final String errorText;

  const FormInputField({
    Key key,
    this.title = '',
    this.validator,
    this.initialText,
    this.onSubmit,
    this.onSaved,
    this.onChange,
    this.inputType,
    this.inputAction,
    this.inputDecoration,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.errorText,
  }) : super(key: key);

  @override
  _FormInputFieldState createState() => _FormInputFieldState();
}

class _FormInputFieldState extends State<FormInputField> {
  TextEditingController _controller;
  InputDecoration _decoration;

  @override
  void initState() {
    _controller = TextEditingController(
      text: widget.initialText,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _decoration ??= widget.inputDecoration;
    _decoration ??= InputDecoration(
      prefixIcon: widget.prefixIcon,
      suffixIcon: widget.suffixIcon,
      errorText: widget.errorText,
    );

    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Title of the Input field
            Offstage(
              offstage: isEmpty(widget.title),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
              ),
            ),
            // Input field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextFormField(
                decoration: _decoration,
                keyboardType: widget.inputType,
                textInputAction: widget.inputAction,
                obscureText: widget.obscureText,
                onFieldSubmitted: widget.onSubmit,
                validator: widget.validator,
                controller: _controller,
                autovalidateMode: widget.autoValidateMode,
                cursorColor: ThemeUtils.textColor,
                onSaved: widget.onSaved,
                onChanged: widget.onChange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
