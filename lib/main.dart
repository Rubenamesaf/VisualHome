import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:login_v1/api/firebase_api.dart';
import 'package:login_v1/view/homeAdmin.view.dart';
import 'package:login_v1/view/login.view.dart';
import 'package:login_v1/view/splash.view.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseApp firebaseApp = await Firebase.initializeApp();

  await FirebaseApi().initNotifications();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await AndroidAlarmManager.initialize();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(fontFamily: 'Raleway'),
      debugShowCheckedModeBanner: false,
      home: LoginView(),
    );
  }
}
