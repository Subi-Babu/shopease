import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youbuilt/custom_widgets/custom_button.dart';

import '../utils/toast_util.dart';

class ConnectivityCheckScreen extends StatelessWidget {
  const ConnectivityCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/netwrk.png", height: 80, width: 80),
              const Text(
                "Check internet connection",
                style: TextStyle(
                  color: Color(0xFF2B2B2B),
                  fontSize: 16,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 25.h),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: CustomButton(
                  text: "Retry",
                  onPress: () async {
                    bool connection = await checkNetworkConnectivity();
                    if (connection) {
                      if (context.mounted) {
                        Navigator.pop(context);
                        //   // context.go(Pages.bottomBar);
                        //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        //     builder: (context) {
                        //       return const DashBoard();
                        //     },
                        //   ), (route) => false);
                      }
                    } else {
                      ToastUtil.show(
                        "No internet connection. Please try again.",
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 15.h),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> checkNetworkConnectivity() async {
  ConnectivityResult connectivityResult = await Connectivity()
      .checkConnectivity();

  log(
    "${connectivityResult.name} --------- ${connectivityResult != ConnectivityResult.none}",
  );

  return connectivityResult != ConnectivityResult.none;
}
