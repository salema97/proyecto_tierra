import 'package:flutter/material.dart';
import 'package:proyecto_tierra/src/utils/header_widget.dart';
import 'package:proyecto_tierra/src/widgets/notification_list.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          HeaderWidget(),
          Expanded(child: NotificationList()),
        ],
      ),
    );
  }
}
