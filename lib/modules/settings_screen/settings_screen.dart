import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../services/firebase_service.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class SettingsScreen extends StatelessWidget {
  static String id='SettingsScreen';
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SettingsCubit.get(context);
        FirebaseService service = FirebaseService();
        return Center(child: Text('sittings screen'));
      },
    );
  }
}
