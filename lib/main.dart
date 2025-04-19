import 'dart:convert';
import 'package:ducanherp/blocs/danhgia/danhgia_bloc.dart';
import 'package:ducanherp/blocs/danhgia/danhgia_reponsitory.dart';
import 'package:ducanherp/blocs/notification/notification_event.dart';
import 'package:ducanherp/blocs/notification/notification_reponsitory.dart';
import 'package:ducanherp/blocs/notification/notification_bloc.dart';
import 'package:ducanherp/blocs/permission/permission_bloc.dart';
import 'package:ducanherp/blocs/permission/permission_event.dart';
import 'package:ducanherp/blocs/permission/permission_repository.dart';
import 'package:ducanherp/blocs/permission/permission_state.dart';
import 'package:ducanherp/helpers/user_storage_helper.dart';
import 'package:ducanherp/screens/home_screen.dart';
import 'package:ducanherp/screens/login_screen.dart';
import 'package:ducanherp/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/login_bloc.dart';
import 'blocs/nhanvien/nhanvien_bloc.dart';
import 'blocs/nhanvien/nhanvien_repository.dart';
import 'blocs/nhomnhanvien/nhomnhanvien_bloc.dart';
import 'blocs/congviec/congviec_bloc.dart';
import 'blocs/download/download_bloc.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  _showNotification(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await _initLocalNotifications();

  final prefs = await SharedPreferences.getInstance();
  final client = http.Client();

  runApp(
    MultiProvider(
      providers: [
        Provider<SharedPreferences>.value(value: prefs),
        Provider<http.Client>.value(value: client),
        BlocProvider(create: (_) => LoginBloc()),
        BlocProvider(create: (_) => CongViecBloc(client: client, prefs: prefs)),
        BlocProvider(create: (_) =>NhanVienBloc(repository: NhanVienRepository(client: client, prefs: prefs))),
        BlocProvider(create: (_) => NhomNhanVienBloc(client: client, prefs: prefs)),
        BlocProvider(create: (_) => DownloadBloc()),
        BlocProvider(create: (_) => DanhGiaBloc(DanhGiaRepository(prefs))),
        BlocProvider(create: (_) => PermissionBloc(PermissionRepository(client: client, prefs: prefs))),
        BlocProvider(create: (_) => NotificationBloc(repository: NotificationRepository(client: client, prefs: prefs),),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _checkLoginAndRedirect().then((isLoggedIn) {
      if (isLoggedIn) {
        _initFirebaseMessaging();
      }
    });
  }

  // Kiểm tra token, expiration và user, nếu hợp lệ chuyển đến HomeScreen
  Future<bool> _checkLoginAndRedirect() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');
    final expiration = prefs.getString('expiration');
    final user = await UserStorageHelper.getCachedUserInfo();

    // Nếu không có token → chuyển về LoginScreen
    if (savedToken == null) {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
      return false;
    }

    if (expiration != null && user != null && user.id.isNotEmpty) {
      final expDate = DateTime.tryParse(expiration) ?? DateTime(0);
      if (expDate.isAfter(DateTime.now())) {
        final permissionsDate = prefs.getString('permissions_date');
        final now = DateTime.now();

        if (permissionsDate == null || DateTime.tryParse(permissionsDate)?.day != now.day) {
          final permissionBloc = BlocProvider.of<PermissionBloc>(context);
          permissionBloc.add(FetchPermissions(
            groupId: user.groupId,
            userId: user.id,
            parentMajorId: "249ff511-8f10-45e8-bf8f-29b0ada5ab84",
          ));

          final permState = await permissionBloc.stream
              .firstWhere((state) => state is PermissionLoaded) as PermissionLoaded;

          final permissionJsonList = permState.permissions.map((p) => jsonEncode(p.toJson())).toList();
          await prefs.setStringList('permissions', permissionJsonList);
          await prefs.setString('permissions_date', now.toIso8601String());
        }

        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => HomeScreen()),
          (route) => false,
        );
        return true;
      } else {
        await prefs.remove('token');
      }
    }

    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
    return false;
  }

  void _initFirebaseMessaging() async {
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();

    final fcmToken = await messaging.getToken();
    print('📱 FCM Token: $fcmToken');

    final user = await UserStorageHelper.getCachedUserInfo();

    // Nếu có fcmToken và thông tin user hợp lệ, đăng ký token FCM qua NotificationBloc
    if (fcmToken != null && user != null && user.id.isNotEmpty) {
      context.read<NotificationBloc>().add(
        RegisterTokenEvent(
          token: fcmToken,
          groupId: user.groupId,
          userId: user.id,
        ),
      );
    } else {
      // Nếu không có thông tin user hợp lệ, chuyển về LoginScreen
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }

    FirebaseMessaging.onMessage.listen((message) => _showNotification(message));

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      navigatorKey.currentState?.pushNamed('/page_notification', arguments: message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Ducanherp',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/logo.png', height: 100),
              SizedBox(height: 20),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
      onGenerateRoute: (settings) {
        if (settings.name == '/page_notification') {
          final message = settings.arguments as RemoteMessage?;
          if (message != null) {
            return MaterialPageRoute(
              builder: (_) => NotificationScreen(notification: message),
            );
          }
        }
        return null;
      },
    );
  }
}

Future<void> _initLocalNotifications() async {
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (response) {
      if (response.payload != null) {
        final data = jsonDecode(response.payload!);
        navigatorKey.currentState?.pushNamed(
          '/page_notification',
          arguments: RemoteMessage(
            data: Map<String, dynamic>.from(data['data']),
            notification: RemoteNotification(
              title: data['title'],
              body: data['body'],
            ),
          ),
        );
      }
    },
  );
}

Future<void> _showNotification(RemoteMessage message) async {
  const androidDetails = AndroidNotificationDetails(
    'default_channel_id',
    'Thông báo',
    channelDescription: 'Kênh thông báo chính',
    importance: Importance.max,
    priority: Priority.high,
  );

  const notificationDetails = NotificationDetails(android: androidDetails);
  final payload = jsonEncode({
    'title': message.notification?.title,
    'body': message.notification?.body,
    'data': message.data,
  });

  await flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    message.notification?.title ?? 'Thông báo',
    message.notification?.body ?? '',
    notificationDetails,
    payload: payload,
  );
}
