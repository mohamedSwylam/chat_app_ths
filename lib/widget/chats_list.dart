import 'dart:io';
import 'package:chat_app_th/modules/people_screen/cubit/cubit.dart';
import 'package:chat_app_th/shared/styles/icon_broken.dart';
import 'package:chat_app_th/widget/audio_message.dart';
import 'package:chat_app_th/widget/document_message.dart';
import 'package:chat_app_th/widget/image_message.dart';
import 'package:chat_app_th/widget/pdf_preview.dart';
import 'package:chat_app_th/widget/text_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:record/record.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../models/user_model.dart';
import '../modules/people_screen/chat_room_screen.dart';
import '../services/firebase_service.dart';
import '../shared/components/components.dart';
import '../shared/styles/color.dart';
import 'my_message_item.dart';

class ChatsList extends StatelessWidget {
  final String receiverId;

   ChatsList({Key? key, required this.receiverId,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService service = FirebaseService();
    var cubit = PeopleCubit.get(context);
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: service.users
              .doc(service.user!.uid)
              .collection('chats')
              .doc(receiverId)
              .collection('messages')
              .orderBy('dateTime', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.data!.size == 0) {
              return Text("No Chats yet");
            }
            return Expanded(
              child: ListView.builder(
                reverse: true,
                controller: cubit.scrollController,
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index];
                  if (service.user!.uid == data['senderID'])
                    return MyMessageItem(data: data, index: index, );
                  return MessageItem(
                    data: data,
                    index: index,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class MessageItem extends StatelessWidget {
  MessageItem({
    Key? key,
    required this.data,
    required this.index,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object?> data;
  final int index;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    switch (data['type']) {
      case 'text':
        {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
                padding: EdgeInsets.only(left: 16, top: 25, bottom: 25, right: 32),
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
                  data['message'],
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
          );
        }
        break;
      case 'img':
        {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: size.height / 2.5,
              width: size.width / 2,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: InkWell(
                onTap: (){},
                child: Container(
                  height: size.height / 2.5,
                  width: size.width / 2,
                  decoration: BoxDecoration(border: Border.all()),
                  child: data['message'] != ""
                      ? Image.network(
                          data['message'],
                          fit: BoxFit.fill,
                        )
                      : CircularProgressIndicator(),
                ),
              ),
            ),
          );
        }
        break;
      case 'document':
        {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                margin: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width / 3,
                  left: 5.0,
                  top: 30.0,
                ),
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Stack(
                      children: [
                        Center(
                            child: Text(
                          'Loading Error',
                          style: TextStyle(
                            fontFamily: 'Lora',
                            color: Colors.red,
                            fontSize: 20.0,
                            letterSpacing: 1.0,
                          ),
                        )),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: PdfView(
                            path: data['message'],
                          ),
                        ),
                        Center(
                          child: GestureDetector(
                            child: Icon(
                              Icons.open_in_new_rounded,
                              size: 40.0,
                              color: Colors.blue,
                            ),
                            onTap: () async {
                              /*  final OpenResult openResult = await OpenFile.open(
                              this
                                  ._allConversationMessages[index]
                                  .keys
                                  .first);

                          openFileResultStatus(openResult: openResult);*/
                            },
                          ),
                        ),
                      ],
                    ))),
          );
        }
        break;
      default:
        {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(),
          );
        }
        break;
    }
  }
}



