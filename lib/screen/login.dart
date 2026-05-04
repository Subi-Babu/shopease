import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/providers/signin/login_provider.dart';
import 'package:youbuilt/screen/forgot_otp.dart';
import 'package:youbuilt/screen/forgot_otpsend.dart';
import 'package:youbuilt/screen/home.dart';
import 'package:youbuilt/screen/sign_up.dart';

import 'package:youbuilt/utils/colors.dart';
import 'package:youbuilt/utils/countrypicjker.dart';
import 'package:youbuilt/utils/validates.dart';

import '../custom_widgets/custom_button.dart';
import '../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = Provider.of<LoginProvider>(context, listen: false);
      reg.fetchCountryCode(context: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          leading: SizedBox(),
          backgroundColor: backgroundColor,
          surfaceTintColor: Colors.transparent,
        ),
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.only(
            // top: 10,
            left: 15,
            right: 15,
            bottom: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FirstSection(
                heading: "Welcome Back",
                subheading: "Login to your Youbuilt account",
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: Form(
                  key: formKey,
                  child: Consumer<LoginProvider>(
                    builder: (context, sign, _) {
                      return ListView(
                        children: [
                          titleText(isRequired: false, title: 'Phone Number'),
                          SizedBox(height: 8.h),
                          // CustomTextField(
                          //   controller: sign.phoneCntrl,
                          //   maxLine: 1,
                          //   maxLength: 10,
                          //   // maxLine: 1,
                          //   keyboardType: TextInputType.number,
                          //   validator: (value) {
                          //     return ValidationUtil(
                          //       context,
                          //     ).phoneValidation(sign.phoneCntrl.text);
                          //   },
                          //   // validator: (value) {
                          //   //   // // Skip if empty
                          //   //   // if (value == null || value.isEmpty) {
                          //   //   //   return null;
                          //   //   // }
                          //   //
                          //   //   // Check format only if user entered something
                          //   //   final emailRegex = RegExp(
                          //   //     r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          //   //   );
                          //   //   if (!emailRegex.hasMatch(value!)) {
                          //   //     return 'Enter a valid email';
                          //   //   }
                          //   //
                          //   //   return null;
                          //   // },
                          // ),
                          Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0XFFD0DAEA),
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 80,
                                  child: sign.isLoading
                                      ? const CountryCodeShimmer()
                                      : CountryPickerWidget(
                                          countries: sign
                                              .countryCodeModel
                                              ?.countryCode,
                                          selectedValue:
                                              sign.selectedCountryCode,
                                          isLoading: sign.isLoading,
                                          isError: sign.isError,
                                          onChanged: (value) {
                                            if (value != null) {
                                              sign.setSelectedCountryCode(
                                                value,
                                              );
                                            }
                                          },
                                        ),
                                ),
                                Container(
                                  width: 1,
                                  height: double.infinity,
                                  color: const Color(0XFFD0DAEA),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: sign.phoneCntrl,
                                    keyboardType: TextInputType.phone,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 14,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Mobile number required";
                                      }
                                      if (value.length < 10) {
                                        return "Enter valid mobile number";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),

                          titleText(isRequired: false, title: 'Password'),
                          SizedBox(height: 8.h),
                          CustomTextField(
                            maxLine: 1,
                            isPasswordType: true,
                            controller: sign.pwdCntrl,
                            validator: (value) {
                              return ValidationUtil(
                                context,
                              ).pwd(sign.pwdCntrl.text);
                            },
                            // validator: (value) {
                            //   //9074212900
                            //   return ValidationUtil(context)
                            //       .pwd(sign.passwordController.text);
                            // },
                          ),
                          if (sign.loginErrorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                sign.loginErrorMessage!,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          SizedBox(height: 10.h),
                          Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserForfotSendOtpScreeen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  fontFamily: "Manrope",

                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: CustomButton(
                              text: "Login",
                              // isLoading: sign.submitSignUpLoading,
                              // borderColor: Colors.transparent,
                              onPress: // sign.check == true
                              () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => HomeScreen(),
                                //   ),
                                // );
                                if (formKey.currentState!.validate()) {
                                  sign.loginForm(
                                    context: context,
                                    phone: sign.phoneCntrl.text,
                                    code: sign.selectedCountryCode ?? "",
                                    password: sign.pwdCntrl.text,
                                    fcmToken: tokenfcm ?? "",
                                  );

                                  // loginErrorMessage = null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Didn’t registered yet? ",
                                  style: const TextStyle(
                                    fontFamily: "Manrope",

                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff9F9F9F),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const UserSignUpScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Register Now",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      fontFamily: "Manrope",

                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  // }),
                ),
              ),
              // Consumer<CustommerLoginProvider>(builder: (context, sign, _) {
              // })
            ],
          ),
        ),
      ),
    );
  }
}

String? validateEmail(String? value) {
  // basic RFC-ish regex (good enough for most apps)
  final regex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  if (!regex.hasMatch(value!.trim())) return 'Enter a valid email';
  return null;
}
