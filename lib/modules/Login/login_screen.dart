import 'package:chat_app_th/layout/app_layout.dart';
import 'package:chat_app_th/modules/register/register_screen.dart';
import 'package:chat_app_th/shared/components/custom_text_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/network/local/cache_helper.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class LoginScreen extends StatelessWidget {
  static String id = 'LoginScreen';
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context, state) {
          if (state is SocialLoginErrorState) {
            showSnackBar('Login Successfully', context);
          }
          if (state is SocialLoginSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              navigateAndFinish(context, AppLayout());
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Login now to communicate with friends',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        CustomTextFormField(
                          controller: emailController,
                          inputType: TextInputType.emailAddress,
                          labelText: 'Email address',
                          prefix: Icons.email_outlined,
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
                        SizedBox(
                          height: 14,
                        ),
                        CustomTextFormField(
                            controller: passwordController,
                            inputType: TextInputType.visiblePassword,
                            labelText: 'Password',
                            obscureText: SocialLoginCubit.get(context).isPasswordShown,
                            onSubmit: (value) {
                              if (formKey.currentState!.validate()) {
                                SocialLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            suffix: SocialLoginCubit.get(context).suffix,
                            suffixPress: () {
                              SocialLoginCubit.get(context)
                                  .changePasswordVisibility();
                            },
                            prefix: Icons.lock,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'InValid Password';
                              }
                            }),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  child: Text('Login'),
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      SocialLoginCubit.get(context).userLogin(
                                          email: emailController.text,
                                          password: passwordController.text);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account ? ',
                            ),
                    TextButton(
                      onPressed: (){
                        navigateTo(context, RegisterrScreen());
                      },
                      child: Text('Register'),
                    ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
