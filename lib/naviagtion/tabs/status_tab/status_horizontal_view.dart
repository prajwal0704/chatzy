import 'package:chatzy/naviagtion/tabs/status_tab/story_view.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:status_view/status_view.dart';

import '../../../firebase_services/apis.dart';
import '../../../models/chat_usr.dart';

class CircularStatus extends StatefulWidget {
  const CircularStatus({Key? key}) : super(key: key);

  @override
  State<CircularStatus> createState() => _CircularStatusState();
}

// class _CircularStatusState extends State<CircularStatus> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 100,
//       child: StreamBuilder(
//         stream: Apis.getallusers(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
//             return  Center(
//               child: Row(
//                 children: [
//                   const SizedBox(width: 15,),
//                   Shimmer.fromColors(
//                     baseColor: Colors.grey[300]!,
//                     highlightColor: Colors.grey[100]!,
//                     child: Padding(
//                       padding: const EdgeInsets.all(5.0),
//                       child: Container(
//                         width: 75,
//                         height: 75,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(50.0),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Shimmer.fromColors(
//                     baseColor: Colors.grey[300]!,
//                     highlightColor: Colors.grey[100]!,
//                     child: Padding(
//                       padding: const EdgeInsets.all(5.0),
//                       child: Container(
//                         width: 75,
//                         height: 75,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(50.0),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Shimmer.fromColors(
//                     baseColor: Colors.grey[300]!,
//                     highlightColor: Colors.grey[100]!,
//                     child: Padding(
//                       padding: const EdgeInsets.all(5.0),
//                       child: Container(
//                         width: 75,
//                         height: 75,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(50.0),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Shimmer.fromColors(
//                     baseColor: Colors.grey[300]!,
//                     highlightColor: Colors.grey[100]!,
//                     child: Padding(
//                       padding: const EdgeInsets.all(5.0),
//                       child: Container(
//                         width: 75,
//                         height: 75,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(50.0),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           } else {
//               return Align(
//                 alignment: Alignment.centerLeft,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: 2+1, // increase itemCount by 1 to add the StatusaddInit() widget
//                   shrinkWrap: true,
//                   padding: const EdgeInsets.only(top: 16),
//                   itemBuilder: (context, index) {
//                     if (index == 0) {
//                       // return the StatusaddInit() widget as the first widget
//                       return StatusaddInit();
//                     } else {
//                       // adjust the index to account for the extra widget
//                       index--;
//                       return GestureDetector(
//                         onTap: (){
//                           print("tapped");
//                           Navigator.of(context).push(
//                               MaterialPageRoute(builder: (context) => MoreStories(story: {},)));
//                         },
//                         child: Container(
//                             margin: const EdgeInsets.only(right: 10),
//                             child: StatusView(
//                               radius: 35,
//                               spacing: 10,
//                               strokeWidth: 3,
//                               indexOfSeenStatus: 4,
//                               numberOfStatus: 5,
//                               padding: 4,
//                               centerImageUrl: "https://picsum.photos/200/300",
//                               seenColor: Colors.grey,
//                               unSeenColor: Colors.black,
//                             )),
//                       );
//                     }
//                   },
//                 ),
//               );
//           }
//         },
//       ),
//     );
//   }
//
//   InkResponse StatusaddInit() {
//     return InkResponse(
//       onTap: () async {},
//       child: Container(
//           margin: const EdgeInsets.all(8.0),
//           width: 80.0,
//           height: 80.0,
//           decoration: const BoxDecoration(
//             color: Colors.black,
//             shape: BoxShape.circle,
//           ),
//           child: const Icon(
//             Icons.add,
//             color: Colors.white,
//           )),
//     );
//   }
// }
class _CircularStatusState extends State<CircularStatus> {
  List<ChatUser> _list = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: StreamBuilder(
          stream: Apis.getallusers(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
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
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _list.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 16),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final captionCount = _list[index].story['caption']
                            ?.length ?? 0;
                        return captionCount != 0 ?
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            if(index == 0)
                              GestureDetector(
                                onTap: () {},
                                child: const CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: 35,
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            if(index == 0)
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        MoreStories(
                                          story: _list[index].story,)));
                              },
                              child: StatusView(
                                radius: 35,
                                spacing: 10,
                                strokeWidth: 3,
                                indexOfSeenStatus: captionCount - 1,
                                numberOfStatus: captionCount,
                                padding: 4,
                                centerImageUrl: "https://picsum.photos/200/300",
                                seenColor: Colors.grey,
                                unSeenColor: Colors.black,
                              ),
                            ),
                          ],
                        ) : Container();
                      },
                    ),
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
    );
  }
}

