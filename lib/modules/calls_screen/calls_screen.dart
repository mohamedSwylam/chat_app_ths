import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../services/firebase_service.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class CallsScreen extends StatelessWidget {
  static String id='CallsScreen';
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CallsCubit, CallsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = CallsCubit.get(context);
        FirebaseService service = FirebaseService();
        return Center(child: Text('Calls screen'));
      },
    );
  }
}
