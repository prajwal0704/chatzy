import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../models/tab_item.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({Key? key, required this.onTabChange}) : super(key: key);
  final Function(int tabIndex) onTabChange;
  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  final List<TabItem> _icons = TabItem.tabItemsList;
  int _selectedTab = 0;
  SMIBool? status;

  void _onRiveIconInit(Artboard artboard,index) {
    final controller =
        StateMachineController.fromArtboard(artboard, _icons[index].stateMachine);
    artboard.addController(controller!);
    _icons[index].status = controller.findInput<bool>("active") as SMIBool;
  }

  void onTapPress(int index) {
    if (_selectedTab != index) {
      setState(() {
        _selectedTab = index;
      });
      widget.onTabChange(index);
    }
      _icons[index].status!.change(true);
      Future.delayed(const Duration(seconds: 1), () {
        _icons[index].status!.change(false);
      });
    }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      margin: const EdgeInsets.fromLTRB(30, 0, 30, 8),
      padding: const EdgeInsets.all(1),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.9),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 20))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_icons.length, (index) {
            TabItem icon = _icons[index];
            return Expanded(
              key: icon.id,
              child: CupertinoButton(
                padding: const EdgeInsets.all(12),
                onPressed: (){
                  onTapPress(index);
                },
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200 ),
                  opacity: _selectedTab == index ? 1 : 0.5,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: RiveAnimation.asset(
                          "assets/icons.riv",
                          stateMachines: [icon.stateMachine],
                          artboard: icon.artboard,
                          onInit: (artboard){_onRiveIconInit(artboard,index);}
                          ,
                        ),
                      ),
                      Positioned(
                        bottom: -4,
                        child: AnimatedContainer(
                          height: 3,
                          width: _selectedTab == index ? 25 : 0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ), duration: const Duration(milliseconds: 300),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    ));
  }
}
