class ChatUser {
  ChatUser({
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.id,
    required this.lastActive,
    required this.email,
    required this.pushToken,
    required this.phone,
    required this.story, // new field
  });

  late String image;
  late String about;
  late String name;
  late String createdAt;
  late bool isOnline;
  late String id;
  late String lastActive;
  late String email;
  late String pushToken;
  late String phone;
  late Map<String, List<String>> story; // new field

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    about = json['about'] ?? '';
    name = json['name'] ?? '';
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'] ?? false;
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
    phone = json['phone'] ?? '';
    story = {
      'caption': (json['story']?['caption'] ?? []).cast<String>(),
      'type': (json['story']?['type'] ?? []).cast<String>(),
      'url': (json['story']?['url'] ?? []).cast<String>(),
    };
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['email'] = email;
    data['push_token'] = pushToken;
    data['phone'] = phone;
    data['story'] = {
      'caption': story['caption'],
      'type': story['type'],
      'url': story['url'],
    };
    return data;
  }
}