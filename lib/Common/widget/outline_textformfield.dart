import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget outlineTextFromField(
    {ValueChanged<String>? onChanged,
    EdgeInsetsGeometry? contentPadding,
    String? label,
    String? hintText,
    FormFieldValidator? validator,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType}) {
  return TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(
      contentPadding:
          contentPadding ?? EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      hintText: hintText,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    validator: validator,
    onChanged: onChanged,
    inputFormatters: inputFormatters,
    keyboardType: keyboardType,
  );
}