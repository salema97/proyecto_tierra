import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_tierra/src/providers/auth_provider.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userInfo = authProvider.userInfo;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 40.h, 16.w, 16.h),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userInfo?.userName ?? 'Usuario',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${userInfo?.email ?? "Email no disponible"} • ${authProvider.selectedRole == "admin" ? "Administrador" : "Usuario"}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          const Spacer(),
          PopupMenuButton(
            onSelected: (value) async {
              if (value == 'logout') {
                await authProvider.logout();
                Navigator.pushReplacementNamed(context, '/');
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      const Icon(Icons.exit_to_app),
                      SizedBox(width: 8.w),
                      Text('Cerrar sesión', style: TextStyle(fontSize: 14.sp)),
                    ],
                  ),
                ),
              ];
            },
            child: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: const Icon(Icons.person, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
