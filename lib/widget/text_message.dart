import 'package:flutter/material.dart';

class TextMessage extends StatelessWidget {
  final String message;
   const TextMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
            bottomLeft: Radius.circular(32),
          ),
          color: Colors.blue.shade200,
        ),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
          ),
        ));
  }
}
