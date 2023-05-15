import 'package:chatzy/naviagtion/tabs/status_tab/story_view.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:status_view/status_view.dart';
import 'package:whatsapp_story_editor/whatsapp_story_editor.dart';
import '../../../firebase_services/apis.dart';
import '../../../models/chat_usr.dart';

class StatusTab extends StatefulWidget {
  const StatusTab({
    Key? key,
  }) : super(key: key);

  @override
  State<StatusTab> createState() => _StatusTabState();
}

class _StatusTabState extends State<StatusTab> {
  List<ChatUser> _list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Status",
                  style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
                stream: Apis.getallusers(),
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
                              ?.map((e) => ChatUser.fromJson(e.data()))
                              .toList() ??
                          [];
                      if (_list.isNotEmpty) {
                        return ListView.builder(
                          itemCount: _list.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 16),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final captionCount =
                                _list[index].story['caption']?.length ?? 0;
                            return captionCount != 0
                                ? Column(
                                    children: [
                                      if (index == 0)
                                        GestureDetector(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              const SizedBox(
                                                width: 15,
                                              ),
                                               CircleAvatar(
                                                  backgroundColor: Colors.black,
                                                  radius: 30,
                                                  child: IconButton(
                                                      onPressed: () async {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => const WhatsappStoryEditor()),
                                                        ).then((whatsappStoryEditorResult) {
                                                          if (whatsappStoryEditorResult != null) {
                                                            // Apis.updateUserInfo(
                                                            //   "story['caption'][${captionCount+1}]": whatsappStoryEditorResult.imagez
                                                            //   // image: whatsappStoryEditorResult.image,
                                                            //   // caption: whatsappStoryEditorResult.caption,
                                                            // );
                                                          }
                                                        });
                                                      },
                                                      icon: const Icon(Icons.add))),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: const [
                                                  Text(
                                                    "My status",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 17),
                                                  ),
                                                  Text(
                                                      "Tap here to update status",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black45))
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          ),
                                        ),
                                      if (index == 0)
                                        Padding(
                                          padding: const EdgeInsets.all(9.0),
                                          child: Row(
                                            children: const [
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Status",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MoreStories(
                                                        story:
                                                            _list[index].story,
                                                      )));
                                        },
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                StatusView(
                                                  radius: 30,
                                                  spacing: 10,
                                                  strokeWidth: 3,
                                                  indexOfSeenStatus:
                                                      captionCount - 1,
                                                  numberOfStatus: captionCount,
                                                  padding: 4,
                                                  centerImageUrl:
                                                      "https://picsum.photos/200/300",
                                                  seenColor: Colors.grey,
                                                  unSeenColor: Colors.black,
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      _list[index].name,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 17),
                                                    ),
                                                    const Text("10:00 am",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45))
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Container();
                          },
                        );
                      } else {
                        return const Center(
                          child: Text(
                            'no connections flound',
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }
                  }
                }),
          ],
        ),
      ),
    );
  }
}

