import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatzy/models/chat_usr.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../firebase_services/apis.dart';
import '../../../../models/message.dart';
import 'chat_bubble.dart';
import 'chatappbar.dart';
import 'chatbottom_text_field.dart';

enum MessageType {
  sender,
  receiver,
}
class ChatDetailPage extends StatefulWidget {
  final ChatUser user;
  const ChatDetailPage({
    super.key,
    required this.user,
  });

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}
class _ChatDetailPageState extends State<ChatDetailPage> {
  final _scrollController = ScrollController();
  final _textFieldFocusNode = FocusNode();
  List<Messages> _list = [];
  @override
  void dispose() {
    _scrollController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: ChatDetailPageAppBar(user: widget.user),
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: Apis.getallMessages(widget.user),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Center(
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: const Padding(
                            padding: EdgeInsets.all(5.0),
                          ),
                        ),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      _list = data
                          ?.map((e) => Messages.fromJson(e.data()))
                          .toList()
                          .reversed
                          .toList() ??
                          [];
                      if (_list.isNotEmpty) {
                        return ListView.builder(
                          reverse: true,
                          itemCount: _list.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 16),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ChatBubble(messages: _list[index],);
                          },
                          controller: _scrollController, // <-- add controller here
                        );
                      } else {
                        return  Center(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30 * 4),
                                child: InteractiveViewer(
                                  maxScale: 5,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.height *
                                        .077 *
                                        2.7,
                                    height: MediaQuery.of(context).size.height *
                                        .077 *
                                        2.7,
                                    imageUrl: widget.user.image,
                                    errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Center(
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.black,
                                            size: 50,
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                widget.user.name,
                                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }
                  }
                },
              ),
            ),
            ChatInputField(
              focusNode: _textFieldFocusNode,
              onSendMessage: (String message) {
                setState(() {
                  Apis.sendMessage(widget.user, message,Type.text);
                  _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                });
              }, user: widget.user,
            ),
          ],
        ),
      ),
    );
  }
}
