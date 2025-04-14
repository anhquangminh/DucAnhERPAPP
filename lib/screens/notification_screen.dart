import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationScreen extends StatelessWidget {
  final RemoteMessage notification;

  const NotificationScreen({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết thông báo'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.notification?.title ?? 'Thông báo',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              notification.notification?.body ?? 'Nội dung thông báo',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            if (notification.data.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin bổ sung:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  ...notification.data.entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('${entry.key}: ${entry.value}'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
