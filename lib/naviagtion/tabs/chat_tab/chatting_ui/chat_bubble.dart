import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:chatzy/models/message.dart';
import '../../../../firebase_services/apis.dart';
import '../../../../widgets/MyDateUtil.dart';
import 'package:video_player/video_player.dart';

import '../../../../widgets/vedioplayer.dart';

class ChatBubble extends StatefulWidget {
  const ChatBubble({Key? key, required this.messages}) : super(key: key);
  final Messages messages;
  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  late VideoPlayerController _controller;
  void _playVideo(String videoUrl) {
    _controller = VideoPlayerController.network(videoUrl);
    _controller.initialize().then((_) {
      setState(() {
        _controller.play();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMe = Apis.user.uid == widget.messages.fromId;
    if (!isMe) {
      Apis.updateMessageReadStatus(widget.messages);
    }
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isMe ? Colors.grey.shade300 : Colors.white,
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (widget.messages.type == Type.text)
                    Text(
                      widget.messages.msg,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    )
                  else if (widget.messages.type == Type.image)
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: isMe
                                      ? Colors.grey.shade300
                                      : Colors.white,
                                ),
                                width: double.infinity,
                                height: 400,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: InteractiveViewer(
                                    maxScale: 5,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      imageUrl: widget.messages.msg,
                                      //placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.image,
                                        size: 70,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.height * .3,
                          height: MediaQuery.of(context).size.height * .3,
                          imageUrl: widget.messages.msg,
                          placeholder: (context, url) => const Icon(
                            Icons.image,
                            size: 70,
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.image,
                            size: 70,
                          ),
                        ),
                      ),
                    )
                  else if (widget.messages.type == Type.video)
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: VideoPlayerWidget(url:widget.messages.msg,),
                            );
                          },
                        );
                      },
                      child: Stack(
                        children: [
                          Center(
                            child: IconButton(
                              icon: const Icon(Icons.play_circle_fill),
                              color: Colors.white,
                              iconSize: 70,
                              onPressed: () {
                                _playVideo(widget.messages.msg);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    content: SizedBox(
                                      height: 300,
                                      child: _controller.value.isInitialized
                                          ? AspectRatio(
                                              aspectRatio:
                                                  _controller.value.aspectRatio,
                                              child: VideoPlayer(_controller),
                                            )
                                          : Container(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.height * .3,
                              height: MediaQuery.of(context).size.height * .3,
                              imageUrl: widget.messages.msg,
                              placeholder: (context, url) => const Icon(
                                Icons.image,
                                size: 70,
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.image,
                                size: 70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Text(
                  MyDateUtil.getFormattedTime(
                      context: context, time: widget.messages.sent),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(width: 4),
                if (isMe)
                  widget.messages.read.isNotEmpty
                      ? Icon(
                          widget.messages.read == "read"
                              ? Icons.done_all
                              : Icons.done,
                          color: widget.messages.read == "read"
                              ? Colors.blue
                              : Colors.grey,
                          size: 18,
                        )
                      : const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
