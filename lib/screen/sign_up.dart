import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youbuilt/custom_widgets/custom_button.dart';
import 'package:youbuilt/providers/signin/login_provider.dart';
import 'package:youbuilt/screen/login.dart';
// import 'package:youbuilt/login.dart';
import 'package:youbuilt/screen/otp.dart';
import 'package:youbuilt/utils/colors.dart';
import 'package:youbuilt/utils/toast_util.dart';
import 'package:youbuilt/utils/validates.dart';

import '../utils/countrypicjker.dart';

class UserSignUpScreen extends StatefulWidget {
  const UserSignUpScreen({super.key});

  @override
  State<UserSignUpScreen> createState() => _UserSignUpScreenState();
}

class _UserSignUpScreenState extends State<UserSignUpScreen> {
  final formKey = GlobalKey<FormState>(); // ✅ Move here

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = Provider.of<LoginProvider>(context, listen: false);
      reg.fetchCountryCode(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: Form(
              key: formKey,
              child: Consumer<LoginProvider>(
                builder: (context, sign, _) {
                  return ListView(
                    // ✅ Everything inside ONE ListView
                    padding: const EdgeInsets.only(top: 30),
                    children: [
                      const FirstSection(
                        heading: "Let's\nGet Started",
                        subheading: "Tell Us About Yourself",
                      ),
                      SizedBox(height: 8.h),

                      titleText(isRequired: true, title: 'Full Name'),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        controller: sign.nameCntrl,
                        validator: (p0) {
                          return ValidationUtil(
                            context,
                          ).nameValidation(sign.nameCntrl.text);
                        },
                      ),
                      SizedBox(height: 10.h),

                      titleText(isRequired: true, title: 'Phone Number'),
                      SizedBox(height: 8.h),
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
                                controller: sign.phoneNoCntrl,
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
                      if (sign.otpErrorMessage2 != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            sign.otpErrorMessage2!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      SizedBox(height: 10.h),

                      titleText(isRequired: true, title: 'Password'),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        maxLine: 1,
                        isPasswordType: true,
                        controller: sign.passwdCntrl,
                        validator: (value) {
                          return ValidationUtil(
                            context,
                          ).pwd(sign.passwdCntrl.text);
                        },
                      ),
                      SizedBox(height: 10.h),

                      titleText(isRequired: true, title: 'Confirm Password'),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        maxLine: 1,
                        isPasswordType: true,
                        controller: sign.confirmPasswdCntrl,
                        validator: (value) {
                          return ValidationUtil(
                            context,
                          ).confirmPasswordValidation(
                            sign.passwdCntrl.text,
                            sign.confirmPasswdCntrl.text,
                          );
                        },
                      ),
                      SizedBox(height: 12),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            visualDensity: const VisualDensity(
                              horizontal: -4.0,
                              vertical: -4.0,
                            ),
                            value: sign.isTermsAccepted,
                            activeColor: Colors.red,
                            onChanged: (value) {
                              sign.toggleTerms(value ?? false);
                            },
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontFamily: "Manrope",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff9F9F9F),
                                ),
                                children: [
                                  const TextSpan(
                                    text: "By continuing you agree to our ",
                                  ),
                                  TextSpan(
                                    text: "Terms & Conditions",
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {},
                                  ),
                                  const TextSpan(text: " and "),
                                  TextSpan(
                                    text: "Privacy Policy",
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 8, top: 10),
                        child: CustomButton(
                          text: "Submit",
                          isLoading: sign.signUpLoading,
                          onPress: () {
                            if (!sign.isTermsAccepted) {
                              ToastUtil.show(
                                "Please accept Terms & Conditions",
                              );
                              return;
                            }
                            if (formKey.currentState!.validate()) {
                              sign.otpSend(
                                context: context,
                                code: sign.selectedCountryCode ?? "+91",
                                phone: sign.phoneNoCntrl.text,
                              );
                            }
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(
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
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                " Login",
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
            ),
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

class FirstSection extends StatelessWidget {
  final String? heading;
  final String? welcomeHeading;
  final String? subheading;
  final TextStyle? headingStyle;
  const FirstSection({
    super.key,
    this.heading,
    this.subheading,
    this.welcomeHeading,
    this.headingStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // welcomeHeading != null
        //     ? Text(
        //         welcomeHeading ?? "",
        //         style: TextStyle(
        //           fontFamily: "Manrope",
        //           fontSize: 32.sp,
        //           fontWeight: FontWeight.w800,
        //           color: Color(0xff2C2C2C),
        //         ),
        //       )
        //     : const SizedBox(),
        // const SizedBox(height: 8),
        Text(
          heading ?? "",
          style:
              headingStyle ??
              TextStyle(
                fontFamily: "Manrope",
                fontSize: 32.sp,
                fontWeight: FontWeight.w800,
                color: Color(0xff2C2C2C),
              ),
        ),
        const SizedBox(height: 5),
        Text(
          subheading ?? "",
          style: TextStyle(
            fontFamily: "Manrope",
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Color(0xff8B8B8B),
          ),
        ),
      ],
    );
  }
}

Widget titleText({String? title, bool? isRequired = false}) {
  return Text.rich(
    TextSpan(
      children: <InlineSpan>[
        TextSpan(
          text: title ?? '',
          style: TextStyle(
            fontFamily: "Manrope",
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: primaryClr,
          ),
        ),
        WidgetSpan(
          child: isRequired == true
              ? Text(
                  ' *',
                  style: TextStyle(
                    fontFamily: "Manrope",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    ),
  );
}

class CustomTextField extends StatefulWidget {
  final void Function()? onTap;
  final void Function()? onTapSuffix;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final String? hintText;
  final bool isPasswordType;
  final int? maxLength;
  final int? maxLine;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextStyle? hintStyle;
  final bool readonly;
  final bool atoFocus;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final bool filled;
  final Color? fillColor;
  final Widget? prefixIcon;
  final String? sufixText;
  final String? errortext;
  final InputDecoration? decration;
  final InputBorder? borderside;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? listInput;
  final Color? textColor;

  const CustomTextField({
    super.key,
    this.controller,
    this.atoFocus = false,
    this.onSaved,
    this.onTap,
    this.onChanged,
    this.onTapSuffix,
    this.hintText,
    this.keyboardType,
    this.hintStyle,
    this.maxLine,
    this.decration,
    this.validator,
    this.suffixIcon,
    this.focusNode,
    this.prefixIcon,
    this.sufixText,
    this.errortext,
    this.isPasswordType = false,
    this.readonly = false,
    this.maxLength,
    this.borderside,
    this.textColor,
    this.listInput,
    this.textCapitalization = TextCapitalization.none,
    this.fillColor = const Color(0xFFF5F5F5),
    this.filled = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: primaryClr,
      // scrollPadding:widget.scrolling??EdgeInsets.zero ,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      onSaved: widget.onSaved,
      readOnly: widget.readonly,
      autofocus: widget.atoFocus,
      focusNode: widget.focusNode,

      style: TextStyle(
        fontFamily: "Manrope",
        color: widget.textColor ?? Color(0xFF2C2C2C),
        fontWeight: FontWeight.w600,
        fontSize: 18.sp,
      ),
      maxLength: widget.maxLength,
      maxLines: widget.maxLine ?? 1,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      validator: widget.validator,

      inputFormatters: widget.listInput,
      obscureText: widget.isPasswordType ? _obscureText : false,
      textCapitalization: widget.textCapitalization,
      decoration:
          widget.decration ??
          InputDecoration(
            errorMaxLines: 4,
            errorText: widget.errortext,
            // errorStyle: const TextStyle(fontSize: 0.01),
            // errorStyle: CustomFontStyle().common(fontSize: 10),
            counter: const SizedBox.shrink(),
            fillColor: widget.fillColor,
            filled: widget.filled ? true : false,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 10.0,
            ),
            constraints: BoxConstraints(minHeight: 50.h),
            hintText: widget.hintText,
            suffixStyle: TextStyle(
              color: primaryClr,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              // height: 0.12,
            ),
            hintStyle:
                widget.hintStyle ??
                TextStyle(
                  color: const Color(0xFFCACACA),
                  fontSize: 14.sp,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.w600,
                  // height: 0.12,
                ),
            suffix: InkWell(
              onTap: widget.onTapSuffix,
              child: Text(widget.sufixText ?? ""),
            ),
            // suffixText: widget.sufixText,
            suffixIconConstraints: BoxConstraints(maxHeight: 65.h),
            prefixIcon: widget.prefixIcon,
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child:
                  widget.suffixIcon ??
                  (widget.isPasswordType
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          child: Icon(
                            _obscureText
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFFB5B5B5),
                          ),
                        )
                      : null),
            ),
            focusedBorder:
                widget.borderside ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0XFFE1E8F2)),
                ),
            errorBorder:
                widget.borderside ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.red),
                ),
            focusedErrorBorder:
                widget.borderside ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0XFFE1E8F2)),
                ),
            enabledBorder:
                widget.borderside ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0XFFD0DAEA)),
                ),
          ),
    );
  }
}

class CountryCodeShimmer extends StatelessWidget {
  const CountryCodeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 50,
        width: 90,
        margin: EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
