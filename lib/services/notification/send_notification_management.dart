import 'dart:convert';

import 'package:http/http.dart';

class SendNotification {
  Future<void> messageNotificationClassifier(String messageTypes,
      {String textMsg = "",
      required String connectionToken,
      required String currAccountUserName}) async {
    switch (messageTypes) {
      case 'None':
        break;
      case 'text':
        await sendNotification(
            token: connectionToken,
            title: "$currAccountUserName Send a Message",
            body: textMsg);
        break;
      case 'img':
        await sendNotification(
            token: connectionToken,
            title: "$currAccountUserName Send a Image",
            body: "");
        break;
      case 'video':
        await sendNotification(
            token: connectionToken,
            title: "$currAccountUserName Send a Video",
            body: "");
        break;
      case 'document':
        await sendNotification(
            token: connectionToken,
            title: "$currAccountUserName Send a Document",
            body: "");
        break;
      case 'audio':
        await sendNotification(
            token: connectionToken,
            title: "$currAccountUserName Send a Audio",
            body: "");
        break;
      case 'location':
        await sendNotification(
            token: connectionToken,
            title: "$currAccountUserName Send a Location",
            body: "");
        break;
    }
  }

  Future<int> sendNotification(
      {required String token,
      required String title,
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
