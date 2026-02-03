import 'package:flutter/material.dart';

class ValidationUtil {
  final BuildContext context;
  ValidationUtil(this.context);

  String? phoneValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Your Mobile Number";
    } else if (value.length < 10) {
      return 'Enter a Valid Number';
    } else {
      return null;
    }
  }

  // String? validatePassword(String? value) {
  //   RegExp regex =
  //       RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  //   if (value!.isEmpty) {
  //     return 'Please enter password';
  //   } else {
  //     if (!regex.hasMatch(value)) {
  //       return 'Password should contain upper,lower,digit,special character and password must be at least 8 characters long ';
  //     } else {
  //       return null;
  //     }
  //   }
  // }
  // // String? passwordValidation(String? value) {
  //   if (value!.isEmpty) return "Please enter your password";
  //   return null;
  // }

  String? confirmPasswordValidation(String? password, String? confirmPassword) {
    if (password!.isEmpty) {
      return "Please re-enter your password";
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? nameValidation(String? value) {
    if (value!.isEmpty) return "Enter Name";
    return null;
  }

  String? pinValidation(String? value) {
    if (value!.isEmpty) return "Enter Pin Number";
    return null;
  }

  String? otpValidation(String? value) {
    if (value!.isEmpty) return "Enter otp";
    return null;
  }

  String? pwd(String? value) {
    if (value!.isEmpty) return "Enter password";
    return null;
  }

  // String? validateEmail(String? value) {
  //   bool email = RegExp(
  //           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
  //       .hasMatch(value!);
  //   if (value.isEmpty) {
  //     return 'Enter Email';
  //   } else if (email == false) {
  //     return 'Enter a valid email';
  //   }
  //   return null;
  // }

  // String? emailValidation(String? email) {
  //   bool valid = RegExp(
  //           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
  //       .hasMatch(email!);
  //   print(valid);
  //   if (email.isEmpty) {
  //     return 'Please Enter Email';
  //   } else if (valid == false) {
  //     return 'Enter Valid email';
  //   }
  //   return null;
  // }

  String? commonValidation({String? value, String? text}) {
    if (value!.isEmpty) return text ?? 'enter some text';
    return null;
  }

  String? accountNumberValidation({String? value}) {
    if (value!.isEmpty) {
      return 'Enter Account Number';
    } else if (value.length < 7) {
      return 'Enter Valid Account Number';
    }
    return null;
  }
}
