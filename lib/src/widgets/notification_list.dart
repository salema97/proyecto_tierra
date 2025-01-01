import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:provider/provider.dart";
import "package:proyecto_tierra/src/providers/notification_provider.dart";

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      itemCount: notificationProvider.notifications.length,
      itemBuilder: (context, index) {
        final notification = notificationProvider.notifications[index];

        return Dismissible(
          key: Key(notification.id),
          onDismissed: (direction) {
            notificationProvider.removeNotification(notification.id);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Notificación eliminada"),
              backgroundColor: Colors.red,
            ));
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 10.h),
            elevation: 1,
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    Icon(Icons.notifications_active, size: 20.sp),
                    SizedBox(width: 6.w),
                    Text(notification.title,
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(notification.message, style: TextStyle(fontSize: 14.sp)),
                SizedBox(height: 4.h),
                Text(
                    '${notification.timestamp.day}/${notification.timestamp.month}/${notification.timestamp.year}',
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
              ]),
            ),
          ),
        );
      },
    );
  }
}
