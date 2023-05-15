import 'package:flutter/material.dart';

class NotificationTab extends StatefulWidget {
  const NotificationTab({Key? key}) : super(key: key);

  @override
  State<NotificationTab> createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 17),
        child: Row(
          children: const [
            SizedBox(
                height:150
            ),
            Text(
              "Notification ",
              style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      )
    );
  }
}

