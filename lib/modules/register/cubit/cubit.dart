import 'package:bloc/bloc.dart';
import 'package:chat_app_th/modules/Login/login_screen.dart';
import 'package:chat_app_th/modules/register/cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/firebase_service.dart';
import 'package:intl/intl.dart';

import '../../../shared/components/components.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);
  FirebaseService service = FirebaseService();
  final formKey = GlobalKey<FormState>();
  TextEditingController? businessNameController;
   String? firstName;
   String? lastName;
   String? city;
   String? statee;
   String? country;
   String? email;
   String? password;
   String? image;
   String? mobile;
   String? gender;
   String? uid;
  String? address;
  var genderTypes = [
    'Male',
    'Female',
  ];
  var dateOfBirthController = TextEditingController();
  Future<void> selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900, 8),
        lastDate: DateTime.now(),);
    if (picked != null && picked != dateOfBirthController) {
      dateOfBirthController.text =
            DateFormat.yMMMd().format(picked);
        emit(SelectedDateOfBirthSuccessState());
    }
  }
  onChangeFirstName(value) {
    firstName = value;
    emit(OnChangeFirstNameState());
  }
  onChangeLastName(value) {
    lastName = value;
    emit(OnChangeLastNameState());
  }
  onChangeContactNumber(value) {
    mobile = value;
    emit(OnChangeContactNumberState());
  }
  onChangeEmail(value) {
    email = value;
    emit(OnChangeEmailState());
  }
  onChangePassword(value) {
    password = value;
    emit(OnChangePasswordState());
  }
  onChangeCity(value) {
    city = value;
    emit(OnChangeCityState());
  }
  onChangeCountry(value) {
    country = value;
    emit(OnChangeCountryState());
  }
  onChangeState(value) {
    statee = value;
    emit(OnChangeState());
  }
  onChangeGender(value) {
    gender = value;
    emit(OnChangeGenderState());
  }
  void userRegister(BuildContext context) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!)
        .then((value) {
      saveToDb(context);
    }).catchError((error) {
      emit(RegisterErrorState(error.toString()));
    });
  }
  final ImagePicker picker = ImagePicker();
  XFile? userImage;
  String? userImageUrl;
  Future<XFile?> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }
  pickUserImage() {
    pickImage().then((value) {
      userImage = value;
      emit(PickUserImageSuccessState());
    }).catchError((error) {
      emit(PickUserImageErrorState(error.toString()));
    });
  }



  saveToDb(context) {
    if (userImage == null) {
      showSnackBar('Shop Image not selected', context);
      return;
    }
    if (formKey.currentState!.validate()) {
      if (country == null || city == null || statee == null) {
        showSnackBar('Selected address field completely', context);
        return;
      }
      EasyLoading.show(status: 'Please wait..');
      service
          .uploadImage(userImage, 'Users/${service.user!.uid}/userImage.jpg')
          .then((String? url) {
        if (url != null) {
          userImageUrl = url;
          emit(SaveToDbSuccessState());
        }
      }).then((value) {
        service.addUser(data: {
            'userImage': userImageUrl,
            'firstName': firstName,
            'lastName': lastName,
            'mobile': '+2${mobile}',
            'email': email,
            'country': country,
            'state': statee,
            'city': city,
            'gender': gender,
            'uid': service.user!.uid,
            'dataOfBirth': dateOfBirthController.text,
          });
          emit(SaveToDbSuccessState());
        }).then((value) {
          EasyLoading.dismiss();
          return Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => SignInScreen(),
            ),
          );
        }).catchError((error) {
          emit(SaveToDbErrorState(error.toString()));
        });

    }
  }
}
