import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import "package:provider/provider.dart";
import 'package:proyecto_tierra/src/pages/forgot_password_page.dart';
import 'package:proyecto_tierra/src/pages/home_page.dart';
import 'package:proyecto_tierra/src/pages/register_page.dart';
import 'package:proyecto_tierra/src/providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).tryAutoLogin().then((success) {
        if (success) {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
        }
      });
    });
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final device = OneSignal.User.pushSubscription.id;

        await authProvider.login(_emailController.text, _passwordController.text, device);

        if (!mounted) return;

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Ocurrió un error al iniciar sesión: $error'),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(height: 10.h),
            // Container(
            //   height: 180.h,
            //   width: double.infinity,
            //   margin: EdgeInsets.symmetric(vertical: 20.h),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.only(
            //       bottomLeft: Radius.circular(20.r),
            //       bottomRight: Radius.circular(190.r),
            //       topLeft: Radius.circular(20.r),
            //       topRight: Radius.circular(20.r),
            //     ),
            //     child: Image.asset(
            //       'assets/images/image-default.webp',
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Dirección de correo electrónico",
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Ingrese un correo electrónico',
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
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese su correo electrónico';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Contraseña",
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: 'Ingrese una contraseña',
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese su contraseña';
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => const ForgotPasswordPage()));
                      },
                      style: ButtonStyle(
                        overlayColor: WidgetStateProperty.all(Colors.transparent),
                        padding: WidgetStateProperty.all(EdgeInsets.zero),
                      ),
                      child: Text("Olvidé mi contraseña",
                          style: TextStyle(fontSize: 15.sp, color: Colors.white70),
                          textAlign: TextAlign.center),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      minimumSize: Size(double.infinity, 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Iniciar sesión', style: TextStyle(fontSize: 18.sp)),
                              SizedBox(width: 8.w),
                              Icon(Icons.arrow_forward, size: 20.sp, color: Colors.blue),
                            ],
                          ),
                  ),
                  SizedBox(height: 40.h),
                  Text("Iniciar sesión con:",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 18.sp, color: Colors.white70)),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            FontAwesomeIcons.google,
                            size: 40.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.fingerprint,
                            size: 40.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("¿No tienes una cuenta? ",
                            style: TextStyle(fontSize: 16.sp, color: Colors.white70)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (_) => const RegisterPage()));
                          },
                          style: ButtonStyle(
                            overlayColor: WidgetStateProperty.all(Colors.transparent),
                            padding: WidgetStateProperty.all(EdgeInsets.zero),
                          ),
                          child: Text("Regístrate",
                              style: TextStyle(fontSize: 16.sp, color: Colors.white70),
                              textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
