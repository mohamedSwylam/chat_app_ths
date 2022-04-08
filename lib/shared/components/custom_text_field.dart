import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {this.hintText,
      this.maxLine,
      this.minLine,
      this.inputType,
      this.onChanged,
      this.obscureText = false,
      this.validator,
      this.prefixText,
      this.onTap,
      this.labelText,
      this.controller});

  Function(String)? onChanged;
  Function()? onTap;
  String? hintText;
  int? minLine;
  int? maxLine;
  String? labelText;
  TextEditingController? controller;
  TextInputType? inputType;
  String? prefixText;
  bool? obscureText;
  String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText!,
      onChanged: onChanged,
      onTap: onTap,
      validator: validator,
      keyboardType: inputType,
      minLines: minLine,
      maxLines: maxLine,
      decoration: InputDecoration(
        enabledBorder:  new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(10.0),
          borderSide: new BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(10.0),
          borderSide: new BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        hintText: hintText,
        labelText: labelText,
        prefixText: prefixText,
      ),
    );
  }
}
