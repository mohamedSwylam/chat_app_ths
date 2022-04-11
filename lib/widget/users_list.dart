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
          stream: service.users
              .where('uid', isNotEqualTo: cubit.userModel!.uid)
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

            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                return ChatUserWidget(data: data);
              },
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
    return Card(
      color: Colors.grey.shade400,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Text(data['mainCategory'])),
      ),
    );
  }
}