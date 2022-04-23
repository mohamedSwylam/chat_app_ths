import 'package:flutter/material.dart';

class TextMessage extends StatelessWidget {
  final String message;
   const TextMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
        EdgeInsets.only(left: 16, top: 25, bottom: 25, right: 32),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          color: Color(0xff006D84),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
          ),
        ));
  }
}
