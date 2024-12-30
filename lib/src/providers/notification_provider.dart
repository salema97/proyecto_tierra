import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:proyecto_tierra/src/models/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider with ChangeNotifier {
  List<Notification> _notifications = [];
  List<Notification> get notifications => _notifications;

  Future<void> addNotification(Notification notification) async {
    _notifications.insert(0, notification);
    await _saveNotifications();
    notifyListeners();
  }

  Future<void> removeNotification(String id) async {
    _notifications.removeWhere((notification) => notification.id == id);
    await _saveNotifications();
    notifyListeners();
  }

  Future<void> loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodeList = prefs.getString('notifications');
    if (encodeList != null) {
      final List<dynamic> list = json.decode(encodeList);
      _notifications = list.map((json) => Notification.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodeList =
        json.encode(_notifications.map((notification) => notification.toJson()).toList());
    await prefs.setString('notifications', encodeList);
  }
}
