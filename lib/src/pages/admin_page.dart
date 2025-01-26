import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_tierra/src/providers/notification_provider.dart';
import 'package:proyecto_tierra/src/screens/notifications_screen.dart';
import 'package:proyecto_tierra/src/screens/user/extensometro_screen.dart';
import 'package:proyecto_tierra/src/screens/user/home_screen.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
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
              selectedIcon: Icon(Icons.home, color: Colors.blue),
              icon: Icon(Icons.home_outlined),
              label: 'Inicio',
            ),
            const NavigationDestination(
              selectedIcon: Icon(Icons.view_list, color: Colors.blue),
              icon: Icon(
                Icons.view_list_outlined,
              ),
              label: 'Extensómetros',
            ),
            NavigationDestination(
              selectedIcon: Badge(
                isLabelVisible: notificationCount > 0,
                label: Text(notificationCount.toString()),
                child: const Icon(Icons.notifications, color: Colors.blue),
              ),
              icon: Badge(
                isLabelVisible: notificationCount > 0,
                label: Text(notificationCount.toString()),
                child: Icon(
                  notificationCount > 0 ? Icons.notifications : Icons.notifications_none,
                  color: notificationCount > 0 ? Colors.blue : null,
                ),
              ),
              label: 'Notificaciones',
            ),
          ],
        );
      }),
    );
  }
}
