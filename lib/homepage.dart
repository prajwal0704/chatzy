import 'package:chatzy/naviagtion/tabs/notificationtab.dart';
import 'package:chatzy/naviagtion/tabs/profile%20/profile.dart';
import 'package:chatzy/naviagtion/tabs/status_tab/statustab.dart';
import 'package:flutter/material.dart';
import 'naviagtion/customtabbar.dart';
import 'naviagtion/tabs/chat_tab/main_chat/hometab.dart';

class HomePage extends StatefulWidget {
  final int selectedIndex;
  const HomePage({Key? key,this.selectedIndex=0}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _tabBody = Container(color: Colors.white,);
  final List<Widget> _screens = [
    const MessageTab(),
    const StatusTab(),
    const NotificationTab(),
    const ProfileTab(),
  ];
  @override
  void initState(){
    _tabBody = _screens[widget.selectedIndex];
    super.initState();
  }
  void route(int index){
    setState(() {
      _tabBody=_screens[index];
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _tabBody,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: CustomTabBar(
          onTabChange: (tabIndex) {
            setState(() {
              _tabBody=_screens[tabIndex];
            });
          },
        ),
      ),
    );
  }
}
