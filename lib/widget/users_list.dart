import 'package:chat_app_th/modules/people_screen/cubit/cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/firebase_service.dart';

class UsersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseService service = FirebaseService();
    var cubit = PeopleCubit.get(context);
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: service.users.where('uid', isNotEqualTo: service.user!.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator();
            }
            if (snapshot.data!.size == 0) {
              return Text("No Users");
            }

            return Expanded(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index];
                  return ChatUserWidget(data: data);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class ChatUserWidget extends StatelessWidget {
  const ChatUserWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object?> data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
      /*  navigateTo(context, ChatDetailsScreen(
          userModel: model,
        ));*/
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                  '${data['userImage']}'),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              '${data['firstName']}',
              style: TextStyle(
                  height: 1.4, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}