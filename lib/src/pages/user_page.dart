import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_tierra/src/providers/notification_provider.dart';
import 'package:proyecto_tierra/src/screens/notifications_screen.dart';
import 'package:proyecto_tierra/src/screens/user/extensometro_screen.dart';
import 'package:proyecto_tierra/src/screens/user/home_screen.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    const HomeScreen(),
    const ExtensometroScreen(),
    const NotificationsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar:
          Consumer<NotificationProvider>(builder: (context, notificationProvider, child) {
        int notificationCount = notificationProvider.getNotificationCount();
        return NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: <Widget>[
            const NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Inicio',
            ),
            const NavigationDestination(
              selectedIcon: Icon(Icons.view_list),
              icon: Icon(
                Icons.view_list_outlined,
              ),
              label: 'Extensómetros',
            ),
            NavigationDestination(
              selectedIcon: Badge(
                isLabelVisible: notificationCount > 0,
                label: Text(notificationCount.toString()),
                child: const Icon(Icons.notifications),
              ),
              icon: Badge(
                isLabelVisible: notificationCount > 0,
                label: Text(notificationCount.toString()),
                child: Icon(notificationCount > 0 ? Icons.notifications : Icons.notifications_none),
              ),
              label: 'Notificaciones',
            ),
          ],
        );
      }),
    );
  }
}