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
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerLeft,
      child: (data['type'] == 'text')
          ? Container(
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
                data['message'],
                style: TextStyle(
                  color: Colors.white,
                ),
              ))
          : Container(
              height: size.height / 2.5,
              width: size.width/2,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ShowImage(
                      imageUrl: data['message'],
                    ),
                  ),
                ),
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
}

class MyMessageItem extends StatelessWidget {
  MyMessageItem({
    Key? key,
    required this.data,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object?> data;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerRight,
      child: (data['type'] == 'text')
          ? Container(
              padding:
                  EdgeInsets.only(left: 16, top: 25, bottom: 25, right: 32),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                  bottomLeft: Radius.circular(32),
                ),
                color: defaultColor,
              ),
              child: Text(
                data['message'],
                style: TextStyle(
                  color: Colors.white,
                ),
              ))
          : Container(
              height: size.height / 2.5,
              width: size.width/2,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ShowImage(
                      imageUrl: data['message'],
                    ),
                  ),
                ),
                child: Container(
                  height: size.height / 2.5,
                  width: size.width / 3,
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
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}
