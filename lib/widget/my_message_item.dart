import 'package:chat_app_th/widget/text_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../modules/people_screen/cubit/cubit.dart';
import 'audio_message.dart';
import 'document_message.dart';
import 'image_message.dart';

class MyMessageItem extends StatelessWidget {
  MyMessageItem({
    Key? key,
    required this.data,
    required this.index,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object?> data;
  final int index;


  Widget messageType(type){
    switch (data['type']) {
      case 'text':
        {
          return TextMessage(message: data['message']);
        }
        break;
      case 'img':
        {
          return ImageMessage(message: data['message']);
        }
        break;
      case 'document':
        {
          return DocumentMessage(message: data['message']);        }
        break;
      case 'audio':
        {
          return AudioMessage(message: data['message'], index: index,);        }
        break;
      default:
        {
          return Align(
            alignment: Alignment.centerRight,
            child: Container(),
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var cubit = PeopleCubit.get(context);
    return Align(
      alignment: Alignment.centerRight,
      child: messageType(data['message']),
    );
  }
}
