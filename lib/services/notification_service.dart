import 'package:flutter/material.dart';

enum NotificationType {
  info,
  success,
  warning,
  error
}

class NotificationService {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey => _scaffoldMessengerKey;

  // No-op: Firebase Messaging removed for frontend-only version
  Future<void> initializeFirebaseMessaging() async {
    // No backend notification support in frontend-only version
  }

  // Show in-app notification
  void showInAppNotification(String title, String message, {Duration duration = const Duration(seconds: 3), NotificationType type = NotificationType.info}) {
    final snackBar = SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(message),
        ],
      ),
      duration: duration,
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
        },
      ),
    );

    _scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }

  // Show booking status update notification
  void showBookingStatusUpdate(String bookingId, String status) {
    showInAppNotification(
      'Booking Update',
      'Your booking #$bookingId is now $status',
      type: NotificationType.info,
    );
  }
  
  // Legacy method for backward compatibility
  void showNotification(String message, [NotificationType type = NotificationType.info]) {
    showInAppNotification(
      type == NotificationType.error ? 'Error' :
      type == NotificationType.warning ? 'Warning' :
      type == NotificationType.success ? 'Success' : 'Notification',
      message,
      type: type,
    );
  }
}