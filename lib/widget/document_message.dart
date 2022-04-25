import 'package:chat_app_th/widget/chats_list.dart';
import 'package:chat_app_th/widget/pdf_preview.dart';
import 'package:flutter/material.dart';

import '../shared/styles/icon_broken.dart';

class DocumentMessage extends StatelessWidget {
  final String message;
  const DocumentMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 20, top: 15, bottom: 15, right: 20),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
            bottomLeft: Radius.circular(32),
          ),
          color: Colors.blue.shade200,
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PDFView(
                  url: message,
                ),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                IconBroken.Document,
                color: Colors.white,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                'Document',
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ));
  }
}
