import 'package:chat_app_th/widget/users_list.dart';
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
        return Column(
          children: [
            Expanded(child: UsersList()),
          ],
        );
      },
    );
  }
}


