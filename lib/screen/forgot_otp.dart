import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/screen/bottom_nav.dart';
// import 'package:youbuilt/home.dart';
import 'package:youbuilt/screen/sign_up.dart';
// import 'package:youbuilt/sign_up.dart';
import 'package:youbuilt/utils/colors.dart';

import '../custom_widgets/custom_button.dart';
import '../providers/signin/login_provider.dart';
import '../utils/countrypicjker.dart';

class UserForfotSendOtpScreeen extends StatefulWidget {
  const UserForfotSendOtpScreeen({super.key});

  @override
  State<UserForfotSendOtpScreeen> createState() =>
      _UserForfotSendOtpScreeenState();
}

class _UserForfotSendOtpScreeenState extends State<UserForfotSendOtpScreeen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final reg = Provider.of<LoginProvider>(context, listen: false);
      reg.fetchCountryCode(context: context);
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
                child: Consumer<LoginProvider>(
                  builder: (context, sign, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back, color: primaryClr),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: MediaQuery.of(context).padding.top * 3,
                        ),
                        FirstSection(
                          heading: "Forgot \nPassword",
                          subheading: "Reset your Youbuilt password.",
                        ),
                        SizedBox(height: 8),
                        Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0XFFD0DAEA)),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 80,
                                child: sign.isLoading
                                    ? const CountryCodeShimmer()
                                    : CountryPickerWidget(
                                        countries:
                                            sign.countryCodeModel?.countryCode,
                                        selectedValue: sign.selectedCountryCode,
                                        isLoading: sign.isLoading,
                                        isError: sign.isError,
                                        onChanged: (value) {
                                          if (value != null) {
                                            sign.setSelectedCountryCode(value);
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
                        if (sign.otpErrorMessage3 != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              sign.otpErrorMessage3!,
                              style: TextStyle(color: Colors.red, fontSize: 13),
                            ),
                          ),
                        const Spacer(),

                        CustomButton(
                          text: "Continue",
                          onPress: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => BottomNavScreen(),
                            //   ),
                            // );
                            if (formKey.currentState!.validate()) {
                              otp.otpForgotSend(
                                context: context,
                                code: otp.selectedCountryCode ?? "91",
                                phone: otp.phoneCntrl.text,
                              );
                              // otp.phoneCntrl.clear();
                            }
                          },
                        ),
                        SizedBox(height: 5),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
