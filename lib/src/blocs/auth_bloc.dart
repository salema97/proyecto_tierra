import 'dart:async';

class AuthBloc {
  final _authController = StreamController<bool>.broadcast();
  Stream<bool> get isAuth => _authController.stream;

  void login() {
    _authController.sink.add(true);
  }

  void logout() {
    _authController.sink.add(false);
  }

  void dispose() {
    _authController.close();
  }
}
