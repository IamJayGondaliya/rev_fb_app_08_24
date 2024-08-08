class ChatModel {
  String msg;
  String time;
  String status;
  String type;

  ChatModel({
    required this.msg,
    required this.time,
    required this.status,
    required this.type,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        msg: json["msg"],
        time: json["time"],
        status: json["status"],
        type: json["type"],
      );

  Map<String, dynamic> get toJson => {
        "msg": msg,
        "time": time,
        "status": status,
        "type": type,
      };
}
