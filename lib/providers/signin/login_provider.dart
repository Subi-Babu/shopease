import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:youbuilt/model/countrycode.dart';
import 'package:youbuilt/screen/bottom_nav.dart';
import 'package:youbuilt/screen/forgot_otp.dart';
import 'package:youbuilt/screen/forgot_otpsend.dart';
import 'package:youbuilt/screen/login.dart';
import 'package:youbuilt/screen/otp.dart';
import 'package:youbuilt/utils/constants.dart';

import '../../screen/forgot_update.dart';
import '../../services/api.dart';
import '../../utils/sharedpref_util.dart';
import '../../utils/toast_util.dart';

class LoginProvider with ChangeNotifier {
  bool signInLoading = false;
  bool isLoading = false;
  TextEditingController phoneCntrl = TextEditingController();
  TextEditingController pwdCntrl = TextEditingController();
  TextEditingController otpContrl = TextEditingController();
  TextEditingController fotpContrl = TextEditingController();
  String? loginErrorMessage; // 👈 Add this in your provider

  Future<void> loginForm({
    required BuildContext context,
    String? phone,
    // required String pwd,
    String? password,
    String? code,
  }) async {
    signInLoading = true;
    loginErrorMessage = null;
    notifyListeners();

    try {
      var response = await NetworkHelper().login(
        context: context,
        phonenumber: phone ?? "",
        pwd: password ?? "",
        code: code ?? "+91",
      );

      if (response == null) {
        loginErrorMessage = "No response from server.";
        return;
      }

      if (response["status"] == 200) {
        var data = response["data"];

        accessToken = data["accessToken"];

        if (accessToken != null) {
          await SharedPrefUtil.writeString(accesstokenKey, accessToken!);
        }

        if (!context.mounted) return;
        pwdCntrl.clear();
        phoneCntrl.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavScreen()),
        );
      } else {
        // ✅ Correct error extraction
        loginErrorMessage =
            response["data"]?["error"] ?? "Login failed. Please try again.";

        notifyListeners();
      }
    } catch (e, stack) {
      log("❌ Login exception: $e\n$stack");

      loginErrorMessage = "Something went wrong. Please try again.";
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

  String? otpErrorMessage2;

  Future<void> otpSend({
    required BuildContext context,
    String? code,
    String? phone,
  }) async {
    signUpLoading = true;
    otpErrorMessage2 = null; // ✅ clear old error
    notifyListeners();

    try {
      var responseData = await NetworkHelper().sendOtp(
        context: context,
        phonenumber: phone ?? "",
        code: code ?? "",
      );

      log("LOG MESSAGE222222:");

      if (responseData == null) {
        otpErrorMessage2 = "Something went wrong. Please try again.";
        ToastUtil.show(otpErrorMessage!);
        return;
      }

      // ✅ SUCCESS
      if (responseData["status"] == 200 || responseData["status"] == true) {
        otpErrorMessage2 = null; // clear error

        ToastUtil.show("Otp Send Successfully!");

        if (!context.mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => UserOtpScreeen()),
        );
      }
      // ✅ PHONE ALREADY USED
      else if (responseData["status"] == 404) {
        otpErrorMessage2 =
            responseData["error"] ?? "Phone Number is already used";
        // ToastUtil.show(otpErrorMessage2!);
      }
      // ✅ OTHER ERRORS
      else {
        otpErrorMessage2 =
            responseData["message"] ??
            responseData["error"] ??
            "SignIn failed. Please try again.";

        ToastUtil.show(otpErrorMessage2!);
        log("SignIn failed: $otpErrorMessage2");
      }
    } catch (e, stack) {
      log("❌ Login exception: $e\n$stack");

      otpErrorMessage2 = "An error occurred. Please try again.";
      ToastUtil.show(otpErrorMessage!);
    } finally {
      signUpLoading = false;
      notifyListeners(); // ✅ notify after updating error
    }
  }

  String? otpErrorMessage;
  String? otpErrorMessage3;
  String? otpErrorMessage4;
  Future<void> otpForgotSend({
    required BuildContext context,
    String? code,
    String? phone,
  }) async {
    signUpLoading = true;
    otpErrorMessage3 = null; // ✅ clear old error
    notifyListeners();

    try {
      var responseData = await NetworkHelper().sendForgotOtp(
        context: context,
        phonenumber: phone ?? "",
        code: code ?? "",
      );

      log("LOG MESSAGE222222:");

      if (responseData == null) {
        otpErrorMessage3 = "Something went wrong. Please try again.";
        ToastUtil.show(otpErrorMessage!);
        return;
      }

      // ✅ SUCCESS
      if (responseData["status"] == 200 || responseData["status"] == true) {
        otpErrorMessage3 = null; // clear error

        ToastUtil.show("Otp Send Successfully!");

        if (!context.mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => UserForfotOtpScreeen()),
        );
      }
      // ✅ PHONE ALREADY USED
      else if (responseData["status"] == 404) {
        otpErrorMessage3 =
            responseData["error"] ?? "Phone Number is already used";
        // ToastUtil.show(otpErrorMessage2!);
      }
      // ✅ OTHER ERRORS
      else {
        otpErrorMessage3 =
            responseData["message"] ??
            responseData["error"] ??
            "SignIn failed. Please try again.";

        ToastUtil.show(otpErrorMessage2!);
        log("SignIn failed: $otpErrorMessage2");
      }
    } catch (e, stack) {
      log("❌ Login exception: $e\n$stack");

      otpErrorMessage3 = "An error occurred. Please try again.";
      ToastUtil.show(otpErrorMessage!);
    } finally {
      signUpLoading = false;
      notifyListeners(); // ✅ notify after updating error
    }
  }

  Future<void> otpVerify({
    required BuildContext context,
    String? code,
    String? phone,
    String? otp,
  }) async {
    signUpLoading = true;
    otpErrorMessage = null; // Reset previous error
    notifyListeners();

    try {
      final responseData = await NetworkHelper().verifyOtp(
        context: context,
        phonenumber: phone ?? "",
        code: code ?? "",
        otp: otp ?? "",
      );

      log("OTP Verify Response: ${responseData?["error"]}");

      if (responseData?["status"] == 200 || responseData?["status"] == true) {
        // OTP Success → Call signup
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
        otpErrorMessage =
            responseData?["error"] ??
            "Otp not match" ?? // ← unreachable
            "OTP verification failed";
        log("OTP verification failed: $otpErrorMessage");
        notifyListeners();
      }
    } catch (e, stackTrace) {
      log("❌ OTP Verify Exception: $e");
      log(stackTrace.toString());

      otpErrorMessage = "An error occurred. Please try again.";
      notifyListeners();
    } finally {
      signUpLoading = false;
      notifyListeners();
    }
  }

  Future<void> forgotOtpVerify({
    required BuildContext context,
    String? code,
    String? phone,
    String? otp,
  }) async {
    signUpLoading = true;
    otpErrorMessage3 = null; // Reset previous error
    notifyListeners();

    try {
      final responseData = await NetworkHelper().forgotVerifyOtp(
        context: context,
        phonenumber: phone ?? "",
        code: code ?? "",
        otp: otp ?? "",
      );

      log("OTP Verify Response: ${responseData?["error"]}");

      if (responseData?["status"] == 200 || responseData?["status"] == true) {
        // OTP Success → Call signup
        // await signupForm(
        //   context: context,
        //   phone: phoneNoCntrl.text,
        //   code: selectedCountryCode ?? "+91",
        //   name: nameCntrl.text,
        //   password: passwdCntrl.text,
        // );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForgotUpdate()),
        );

        if (!context.mounted) return;

        log("Navigating to UserOtpScreen...");
      } else {
        otpErrorMessage3 =
            responseData?["error"] ??
            "Otp not match" ?? // ← unreachable
            "OTP verification failed";
        log("OTP verification failed: $otpErrorMessage3");
        notifyListeners();
      }
    } catch (e, stackTrace) {
      log("❌ OTP Verify Exception: $e");
      log(stackTrace.toString());

      otpErrorMessage3 = "An error occurred. Please try again.";
      notifyListeners();
    } finally {
      signUpLoading = false;
      notifyListeners();
    }
  }

  Future<void> forgotOtpUpdate({
    required BuildContext context,
    String? code,
    String? phone,
    String? pwd,
  }) async {
    signUpLoading = true;
    otpErrorMessage4 = null; // Reset previous error
    notifyListeners();

    try {
      final responseData = await NetworkHelper().forgotpwdUpdate(
        context: context,
        phonenumber: phone ?? "",
        code: "${code}" ?? "",
        pwd: pwd ?? "",
      );

      log("OTP Verify Response: ${responseData?["error"]}");

      if (responseData?["status"] == 200 || responseData?["status"] == true) {
        // OTP Success → Call signup
        // await signupForm(
        //   context: context,
        //   phone: phoneNoCntrl.text,
        //   code: selectedCountryCode ?? "+91",
        //   name: nameCntrl.text,
        //   password: passwdCntrl.text,
        // );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );

        if (!context.mounted) return;

        log("Navigating to UserOtpScreen...");
      } else {
        otpErrorMessage4 =
            responseData?["error"] ??
            "" ?? // ← unreachable
            "update failed";
        log("OTP verification failed: $otpErrorMessage3");
        notifyListeners();
      }
    } catch (e, stackTrace) {
      log("❌ OTP Verify Exception: $e");
      log(stackTrace.toString());

      otpErrorMessage4 = "An error occurred. Please try again.";
      notifyListeners();
    } finally {
      signUpLoading = false;
      notifyListeners();
    }
  }

  String? otpErroresend;

  Future<void> otpResend({
    required BuildContext context,
    String? code,
    String? phone,
  }) async {
    signUpLoading = true;
    otpErrorMessage == null;
    otpErrorMessage2 == null;
    notifyListeners();

    try {
      final responseData = await NetworkHelper().resendOtp(
        context: context,
        phonenumber: phone ?? "",
        code: code ?? "",
        // otp: otp ?? "",
      );

      log("OTP Verify Response: $responseData");
      if (!context.mounted)
        return;
      // log("Navigating to UserOtpScreen...");
      else {
        otpErroresend =
            responseData?["error"] ??
            "Otp not match" ?? // ← unreachable
            "OTP verification failed";
        log("OTP verification failed: $otpErrorMessage");
        notifyListeners();
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
