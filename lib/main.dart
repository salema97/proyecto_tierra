import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_tierra/src/pages/admin_page.dart';
import 'package:proyecto_tierra/src/pages/login_page.dart';
import 'package:proyecto_tierra/src/pages/role_selection_page.dart';
import 'package:proyecto_tierra/src/pages/user_page.dart';
import 'package:proyecto_tierra/src/providers/auth_provider.dart';
import 'package:proyecto_tierra/src/providers/notification_provider.dart';
import 'package:proyecto_tierra/src/models/notification.dart' as CustomNotification;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  OneSignal.initialize("4af28393-b9c7-4e3c-a947-b8a060a4b1a1");
  OneSignal.Notifications.requestPermission(true);
  OneSignal.LiveActivities.setupDefault();

  OneSignal.Notifications.addForegroundWillDisplayListener((event) async {
    final notificationProvider =
        Provider.of<NotificationProvider>(navigatorKey.currentContext!, listen: false);

    final notification = CustomNotification.Notification(
      id: event.notification.notificationId,
      title: event.notification.title ?? '',
      message: event.notification.body ?? '',
      timestamp: DateTime.now(),
    );

    await notificationProvider.addNotification(notification);
  });

  OneSignal.Notifications.addClickListener((event) async {
    final notificationProvider =
        Provider.of<NotificationProvider>(navigatorKey.currentContext!, listen: false);

    final notification = CustomNotification.Notification(
      id: event.notification.notificationId,
      title: event.notification.title ?? '',
      message: event.notification.body ?? '',
      timestamp: DateTime.now(),
    );

    await notificationProvider.addNotification(notification);
  });

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => NotificationProvider())
  ], child: const MyApp()));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Proyecto Tesis',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
            useMaterial3: true,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const LoginPage(),
            '/role-selection': (context) => const RoleSelectionPage(),
            '/admin': (context) => const AdminPage(),
            '/user': (context) => const UserPage(),
          },
        );
      },
    );
  }
}
