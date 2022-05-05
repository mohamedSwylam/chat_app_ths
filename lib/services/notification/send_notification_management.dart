import 'dart:convert';

import 'package:http/http.dart';


  Future<int> sendNotification(
      {required String token,
      required String body}) async {
    try {
      print("In Notification");

      final String _serverKey =
          "AAAAEIOZbL4:APA91bFhZGG9Jv5dmHUiDL6fzbPBJPwKTSKYICqYzAwIlt36eCGGYeJZRwryJo9MT-8V6AnrcUhk1Sr3WYMP3uM392LybID4KAIoox3DdonsxuBwS9zYIfHqZUQl3qahxjDsU3jfL8xm";

      final Response response = await post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization": "key=$_serverKey",
        },
        body: jsonEncode(<String, dynamic>{
          "notification": <String, dynamic>{
            "body": body,
            "title": title,
          },
          "priority": "high",
          "data": <String, dynamic>{
            "click": "FLUTTER_NOTIFICATION_CLICK",
            "id": "1",
            "status": "done",
            "collapse_key": "type_a",
          },
          "to": token,
        }),
      );

      print("Response is: ${response.statusCode}   ${response.body}");

      return response.statusCode;
    } catch (e) {
      print("Error in Notification Send: ${e.toString()}");
      return 404;
    }
  }
}
