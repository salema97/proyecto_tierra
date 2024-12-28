import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_tierra/src/pages/login_page.dart';
import 'package:proyecto_tierra/src/providers/auth_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  OneSignal.initialize("4af28393-b9c7-4e3c-a947-b8a060a4b1a1");
  OneSignal.Notifications.requestPermission(true);
  OneSignal.LiveActivities.setupDefault();

  OneSignal.Notifications.addForegroundWillDisplayListener((event) async {
    if (kDebugMode) {
      print(event.notification.title.toString());
      print(event.notification.body.toString());
    }
  });

  OneSignal.Notifications.addClickListener((event) async {
    if (kDebugMode) {
      print(event.notification.title.toString());
      print(event.notification.body.toString());
    }
  });

  runApp(ChangeNotifierProvider(create: (_) => AuthProvider(), child: const MyApp()));
}

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
          debugShowCheckedModeBanner: false,
          title: 'Proyecto Tesis',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 83, 234, 196)),
            useMaterial3: true,
          ),
          home: const LoginPage(),
        );
      },
    );
  }
}
