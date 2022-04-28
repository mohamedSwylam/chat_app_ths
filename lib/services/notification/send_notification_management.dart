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

}
