import 'package:bloc/bloc.dart';
import 'package:chat_app_th/modules/Login/login_screen.dart';
import 'package:chat_app_th/modules/register/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/firebase_service.dart';

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
   String? image;
   String? mobile;
   DateTime? dateOfBirth;
   String? gender;
   String? uid;
  String? landMark;
  String? address;
  var genderTypes = [
    'Male',
    'Female',
  ];
  onChangeFirstName(value) {
    gender = value;
    emit(OnChangeBusinessNameState());
  }
  onChangGender(value) {
    firstName = value;
    emit(OnChangeBusinessNameState());
  }
  onChangeLastName(value) {
    lastName = value;
    emit(OnChangeBusinessNameState());
  }
  onChangeContactNumber(value) {
    mobile = value;
    emit(OnChangeContactNumberState());
  }
  onChangeEmail(value) {
    email = value;
    emit(OnChangeEmailState());
  }
  onChangeAddress(value) {
    address = value;
    emit(OnChangeAddressState());
  }
  onChangeCity(value) {
    city = value;
    emit(OnChangeCityState());
  }
  onChangeCountry(value) {
    country = value;
    emit(OnChangeCountryState());
  }
  onChangeLandMark(value) {
    landMark = value;
    emit(OnChangeLandMark());
  }
  onChangeState(value) {
    statee = value;
    emit(OnChangeState());
  }
  onChangeGender(value) {
    gender = value;
    emit(OnChangeState());
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

  scaffold(message, context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
          },
        ),
      ),
    );
  }

  saveToDb(context) {
    if (userImage == null) {
      scaffold('Shop Image not selected', context);
      return;
    }
    if (formKey.currentState!.validate()) {
      if (country == null || city == null || statee == null) {
        scaffold('Selected address field completely', context);
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
  /*       service.addUser(data: {
            'shopImage': shopImageUrl,
            'logo': shopLogoUrl,
            'businessName': businessName,
            'mobile': '+2${contactNumber}',
            'email': emailAddress,
            'taxRegistered': taxStatus,
            'tinNumber': gstNumber == null ? null : gstNumber,
            'pinCode': pinCode,
            'LandMark': landMark,
            'country': country,
            'state': statee,
            'approved': false,
            'city': city,
            'uid': service.user!.uid,
            'time': DateTime.now(),
          });*/
          emit(SaveToDbSuccessState());
        }).then((value) {
          EasyLoading.dismiss();
          return Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => LoginScreen(),
            ),
          );
        }).catchError((error) {
          emit(SaveToDbErrorState(error.toString()));
        });

    }
  }
}
