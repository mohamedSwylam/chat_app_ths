import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../models/user_model.dart';
import '../../services/firebase_service.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class PeopleScreen extends StatelessWidget {
  static String id='PeopleScreen';
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PeopleCubit, PeopleStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = PeopleCubit.get(context);
        FirebaseService service = FirebaseService();
        return Center(child: Text('People screen'));
      },
    );
  }
}


  Widget buildChatItem(UserModel model,context) =>
      InkWell(
        onTap: (){
  /*        navigateTo(context, ChatDetailsScreen(
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
                    '${model.image}'),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                '${model.firstName}',
                style: TextStyle(
                    height: 1.4, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
}