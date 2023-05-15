class Messages {
  Messages({
    required this.msg,
    required this.toId,
    required this.read,
    required this.type,
    required this.sent,
    required this.fromId,
  });
  late final String msg;
  late final String toId;
  late final String read;
  late final Type type;
  late final String sent;
  late final String fromId;

  Messages.fromJson(Map<String, dynamic> json){
    msg = json['msg'].toString();
    toId = json['toId'].toString();
    read = json['read'].toString();
    type = json['type'].toString() == Type.image.name
        ? Type.image
        : json['type'].toString() == Type.video.name
        ? Type.video
        : json['type'].toString() == Type.audio.name
        ? Type.audio
        : Type.text;


    sent = json['sent'].toString();
    fromId = json['fromId'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    data['toId'] = toId;
    data['read'] = read;
    data['type'] = type.name;
    data['sent'] = sent;
    data['fromId'] = fromId;
    return data;
  }
}
enum Type{text, image,video, audio}