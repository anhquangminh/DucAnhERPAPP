import 'dart:convert';
import 'package:ducanherp/blocs/congviec/congviec_bloc.dart';
import 'package:ducanherp/blocs/download/download_bloc.dart';
import 'package:ducanherp/blocs/nhan_vien/nhan_vien_bloc.dart';
import 'package:ducanherp/blocs/nhan_vien/nhan_vien_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/login_bloc.dart';
import 'blocs/nhom_nhan_vien/nhom_nhan_vien_bloc.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/notification_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  _showNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Init local notification
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
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

  final prefs = await SharedPreferences.getInstance();
  final client = http.Client();

  runApp(
    MultiProvider(
      providers: [
        Provider<SharedPreferences>.value(value: prefs),
        Provider<http.Client>.value(value: client),
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(
            create: (context) => CongViecBloc(
                  client: context.read<http.Client>(),
                  prefs: context.read<SharedPreferences>(),
                )),
        BlocProvider(
          create: (context) => NhomNhanVienBloc(
            client: context.read<http.Client>(),
            prefs: context.read<SharedPreferences>(),
          ),
          lazy: false,
        ),
        BlocProvider(
            create: (context) => NhanVienBloc(
                  repository: NhanVienRepository(
                    client: context.read<http.Client>(),
                    prefs: context.read<SharedPreferences>(),
                  ),
                )),
        BlocProvider(create: (context) => DownloadBloc()),
      ],
      child: MyApp(),
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
    _initFirebaseMessaging();
  }

  void _initFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    final token = await messaging.getToken();
    print('📱 FCM Token: $token');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 Foreground message: ${message.notification?.title}');
      _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('👉 Opened from notification: ${message.notification?.title}');
      navigatorKey.currentState?.pushNamed(
        '/page_notification',
        arguments: message,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Ducanherp',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: LoginCheck(),
      onGenerateRoute: (settings) {
        if (settings.name == '/page_notification') {
          final message = settings.arguments as RemoteMessage?;
          if (message != null) {
            return MaterialPageRoute(
              builder: (context) => NotificationScreen(notification: message),
            );
          }
        }
        return null;
      },
    );
  }
}

Future<void> _showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'default_channel_id',
    'Thông báo',
    channelDescription: 'Kênh thông báo chính',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
  );

  const NotificationDetails platformDetails =
      NotificationDetails(android: androidDetails);

  final payload = jsonEncode({
    'title': message.notification?.title,
    'body': message.notification?.body,
    'data': message.data,
  });

  await flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    message.notification?.title ?? 'Thông báo',
    message.notification?.body ?? '',
    platformDetails,
    payload: payload,
  );
}

class LoginCheck extends StatelessWidget {
  const LoginCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LoginState>(
      future: _loadLoginState(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          final state = snapshot.data!;
          if (state.token != null && state.expiration != null) {
            DateTime expirationDate = DateTime.parse(state.expiration!);
            if (expirationDate.isAfter(DateTime.now())) {
              return HomeScreen();
            }
          }
        }
        return LoginScreen();
      },
    );
  }

  Future<LoginState> _loadLoginState(BuildContext context) async {
    final prefs = context.read<SharedPreferences>();
    String? token = prefs.getString('token');
    String? expiration = prefs.getString('expiration');
    return LoginState(token: token, expiration: expiration);
  }
}

class LoginState {
  final String? token;
  final String? expiration;

  LoginState({required this.token, required this.expiration});
}
