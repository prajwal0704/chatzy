import 'dart:developer';
import 'dart:io';

import 'package:chatzy/models/chat_usr.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/message.dart';

class Apis {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static late ChatUser userSelfData;

  static Future<bool> userExists() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser?.uid)
            .get())
        .exists;
  }

  static Future<void> updateUserInfo(Map<String, dynamic> data) async {
    await firestore.collection('users').doc(auth.currentUser?.uid).update(data);
  }

  static Future<void> usersSelfInfo() async {
    await firestore
        .collection('users')
        .doc(auth.currentUser?.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        userSelfData = ChatUser.fromJson(user.data()!);
      } else {
        await createUser('').then((value) => getallusers());
      }
    });
  }

  static User get user => auth.currentUser!;
  static Future<void> createUser(String name) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatuser = ChatUser(
        id: user.uid,
        image: user.photoURL.toString(),
        about: user.photoURL.toString(),
        name: name,
        createdAt: time,
        isOnline: false,
        lastActive: time,
        email: user.email.toString(),
        pushToken: '',
        phone: '',
      story: {
        'caption': [],
        'type': [],
        'url': [],
      },
    );
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatuser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getallusers() {
    return Apis.firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getallMessages(
      ChatUser user) {
    return Apis.firestore
        .collection('chats/${getConversationId(user.id)}/messages/')
        .snapshots();
  }

  static Future<void> updateProfilePic(File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child("profile_picture/${user.uid}.$ext");
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) => log('data transfered ${p0.bytesTransferred / 1000} kb'));
    userSelfData.image = await ref.getDownloadURL();
    //await firestore.collection('users').doc(user.uid).update({'image' : userSelfData.image});
    updateUserInfo({'image': userSelfData.image});
  }

  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  static Future<void> sendMessage(ChatUser chatUser, String msg,Type type) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Messages message = Messages(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time);

    final ref = firestore
        .collection('chats/${getConversationId(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  static Future<void> updateMessageReadStatus(Messages message) async {
    firestore
        .collection('chats/${getConversationId(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationId(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatFile(ChatUser chatUser, File file, String Type) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child("chatFiles/${getConversationId(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext");

    // Upload file to Firebase Storage
    await ref
        .putFile(file, SettableMetadata(contentType: '$Type/$ext'))
        .then((p0) => log('data transfered ${p0.bytesTransferred / 1000} kb'));

    // Get download URL for the uploaded file
    final downloadUrl = await ref.getDownloadURL();

    // Send message to Firestore
    await sendMessage(chatUser, downloadUrl, getTypeString(Type));
  }
  static Type getTypeString(String type) {
    switch (type) {
      case 'image':
        return Type.image;
      case 'audio':
        return Type.audio;
      case 'video':
        return Type.video;
      default:
        return Type.text;
    }
  }



}
