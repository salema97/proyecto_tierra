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
          content: Text('Ocurrió un error al enviar el correo: $error'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Restablecer contraseña",
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
      body: Padding(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "¿Olvidaste tu contraseña?",
                  style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.h),
                Text(
                  "Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña",
                  style: TextStyle(fontSize: 16.sp, color: Colors.black54),
                ),
                SizedBox(height: 32.h),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingrese un correo electrónico';
                    }
                    if (!value.contains('@')) {
                      return 'Por favor ingrese un correo electrónico válido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleResetPassword,
                  child: _isLoading
                      ? SizedBox(
                          width: 24.w,
                          height: 24.h,
                          child: const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text('Restablecer contraseña'),
                ),
              ],
            ),
          )),
    );
  }
}
