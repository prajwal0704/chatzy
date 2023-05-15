import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatzy/models/chat_usr.dart';
import 'package:flutter/material.dart';

class ChatDetailPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final  ChatUser user;
  const ChatDetailPageAppBar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: SizedBox(
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
                                  imageUrl: user.image,
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
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.height * .055,
                    height: MediaQuery.of(context).size.height * .055,
                    imageUrl: user.image,
                    //placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const CircleAvatar(
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
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      user.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      user.isOnline ? "Online" : "Offline",
                      style: TextStyle(
                          color: user.isOnline  ? Colors.green : Colors.red,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
