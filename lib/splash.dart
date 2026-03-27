import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youbuilt/screen/bottom_nav.dart';
import 'package:youbuilt/screen/onborading.dart';
import 'package:youbuilt/utils/colors.dart';
import 'package:youbuilt/utils/constants.dart';
import 'package:youbuilt/utils/sharedpref_util.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkForUpdate(context);
    });
    _initApp();

  }

  Future<void> _initApp() async {
    // ⏳ Splash delay
    await Future.delayed(const Duration(seconds: 2));
    accessToken = await SharedPrefUtil.getString(accesstokenKey);
    print("🔐 TOKEN => $accessToken");
    userid = await SharedPrefUtil.getString(idKey);
    print("🔐 Id => $userid");
    if (!mounted) return;
    if (accessToken != null && accessToken!.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnBoardingScreen()),
      );
    }
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (_) => const OnBoardingScreen()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          SizedBox(height: 50),
          // App Icon / Logo
          Image.asset('assets/Final_web 2.png', width: 200.w, height: 200.h),

          SizedBox(height: 5.h),

          // Tagline Text
          Text(
            "Construction As A Service",
            style: TextStyle(
              color: primaryClr,
              fontFamily: "Manrope",
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
          Spacer(),
          Image.asset('assets/Group 1000004398.png', width: double.infinity),
        ],
      ),
    );
  }
}
