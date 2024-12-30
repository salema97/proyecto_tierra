import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_tierra/src/providers/auth_provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        await authProvider.resetPassword(_emailController.text);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Se ha enviado un correo para restablecer la contraseña'),
          backgroundColor: Colors.green,
        ));
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.red,
        ));
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: const Size(360, 690), minTextAdapt: true, splitScreenMode: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Restablecer contraseña",
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "¿Olvidaste tu contraseña?",
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 16.h),
              Text(
                "Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña",
                style: TextStyle(fontSize: 16.sp, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Correo electrónico",
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              SizedBox(height: 4.h),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Ingrese su correo electrónico',
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese su correo electrónico';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleResetPassword,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Text('Restablecer contraseña', style: TextStyle(fontSize: 18.sp)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
