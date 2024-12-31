import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_tierra/src/pages/login_page.dart';
import 'package:proyecto_tierra/src/providers/auth_provider.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userInfo = authProvider.userInfo;

    return Scaffold(
      appBar: AppBar(
        title: Text("Admin", style: TextStyle(fontSize: 18.sp)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Bienvenido ${userInfo?.userName ?? 'User'}!",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "Email: ${userInfo?.email ?? 'Email'}",
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 16.h),
            Text(
              "Roles: ${userInfo?.roles.join(', ') ?? 'Roles'}",
              style: TextStyle(fontSize: 16.sp),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.notifications_sharp)),
            label: 'Notificaciones',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('5'),
              child: Icon(Icons.messenger_sharp),
            ),
            label: 'Mensajes',
          ),
        ],
      ),
    );
  }
}
