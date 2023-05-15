import 'package:chatzy/firebase_services/apis.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../models/chat_usr.dart';
import '../../status_tab/status_horizontal_view.dart';
import 'charuserlist.dart';

class MessageTab extends StatefulWidget {
  const MessageTab({Key? key}) : super(key: key);

  @override
  State<MessageTab> createState() => _MessageTabState();
}

class _MessageTabState extends State<MessageTab>
    with SingleTickerProviderStateMixin {
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  late final TextEditingController _searchTextController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
    Apis.usersSelfInfo();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        _animationController.forward();
      } else {
        _animationController.reverse().whenComplete(() {
          _searchTextController
              .clear(); // clear search text when search is closed
        });
      }
    });
  }

  void _onSearchTextChanged(String searchText) {
    // handle search text changes here
    _searchList.clear();
    for (var i in _list) {
      if (i.name.toLowerCase().contains(searchText.trim().toLowerCase()) ||
          i.email.toLowerCase().contains(searchText.trim().toLowerCase())) {
        _searchList.add(i);
      }
      setState(() {
        _searchList;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchTextController.dispose();
    super.dispose();
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Container(
        margin: const EdgeInsets.only(top: 17),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
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
            Expanded(
              child: TextField(
                autofocus: true,
                cursorColor: Colors.black,
                controller: _searchTextController,
                onChanged: _onSearchTextChanged,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            IconButton(
              onPressed: _toggleSearch,
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatsHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Chats",
            style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: _toggleSearch,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.search),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _isSearching ? 75 : 110,
                curve: Curves.easeInOut,
                onEnd: () {
                  if (!_isSearching) {
                    _animationController.reset();
                  }
                },
                child: _isSearching ? _buildSearchBar() : _buildChatsHeader(),
              ),
              if (!_isSearching) const CircularStatus(),
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
                              itemCount:_isSearching ? _searchList.length : _list.length ,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(top: 16),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ChatUsersList(
                                  list:_isSearching ?_searchList[index]: _list[index],
                                );
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
      ),
    );
  }
}
