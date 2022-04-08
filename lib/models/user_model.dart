import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? firstName;
  final String? lastName;
  final String? city;
  final String? state;
  final String? country;
  final String? landMark;
  final String? email;
  final String? image;
  final String? mobile;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? uid;

  UserModel({this.firstName, this.lastName, this.city, this.state, this.country,
    this.email, this.image, this.mobile,this.landMark,
    this.dateOfBirth, this.gender, this.uid,});

  UserModel.fromJson(Map<String, Object?> json)
      : this(
    firstName:json['firstName']! as String,
    landMark:json['landMark']! as String,
    lastName:json ['lastName']! as String,
    city: json['city']! as String,
    state: json['state']! as String,
    country: json['country']! as String,
    email: json['email']! as String,
    image: json['image']! as String,
    mobile: json ['mobile'] as String,
    dateOfBirth: json['dateOfBirth']! as DateTime,
    gender: json['gender']! as String,
    uid: json['uid']! as String,
  );
  Map<String, Object?> toJson() {
    return {
      'firstName':firstName,
      'lastName':lastName,
      'landMark':landMark,
      'city' :city,
      'state':state,
      'country':country,
      'email':email,
      'image':image,
      'mobile':mobile,
      'dateOfBirth':dateOfBirth,
      'gender' :gender,
      'uid':uid
    };
  }
}

