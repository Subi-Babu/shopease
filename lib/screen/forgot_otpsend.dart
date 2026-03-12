import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/screen/bottom_nav.dart';
// import 'package:youbuilt/home.dart';
import 'package:youbuilt/screen/sign_up.dart';
// import 'package:youbuilt/sign_up.dart';
import 'package:youbuilt/utils/colors.dart';

import '../custom_widgets/custom_button.dart';
import '../providers/signin/login_provider.dart';

class UserForfotOtpScreeen extends StatefulWidget {
  const UserForfotOtpScreeen({super.key});

  @override
  State<UserForfotOtpScreeen> createState() => _UserForfotOtpScreeenState();
}

class _UserForfotOtpScreeenState extends State<UserForfotOtpScreeen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LoginProvider>(context, listen: false).startResendTimer();
      Provider.of<LoginProvider>(context, listen: false).otpContrl.clear();
      Provider.of<LoginProvider>(context, listen: false).otpErrorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          backgroundColor: backgroundColor,
          surfaceTintColor: Colors.transparent,
        ),
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
          child: Consumer<LoginProvider>(
            builder: (context, otp, _) {
              return Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back, color: primaryClr),
                    ),
                    SizedBox(height: 20),
                    SizedBox(height: MediaQuery.of(context).padding.top * 3),
                    FirstSection(
                      heading: "OTP \nVerification",
                      subheading: "OTP sent to ${otp.phoneCntrl.text}",
                    ),
                    SizedBox(height: 8),
                    CustomTextField(
                      keyboardType: TextInputType.number,
                      maxLine: 1,
                      atoFocus: true,
                      decration: InputDecoration(
                        hintText: "X X X X",
                        hintStyle: TextStyle(
                          color: const Color(0XFFBFC6C3),
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                        border: InputBorder.none,
                      ),
                      controller: otp.fotpContrl,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter OTP";
                        } else if (value.length != 4) {
                          return "OTP must be exactly 4 digits";
                        }
                        return null;
                      },
                      listInput: [
                        FilteringTextInputFormatter
                            .digitsOnly, // Allows only numbers
                        LengthLimitingTextInputFormatter(
                          4,
                        ), // Limits input to 6 characters
                      ],
                    ),
                    if (otp.otpErrorMessage3 != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          otp.otpErrorMessage3!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      ),

                    const Spacer(),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: otp.canResend
                              ? "Resend OTP"
                              : "Resend OTP in ${otp.counter} s",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: otp.canResend ? Colors.red : Colors.blue,
                            decoration: otp.canResend
                                ? TextDecoration.underline
                                : TextDecoration.none,
                          ),
                          recognizer: otp.canResend
                              ? (TapGestureRecognizer()
                                  ..onTap = () {
                                    otp.otpContrl.clear();
                                    otp.resendOtp(context);
                                  })
                              : null,
                        ),
                      ),
                    ),

                    SizedBox(height: 5),
                    CustomButton(
                      text: "Verify",
                      onPress: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => BottomNavScreen(),
                        //   ),
                        // );
                        if (formKey.currentState!.validate()) {
                          otp.forgotOtpVerify(
                            context: context,
                            code: otp.selectedCountryCode ?? "91",
                            phone: otp.phoneCntrl.text,
                            otp: otp.fotpContrl.text,
                          );
                        }
                      },
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
