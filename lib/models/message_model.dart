class MessageModel {
  String? senderID;
  String? type;
  String? receiverId;
  String? dateTime;
  String? message;

  MessageModel({
    this.senderID,
    this.receiverId,
    this.type,
    this.dateTime,
    this.message,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    senderID = json['senderID'];
    receiverId = json['receiverId'];
    type = json['type'];
    dateTime = json['dateTime'];
    message = json['message'];

  }
  Map<String, Object?> toJson() {
    return {
      'senderID':senderID,
      'type':type,
      'receiverId':receiverId,
      'dateTime':dateTime,
      'message' :message,
    };
  }
}