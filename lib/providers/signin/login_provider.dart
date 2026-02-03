import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:youbuilt/model/countrycode.dart';
import 'package:youbuilt/screen/bottom_nav.dart';
import 'package:youbuilt/screen/otp.dart';
import 'package:youbuilt/utils/constants.dart';

import '../../services/api.dart';
import '../../utils/sharedpref_util.dart';
import '../../utils/toast_util.dart';

class LoginProvider with ChangeNotifier {
  bool signInLoading = false;
  bool isLoading = false;
  TextEditingController phoneCntrl = TextEditingController();
  TextEditingController pwdCntrl = TextEditingController();
  TextEditingController otpContrl = TextEditingController();
  Future<void> loginForm({
    required BuildContext context,

    String? phone,
    String? password,
  }) async {
    signInLoading = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().login(
        context: context,
        phonenumber: phone ?? "",
        pwd: password ?? "",
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        print("Status code 12345678909876543");

        accessToken = responseData["accessToken"];
        // refreshToken = responseData["refreshToken"];

        if (accessToken != null) {
          await SharedPrefUtil.writeString(accesstokenKey, accessToken!);
        }

        ToastUtil.show("Login Successfully!");

        if (!context.mounted) return;

        log("Navigating to LoginSuccessfulScreen...");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavScreen()),
        );
      } else {
        String errorMessage =
            responseData["message"] ??
            responseData["error"] ??
            "SignIn failed. Please try again.";
        log("SignIn failed: $errorMessage");

        // if (!context.mounted) return;
        //
        // showDialog(
        //   context: context,
        //   builder: (BuildContext ctx) {
        //     return AlertDialog(
        //       title: const Text("Login Failed"),
        //       content: Text(errorMessage),
        //       actions: [
        //         TextButton(
        //           onPressed: () {
        //             Navigator.of(ctx).pop();
        //           },
        //           child: const Text("OK"),
        //         ),
        //       ],
        //     );
        //   },
        // );
      }
    } catch (e, stack) {
      log("❌ Login exception: $e\n$stack");
      log("Error: $e");
      // ToastUtil.show("An error occurred. Please try again.");
      ToastUtil.show("An error occurred. Please try again.");
    } finally {
      signInLoading = false;
      notifyListeners();
    }
  }

  bool signUpLoading = false;
  TextEditingController phoneNoCntrl = TextEditingController();
  TextEditingController passwdCntrl = TextEditingController();
  TextEditingController confirmPasswdCntrl = TextEditingController();
  TextEditingController nameCntrl = TextEditingController();
  Future<void> signupForm({
    required BuildContext context,
    String? code,
    String? phone,
    String? name,
    String? password,
  }) async {
    signUpLoading = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().signUp(
        context: context,
        phonenumber: phone ?? "",
        pwd: password ?? "",
        code: code ?? "",
        name: name ?? "",
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        print("Status code 12345678909876543");

        accessToken = responseData["accessToken"];
        // refreshToken = responseData["refreshToken"];

        if (accessToken != null) {
          await SharedPrefUtil.writeString(accesstokenKey, accessToken!);
        }

        ToastUtil.show("SignUp Successfully!");

        if (!context.mounted) return;

        log("Navigating to LoginSuccessfulScreen...");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavScreen()),
        );
      } else {
        String errorMessage =
            responseData["message"] ??
            responseData["error"] ??
            "SignIn failed. Please try again.";
        log("SignIn failed: $errorMessage");

        if (!context.mounted) return;
        ToastUtil.show("An error occurred. Please try again.");
      }
    } catch (e, stack) {
      log("❌ Login exception: $e\n$stack");
      log("Error: $e");
      // ToastUtil.show("An error occurred. Please try again.");
      ToastUtil.show("An error occurred. Please try again.");
    } finally {
      signUpLoading = false;
      notifyListeners();
    }
  }

  Future<void> otpSend({
    required BuildContext context,
    String? code,
    String? phone,
  }) async {
    signUpLoading = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().sendOtp(
        context: context,
        phonenumber: phone ?? "",
        code: code ?? "",
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        ToastUtil.show("Otp Send Successfully!");

        if (!context.mounted) return;

        log("Navigating to LoginSuccessfulScreen...");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserOtpScreeen()),
        );
      } else {
        String errorMessage =
            responseData["message"] ??
            responseData["error"] ??
            "SignIn failed. Please try again.";
        log("SignIn failed: $errorMessage");

        if (!context.mounted) return;
        ToastUtil.show("An error occurred. Please try again.");
      }
    } catch (e, stack) {
      log("❌ Login exception: $e\n$stack");
      log("Error: $e");
      // ToastUtil.show("An error occurred. Please try again.");
      ToastUtil.show("An error occurred. Please try again.");
    } finally {
      signUpLoading = false;
      notifyListeners();
    }
  }

  Future<void> otpVerify({
    required BuildContext context,
    String? code,
    String? phone,
    String? otp,
  }) async {
    signUpLoading = true;
    notifyListeners();

    try {
      final responseData = await NetworkHelper().verifyOtp(
        context: context,
        phonenumber: phone ?? "",
        code: code ?? "",
        otp: otp ?? "",
      );

      log("OTP Verify Response: $responseData");

      if (responseData["status"] == 200) {
        // Call signup only after OTP success
        await signupForm(
          context: context,
          phone: phoneNoCntrl.text,
          code: selectedCountryCode ?? "+91",
          name: nameCntrl.text,
          password: passwdCntrl.text,
        );

        if (!context.mounted) return;

        log("Navigating to UserOtpScreen...");
      } else {
        final String errorMessage =
            responseData["message"] ??
            responseData["error"] ??
            "OTP verification failed. Please try again.";

        log("OTP verification failed: $errorMessage");

        if (!context.mounted) return;
        ToastUtil.show(errorMessage);
      }
    } catch (e, stackTrace) {
      log("❌ OTP Verify Exception: $e");
      log(stackTrace.toString());

      if (!context.mounted) return;
      ToastUtil.show("An error occurred. Please try again.");
    } finally {
      signUpLoading = false;
      notifyListeners();
    }
  }

  Future<void> otpResend({
    required BuildContext context,
    String? code,
    String? phone,
  }) async {
    signUpLoading = true;
    notifyListeners();

    try {
      final responseData = await NetworkHelper().resendOtp(
        context: context,
        phonenumber: phone ?? "",
        code: code ?? "",
        // otp: otp ?? "",
      );

      log("OTP Verify Response: $responseData");

      if (responseData["status"] == 200) {
        // Call signup only after OTP success
        // await signupForm(
        //   context: context,
        //   phone: phoneNoCntrl.text,
        //   code: selectedCountryCode ?? "+91",
        //   name: nameCntrl.text,
        //   password: passwdCntrl.text,
        // );
        ToastUtil.show("Otp Send Successfully");

        if (!context.mounted) return;

        log("Navigating to UserOtpScreen...");
      } else {
        final String errorMessage =
            responseData["message"] ??
            responseData["error"] ??
            "OTP verification failed. Please try again.";

        log("OTP verification failed: $errorMessage");

        if (!context.mounted) return;
        ToastUtil.show(errorMessage);
      }
    } catch (e, stackTrace) {
      log("❌ OTP Verify Exception: $e");
      log(stackTrace.toString());

      if (!context.mounted) return;
      ToastUtil.show("An error occurred. Please try again.");
    } finally {
      signUpLoading = false;
      notifyListeners();
    }
  }

  bool isTermsAccepted = false;

  void toggleTerms(bool value) {
    isTermsAccepted = value;
    notifyListeners();
  }

  CountryCodeModel? countryCodeModel;
  bool? load = false;
  Future fetchCountryCode({required BuildContext context}) async {
    load = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getCountyCode(context);

      if (response != null) {
        countryCodeModel = response; // Store fetched subcategories
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ViewBookTaskDetails(
        //       taskId: idd.toString(),
        //     ),
        //   ),
        // );
        log("Fetched details successfully.");
      } else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching category: $e");
    } finally {
      load = false;
      notifyListeners();
    }
  }

  bool loadd = false;
  String? selectedCountryCode; // ✅ ADD THIS
  bool isError = false; // ✅ ADD THIS
  // String? selectedCountryCode;

  void setSelectedCountryCode(String value) {
    selectedCountryCode = value;
    notifyListeners();
  }

  int _counter = 60;
  bool _canResend = false;
  Timer? _timer;

  int get counter => _counter;
  bool get canResend => _canResend;

  void startResendTimer() {
    _counter = 60;
    _canResend = false;
    notifyListeners();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter == 0) {
        _canResend = true;
        timer.cancel();
      } else {
        _counter--;
      }
      notifyListeners();
    });
  }

  void resendOtp(BuildContext context) {
    // 🔹 Call resend OTP API here
    // userResendOtp(context, "91", phoneNoCntrl.text);
    otpResend(
      context: context,
      phone: phoneNoCntrl.text ?? "",
      code: selectedCountryCode ?? "+91",
    );
    // otpVerify(
    //   context: context,
    //   code: selectedCountryCode ?? "+91",
    //   phone: phoneNoCntrl.text ?? "",
    //   otp: otpContrl.text,
    // );
    startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
