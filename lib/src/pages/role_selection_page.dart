import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_tierra/src/providers/auth_provider.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userInfo = authProvider.userInfo;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.5, -0.5),
            radius: 1.5,
            colors: [
              Colors.blue[300]!,
              Colors.blue[600]!,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Seleccione el rol con el que quiere iniciar sesión',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              ...userInfo?.roles.map((role) {
                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            authProvider.selectedRole = role;
                            if (role == 'admin') {
                              Navigator.pushReplacementNamed(context, '/admin');
                            } else {
                              Navigator.pushReplacementNamed(context, '/user');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            minimumSize: Size(double.infinity, 50.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                              "Iniciar Sesión como ${role.toString() == 'admin' ? "Administrador" : "Usuario"}",
                              style: TextStyle(fontSize: 16.sp)),
                        ),
                        SizedBox(height: 8.h),
                      ],
                    );
                  }).toList() ??
                  [],
            ],
          ),
        ),
      ),
    );
  }
}
