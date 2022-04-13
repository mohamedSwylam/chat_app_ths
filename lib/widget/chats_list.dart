import 'package:chat_app_th/modules/people_screen/cubit/cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../modules/people_screen/chat_room_screen.dart';
import '../services/firebase_service.dart';
import '../shared/components/components.dart';
import '../shared/styles/color.dart';

class ChatsList extends StatelessWidget {
  final String? receiverId;

  const ChatsList({Key? key, this.receiverId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    FirebaseService service = FirebaseService();
    var cubit = PeopleCubit.get(context);
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: service.users.doc(service.user!.uid).collection('chats').doc(receiverId).collection('messages')
        .orderBy('dateTime',descending: true).snapshots(),
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
                  if(service.user!.uid == data['senderID'])
                    return MyMessageItem(data: data);
                  return MessageItem(data: data);
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
  }) : super(key: key);

  final QueryDocumentSnapshot<Object?> data;

  @override
  Widget build(BuildContext context) {
    return  Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.only(left: 16, top: 25, bottom: 25, right: 32),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
            bottomLeft: Radius.circular(32),
          ),
          color: Color(0xff006D84),
        ),
        child: Text(
          data['text'],
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class MyMessageItem extends StatelessWidget {
  MyMessageItem({
    Key? key,
    required this.data,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object?> data;

  @override
  Widget build(BuildContext context) {
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
          color: defaultColor,
        ),
        child: Text(
          data['text'],
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

