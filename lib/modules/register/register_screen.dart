import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/custom_text_field.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class RegisterScreen extends StatelessWidget {
  static String id='RegisterScreen';
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
                  SizedBox(
                    height: 240,
                    child: Stack(
                      children: [
                        cubit.shopImage==null?
                        Container(
                          color: Colors.blue,
                          height: 240,
                          child: TextButton(
                            onPressed: (){
                              cubit.pickShopImage();
                            },
                            child: Center(
                              child: Text(
                                'Tap to add User image',
                                style: TextStyle(color: Colors.grey.shade800),
                              ),
                            ),
                          ),
                        ): InkWell(
                          onTap: (){
                            cubit.pickShopImage();
                          },
                          child: Container(
                            height: 240,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              image: DecorationImage(
                                image: FileImage(File(cubit.shopImage!.path)),
                                fit: BoxFit.cover,
                                opacity: 110,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 80,
                          child: AppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            actions: [
                              IconButton(
                                icon: const Icon(Icons.exit_to_app),
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                },
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: (){
                                    cubit.pickLogoShopImage();
                                  },
                                  child: Card(
                                    elevation: 4,
                                    child: cubit.logoShopImage==null ? SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Center(child: Text('+')),
                                    ): ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: Image.file(File(cubit.logoShopImage!.path),),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  cubit.businessName == null
                                      ? ''
                                      : cubit.businessName!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
                    child: Column(
                      children: [
                        CustomTextFormField(
                          controller: cubit.businessNameController,
                          labelText: "Business name",
                          inputType: TextInputType.text,
                          onChanged: (value) => cubit.onChangeBusinessName(value),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Business name';
                            }
                          },
                        ),
                        CustomTextFormField(
                          controller: cubit.contactNumberController,
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
                        CustomTextFormField(
                          controller: cubit.contactNumberController,
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
                        Row(
                          children: [
                            const Text('Tax Registered:'),
                            Expanded(
                              child: DropdownButtonFormField(
                                value: cubit.taxStatus,
                                validator: (value) {
                                  if (value==null) {
                                    return 'Select Tax status';
                                  }
                                },
                                hint: const Text('Select'),
                                items: <String>['Yes', 'No']
                                    .map<DropdownMenuItem<String>>((
                                    String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) =>
                                    cubit.onChangeTaxRegistered(value),
                              ),
                            ),
                          ],
                        ),
                        if(cubit.taxStatus == 'Yes')
                          CustomTextFormField(
                            controller: cubit.gstNumberController,
                            labelText: "Gst Number",
                            inputType: TextInputType.phone,
                            onChanged: (value) => cubit.onChangeGstNumber(value),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Gst Number';
                              }
                            },
                          ),
                        CustomTextFormField(
                          controller: cubit.pinCodeController,
                          labelText: "Pin Code",
                          inputType: TextInputType.number,
                          onChanged: (value) => cubit.onChangePinCode(value),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Pin Code';
                            }
                          },
                        ),
                        CustomTextFormField(
                          controller: cubit.landMarkController,
                          labelText: "landMark",
                          inputType: TextInputType.number,
                          onChanged: (value) => cubit.onChangeLandMark(value),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter landMark';
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
