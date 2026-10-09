import 'dart:convert';
import 'package:etudiant/core/navigation/app_routes.dart';
import 'package:etudiant/core/navigation/navigation_key.dart';
import 'package:etudiant/core/utils/service_locator.dart';
import 'package:etudiant/features/services/notification_repo_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background FCM: ${message.data}');
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  print('Background notification tapped: ${response.payload}');
}

class NotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifs =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'high_importance_channel';
  static const String _channelName = 'Notifications Importantes';

  static Future<void> init() async {
    // 1. Background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 2. Permissions
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    // 3. Init Local Notifications (v21 uses named 'settings')
    await _initLocalNotifications();
    await uploadTokenToBackend();
    // 4. Token management
    final token = await _fcm.getToken();
    print('FCM Token: $token');

    // 5. App terminated: handle initial message
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleNavigation(initialMessage);
    }

    // 6. App in background: handle click
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNavigation(message);
    });

    // 7. App in foreground: show local popup
    FirebaseMessaging.onMessage.listen((message) {
      _showLocalNotification(message);
    });
  }

  static void _handleNavigation(RemoteMessage message) {
    final data = message.data;
    final type = data['type'] ?? '';

    // ✅ ajoute ce print pour voir ce que le backend envoie exactement
    print('📩 Notification reçue — type: "$type" | data: $data');

    final context = navigatorKey.currentContext;
    if (context == null) return;

    switch (type) {
      case 'TEST_NOTIFICATION':
      case 'REMPLACEMENT':
        context.pushNamed(AppRoutes.notification);
        break;

      case 'JUSTIFICATIF_STATUS':
        context.pushNamed(AppRoutes.mainScreen); // ✅ était vide avant
        break;

      default:
        context.pushNamed(AppRoutes.notification);
    }
  }

  static Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    // ✅ FIX v21: 'settings' is a required named parameter
    await _localNotifs.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          // Logique quand on clique sur une notif alors que l'app est ouverte
          print('Notification payload: ${response.payload}');
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // ✅ FIX v21: Correct way to create channel
    final androidPlugin = _localNotifs
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: 'Notifications de tests et justificatifs',
          importance: Importance.high,
          playSound: true,
        ),
      );
    }
  }

  // Ajoute cette méthode dans ta classe NotificationService
  static Future<void> uploadTokenToBackend() async {
    try {
      String? token = await _fcm.getToken();
      if (token != null) {
        // ✅ On utilise le Repo qu'on vient de créer via sl
        await sl<NotificationServiceRepo>().uploadFcmToken(token);
        print('✅ FCM Token envoyé au serveur');
      }
    } catch (e) {
      print('❌ Erreur upload token: $e');
    }
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    // ✅ Config précise pour Android
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: 'Notifications de tests et justificatifs',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        );

    // ✅ FIX v21: show uses named parameters
    await _localNotifs.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: const NotificationDetails(android: androidDetails),
      payload: jsonEncode(message.data),
    );
  }

  // Topic Helpers
  static Future<void> subscribeToTopic(String topic) async {
    await _fcm.subscribeToTopic(_cleanTopic(topic));
  }

  static String _cleanTopic(String raw) =>
      raw.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9_-]'), '_');
}
