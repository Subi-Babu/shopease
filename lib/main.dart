// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/providers/signin/login_provider.dart';
import 'package:youbuilt/providers/signin/project_provider.dart';
import 'package:youbuilt/splash.dart';
import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:youbuilt/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // await getFcmToken();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("Handling a background message: ${message.messageId}");
// }
//
//
// Future<void> getFcmToken() async {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//   NotificationSettings settings = await messaging.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//
//   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//     String? fcmToken = await messaging.getToken();
//     String? iosToken;
//
//     print("FCM TOKEN: $fcmToken");
//
//     if (Platform.isIOS) {
//       await Future.delayed(const Duration(seconds: 2));
//       String? apnsToken = await messaging.getAPNSToken();
//       iosToken = apnsToken;
//       print("APNS TOKEN: $apnsToken");
//     }
//
//     tokenfcm = fcmToken ?? iosToken;
//   } else {
//     print("Permission denied");
//   }
// }
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      right: false,
      left: false,
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => LoginProvider()),
            ChangeNotifierProvider(create: (_) => ProjectProvider()),
          ],
          child: MaterialApp(
            navigatorKey: navigatorKey,
            title: 'YouBuilt',
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
          ),
        ),
      ),
    );
  }
}
