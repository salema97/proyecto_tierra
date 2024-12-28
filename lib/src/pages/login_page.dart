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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green[100],
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      height: 260.h,
                      width: double.infinity,
                      margin: EdgeInsets.all(14.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.r),
                          bottomRight: Radius.circular(190.r),
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                        child: Image.asset(
                          'assets/images/image-default.webp',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50.r)),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50.r)),
                            borderSide: const BorderSide(color: Colors.black, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50.r)),
                            borderSide: const BorderSide(color: Colors.red, width: 2),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50.r)),
                            borderSide: const BorderSide(color: Colors.red, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                          label: Text("Correo electrónico", style: TextStyle(fontSize: 16.sp)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese su correo electrónico';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50.r)),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50.r)),
                            borderSide: const BorderSide(color: Colors.black, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50.r)),
                            borderSide: const BorderSide(color: Colors.red, width: 2),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50.r)),
                            borderSide: const BorderSide(color: Colors.red, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                          label: Text("Contraseña", style: TextStyle(fontSize: 16.sp)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese su contraseña';
                          }
                          return null;
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const ForgotPasswordPage()));
                        },
                        style: ButtonStyle(
                          overlayColor: WidgetStateProperty.all(Colors.transparent),
                        ),
                        child: Text("Olvidé mi contraseña",
                            style: TextStyle(fontSize: 14.sp), textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text("Inicias sesión con",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp)),
                    SizedBox(height: 14.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 100.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.google,
                              size: 40.sp,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.fingerprint,
                              size: 40.sp,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Center(
                      child: FilledButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.green[500]),
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : Padding(
                                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                                child: Text('Iniciar sesión', style: TextStyle(fontSize: 16.sp)),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 10.h,
                child: Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => const RegisterPage()));
                    },
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                    child: Text("Regístrate",
                        style: TextStyle(fontSize: 16.sp), textAlign: TextAlign.center),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
