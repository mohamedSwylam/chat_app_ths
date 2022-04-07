import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({this.hintText,this.maxLine,this.minLine,this.inputType, this.onChanged, this.obscureText = false,this.validator,this.prefixText,this.labelText,this.controller});
  Function(String)? onChanged;
  String? hintText;
  int? minLine;
  int? maxLine;
  String? labelText;
  TextEditingController? controller;
  TextInputType?  inputType;
  String? prefixText;
  bool? obscureText;
  String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText!,
      onChanged: onChanged,
      validator: validator,
      keyboardType: inputType,
      minLines: minLine,
      maxLines: maxLine,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixText: prefixText,
      ),
    );
  }
}