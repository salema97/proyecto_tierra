import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_tierra/src/providers/notification_provider.dart';
import 'package:proyecto_tierra/src/utils/header_widget.dart';
import 'package:proyecto_tierra/src/widgets/notification_list.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    return Scaffold(
      body: const Column(
        children: [
          HeaderWidget(),
          Expanded(child: NotificationList()),
        ],
      ),
      floatingActionButton: notificationProvider.getNotificationCount() > 0
          ? FloatingActionButton(
              mini: true,
              elevation: 1,
              backgroundColor: Colors.red[100],
              onPressed: () {
                notificationProvider.clearNotifications();
              },
              child: const Icon(
                Icons.delete,
                color: Colors.red,
                size: 28,
              ),
            )
          : null,
    );
  }
}
