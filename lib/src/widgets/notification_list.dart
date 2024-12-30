import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:proyecto_tierra/src/providers/notification_provider.dart";

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return ListView.builder(
      itemCount: notificationProvider.notifications.length,
      itemBuilder: (context, index) {
        final notification = notificationProvider.notifications[index];

        return ListTile(
          title: Text(notification.title),
          subtitle: Text(notification.message),
          trailing: Text(
              '${notification.timestamp.day}/${notification.timestamp.month}/${notification.timestamp.year}'),
          onLongPress: () {
            notificationProvider.removeNotification(notification.id);
          },
        );
      },
    );
  }
}
