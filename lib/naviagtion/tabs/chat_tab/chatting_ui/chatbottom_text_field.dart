import 'dart:io';

import 'package:chatzy/firebase_services/apis.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../models/chat_usr.dart';
import 'chat_menu_items.dart';

class ChatInputField extends StatefulWidget {
  final ChatUser user;

  final Function(String message) onSendMessage;

  const ChatInputField(
      {Key? key,
      required this.onSendMessage,
      required FocusNode focusNode,
      required this.user})
      : super(key: key);

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  late ChatUser user = widget.user;
  final TextEditingController _textEditingController = TextEditingController();
  bool _isComposing = false;
  List<SendMenuItems> menuItems = [
    SendMenuItems(
        text: "Photos & Videos", icons: Icons.image, color: Colors.amber),
    SendMenuItems(
        text: "Document", icons: Icons.insert_drive_file, color: Colors.blue),
    SendMenuItems(text: "Audio", icons: Icons.music_note, color: Colors.orange),
    SendMenuItems(
        text: "Location", icons: Icons.location_on, color: Colors.green),
    SendMenuItems(text: "Contact", icons: Icons.person, color: Colors.purple),
  ];

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void showModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            color: const Color(0xff737373),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
              ),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: Container(
                      height: 5,
                      width: 50,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: ListTile(
                  onTap: () {
                    selectVedio();
                  },
                  leading: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: menuItems[0].color.shade50,
                    ),
                    height: 50,
                    width: 50,
                    child: Icon(
                      menuItems[0].icons,
                      size: 20,
                      color: menuItems[0].color.shade400,
                    ),
                  ),
                  title: Text(menuItems[0].text),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: ListTile(
                  onTap: () {
                    selectDocument();
                  },
                  leading: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: menuItems[1].color.shade50,
                    ),
                    height: 50,
                    width: 50,
                    child: Icon(
                      menuItems[1].icons,
                      size: 20,
                      color: menuItems[1].color.shade400,
                    ),
                  ),
                  title: Text(menuItems[1].text),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: ListTile(
                  onTap: () {
                    selectAudio();
                  },
                  leading: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: menuItems[2].color.shade50,
                    ),
                    height: 50,
                    width: 50,
                    child: Icon(
                      menuItems[2].icons,
                      size: 20,
                      color: menuItems[2].color.shade400,
                    ),
                  ),
                  title: Text(menuItems[2].text),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: ListTile(
                  onTap: () {
                    selectLocation();
                  },
                  leading: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: menuItems[3].color.shade50,
                    ),
                    height: 50,
                    width: 50,
                    child: Icon(
                      menuItems[3].icons,
                      size: 20,
                      color: menuItems[3].color.shade400,
                    ),
                  ),
                  title: Text(menuItems[3].text),
                ),
              ),Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: ListTile(
                onTap: () {
                  selectContact();
                },
                leading: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: menuItems[4].color.shade50,
                  ),
                  height: 50,
                  width: 50,
                  child: Icon(
                    menuItems[4].icons,
                    size: 20,
                    color: menuItems[4].color.shade400,
                  ),
                ),
                title: Text(menuItems[4].text),
              ),
            )
                ],
              ),
            ),
          );
        });
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            spreadRadius: 1,
            blurRadius: 15,
            offset: const Offset(5, 4),
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-5, -5),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 290,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.grey[100],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.emoji_emotions),
                  onPressed: () {
                    // TODO: Implement emoji button functionality
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    onChanged: (String text) {
                      setState(() {
                        _isComposing = text.trim().isNotEmpty;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'message',
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {
                    showModal();
                  },
                ),
                if (_isComposing == false)
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();

                      // Pick an image
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 50);
                      if (image != null) {
                        await Apis.sendChatFile(
                            widget.user, File(image.path), 'image');
                      }
                    },
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              radius: 25,
              child: _isComposing
                  ? IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        String message = _textEditingController.text.trim();
                        if (message.isNotEmpty) {
                          widget.onSendMessage(message);
                          _textEditingController.clear();
                          setState(() {
                            _isComposing = false;
                          });
                        }
                      },
                    )
                  : GestureDetector(
                      child: const Icon(
                        Icons.mic,
                        color: Colors.white,
                      ),
                      onLongPress: () {},
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void selectVedio() async {
    final ImagePicker picker = ImagePicker();

    // Pick a video
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      await Apis.sendChatFile(widget.user, File(video.path), 'video');
    }
  }

  void selectDocument() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      final File file = File(result.files.single.path!);
      await Apis.sendChatFile(widget.user, file, 'document');
    }
  }

  void selectAudio() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav'],
    );

    if (result != null) {
      final File file = File(result.files.single.path!);
      await Apis.sendChatFile(widget.user, file, 'audio');
    }
  }

  void selectLocation() async {
    // TODO: Implement select location functionality
  }

  void selectContact() async {
    // TODO: Implement select contact functionality
  }
}
