import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../services/firebase_service.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ChatsScreen extends StatelessWidget {
  static String id='ChatsScreen';
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsCubit, ChatsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ChatsCubit.get(context);
        FirebaseService service = FirebaseService();
        return Center(child: Text('Chats screen'));
      },
    );
  }
}
