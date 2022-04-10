import 'package:bloc/bloc.dart';
import 'package:chat_app_th/modules/Login/cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates> {
  SocialLoginCubit() : super(SocialLoginInitialState());

  static SocialLoginCubit get(context) => BlocProvider.of(context);
  void userLogin({
    required String email,
    required String password,
  }) {
    emit(SocialLoginLoadingState());
    EasyLoading.show(status: 'Please wait..');
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) {
      EasyLoading.dismiss();
      emit(SocialLoginSuccessState(value.user!.uid));
    }).catchError((error){
      emit(SocialLoginErrorState(error.toString()));
    });
  }

  IconData suffix= Icons.visibility_outlined;
  bool isPasswordShown = true;
  void changePasswordVisibility(){
    isPasswordShown = !isPasswordShown;
    suffix= isPasswordShown ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(SocialLoginPasswordVisibilityState());
  }
}