import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  const InputTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.isPassword = false,
    this.isEmail = false,
    this.shouldValidate = false,
    this.controller,
    this.textInputType,
    this.prefixIcon,
    this.suffixIcon,
  });

  final TextEditingController? controller;
  final TextInputType? textInputType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String labelText;
  final String hintText;
  final bool isPassword;
  final bool isEmail;
  final bool shouldValidate;

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );

    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffix: suffixIcon,
        labelText: labelText,
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      validator: shouldValidate
          ? (value) {
              if (value?.isEmpty ?? true) {
                return 'Input field can not be empty';
              } else if (isEmail) {
                // validate email form
                final bool isEmailValid = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                ).hasMatch(value ?? '');
                if (!isEmailValid) {
                  return 'Please enter your email correctly';
                } else {
                  return null;
                }
              } else {
                return null;
              }
            }
          : null,
    );
  }
}
