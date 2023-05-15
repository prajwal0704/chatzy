import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatzy/firebase_services/apis.dart';
import 'package:chatzy/models/chat_usr.dart';
import 'package:chatzy/models/message.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/MyDateUtil.dart';
import '../chat_tab/chatting_ui/chatdetailspage.dart';


class ChatUsersList extends StatefulWidget {
  final ChatUser list;
  const ChatUsersList(
      {super.key, required this.list,});
  @override
  _ChatUsersListState createState() => _ChatUsersListState();
}

class _ChatUsersListState extends State<ChatUsersList> {
  Messages? _message;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return  ChatDetailPage(user:widget.list);
        }));
      },
      child: Container(
        padding:
        const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(stream:Apis.getLastMessage(widget.list),builder: (context,snapshot) {
                final data = snapshot.data?.docs;
                final list=data?.map((e) => Messages.fromJson(e.data())).toList() ?? [];
                if(list.isNotEmpty) _message = list[0];
                return Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow:[
                          BoxShadow(
                            color: Colors.grey.shade400,
                            spreadRadius: .0,
                            blurRadius: 10,
                            offset: const Offset(5, 5),
                          ),
                          const BoxShadow(
                              color: Colors.white,
                              offset: Offset(-5,-5),
                              blurRadius: 15,
                              spreadRadius: 1
                          ) ,
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: Container(
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
                                          imageUrl: widget.list.image,
                                          //placeholder: (context, url) => CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                          const Icon(Icons.image,size: 70,)
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.height  * .077,
                            height: MediaQuery.of(context).size.height  * .077,
                            imageUrl: widget.list.image,
                            //placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Center(child: Icon(Icons.person,color: Colors.black,size: 50,)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(widget.list.name),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                if(_message?.type ==Type.image) const Icon(Icons.image,size: 20,),
                                Expanded(
                                  child: Text(
                                    _message!=null ? (_message!.type ==Type.image ? " image":_message!.msg):widget.list.about,maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey.shade500),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              ),
            ),
            Text(
              MyDateUtil.getFormattedTime(context: context, time:  widget.list.lastActive),
              style: TextStyle(
                  fontSize: 12,
                  color: widget.list.isOnline
                      ? Colors.black
                      : Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}