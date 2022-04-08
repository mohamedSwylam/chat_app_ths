import 'dart:io';
import 'package:chat_app_th/shared/styles/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/custom_text_field.dart';
import '../../shared/styles/icon_broken.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class RegisterScreen extends StatefulWidget {
  static String id='RegisterScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = RegisterCubit.get(context);
        return Form(
          key: cubit.formKey,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                      height: 130,
                      child: Stack(
                        children: [
                          cubit.userImage==null ?
                      Center(
                        child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64.0,
                              backgroundColor:
                              Colors.black,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage('https://icons-for-free.com/iconfiles/png/512/man+person+profile+user+icon-1320073176482503236.png'),
                                radius: 60,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                cubit.pickUserImage();
                              },
                              icon: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: defaultColor,
                                  child: Icon(
                                    IconBroken.Camera,
                                    color: Colors.black,
                                    size: 16,
                                  )),
                              iconSize: 20,
                            ),
                          ],
                        ),
                      ): Center(
                        child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64.0,
                              backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                backgroundImage: FileImage(File(cubit.userImage!.path)),
                                radius: 60,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                cubit.pickUserImage();
                              },
                              icon: CircleAvatar(
                                  radius: 20,
                                  child: Icon(
                                    IconBroken.Camera,
                                    size: 16,
                                  )),
                              iconSize: 20,
                            ),
                          ],
                        ),
                      ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       Container(
                         child: CustomTextFormField(
                                labelText: "First Name",
                                inputType: TextInputType.text,
                                onChanged: (value) => cubit.onChangeFirstName(value),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter First name';
                                  }
                                },
                              ),
                         width: 150,
                       ),
                       SizedBox(width: 10,),
                       Container(
                         width: 150,
                         child: CustomTextFormField(
                                labelText: "Last Name",
                                inputType: TextInputType.text,
                                onChanged: (value) => cubit.onChangeLastName(value),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter Last name';
                                  }
                                },
                              ),
                       ),
                     ],
                   ),
                        SizedBox(height: 10,),
                        CustomTextFormField(
                          labelText: "Contact Number",
                          prefixText: '+20',
                          inputType: TextInputType.phone,
                          onChanged: (value) =>
                              cubit.onChangeContactNumber(value),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter contact number';
                            }
                          },
                        ),
                        SizedBox(height: 10,),
                        CustomTextFormField(
                          labelText: "Email address",
                          inputType: TextInputType.emailAddress,
                          onChanged: (value) => cubit.onChangeEmail(value),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter email Address';
                            }
                            bool isValid = (EmailValidator.validate(value));
                            if (isValid = false) {
                              return 'Invalid Email';
                            }
                          },
                        ),
                        SizedBox(height: 10,),
                        CustomTextFormField(
                          labelText: "Date Of Birth",
                          inputType: TextInputType.datetime,
                          onTap: (){
                            cubit.selectDateOfBirth(context);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Choose Date Of Birth';
                            }
                          },
                        ),
                        SizedBox (height: 10,),
                        CSCPicker(
                          ///Enable disable state dropdown [OPTIONAL PARAMETER]
                          showStates: true,

                          /// Enable disable city drop down [OPTIONAL PARAMETER]
                          showCities: true,

                          ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                          flagState: CountryFlag.DISABLE,

                          ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                          dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              border:
                              Border.all(color: Colors.grey.shade300, width: 1)),

                          ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                          disabledDropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              // color: Colors.grey.shade300,
                              border:
                              Border.all(color: Colors.grey.shade300, width: 1)),

                          ///placeholders for dropdown search field
                          countrySearchPlaceholder: "Country",
                          stateSearchPlaceholder: "State",
                          citySearchPlaceholder: "City",

                          ///labels for dropdown
                          countryDropdownLabel: "*Country",
                          stateDropdownLabel: "*State",
                          cityDropdownLabel: "*City",

                          ///Default Country
                          defaultCountry: DefaultCountry.Egypt,

                          ///Disable country dropdown (Note: use it with default country)
                          //disableCountry: true,

                          ///selected item style [OPTIONAL PARAMETER]
                          selectedItemStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),

                          ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                          dropdownHeadingStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),

                          ///DropdownDialog Item style [OPTIONAL PARAMETER]
                          dropdownItemStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),

                          ///Dialog box radius [OPTIONAL PARAMETER]
                          dropdownDialogRadius: 10.0,

                          ///Search bar radius [OPTIONAL PARAMETER]
                          searchBarRadius: 10.0,

                          ///triggers once country selected in dropdown
                          onCountryChanged: (value) {
                            cubit.onChangeCountry(value);
                          },

                          ///triggers once state selected in dropdown
                          onStateChanged: (value) {
                            cubit.onChangeState(value);

                          },

                          ///triggers once city selected in dropdown
                          onCityChanged: (value) {
                            cubit.onChangeCity(value);
                          },
                        ),
                        SizedBox(height: 10,),
                        DecoratedBox(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey.shade300),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                            child: DropdownButton(
                              borderRadius: BorderRadius.circular(10),
                              // Initial Value
                              value: cubit.gender,
                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),
                              // Array list of items
                              items: cubit.genderTypes.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (value) {
                                cubit.onChangeGender(value);
                              },
                              isExpanded: true,
                              hint: Text('Gender'),
                              underline: SizedBox(),
                              elevation: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            persistentFooterButtons: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: Text('Register'),
                        onPressed: () {
                          cubit.saveToDb(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
