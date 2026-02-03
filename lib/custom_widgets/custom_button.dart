import 'package:flutter/material.dart';
import 'package:youbuilt/utils/colors.dart';
import 'package:youbuilt/utils/constants.dart';

class CustomButton extends StatelessWidget {
  final Function()? onPress;
  bool isLoading;
  final String text;
  final Widget? icon;
  final Widget? icon1;
  final Color? bgColor;
  final Color? textColor;
  final BorderSide? borderSide;
  CustomButton({
    this.onPress,
    required this.text,
    this.icon,
    this.icon1,
    super.key,
    this.bgColor,
    this.borderSide,
    this.isLoading = false,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: bgColor ?? primaryClr,
        shape: RoundedRectangleBorder(
          side: borderSide ?? BorderSide.none,
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      onPressed: isLoading ? null : onPress,
      child: isLoading
          ? kLoading
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: icon1 != null,
                  child: const SizedBox(width: 8),
                ),

                icon1 ?? const SizedBox.shrink(),
                Visibility(
                  visible: icon1 != null,
                  child: const SizedBox(width: 8),
                ),
                Text(
                  text,
                  style: TextStyle(
                    fontFamily: "Manrope",
                    fontSize: 17,
                    color: textColor ?? backgroundColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Visibility(
                  visible: icon != null,
                  child: const SizedBox(width: 5),
                ),
                icon ?? const SizedBox.shrink(),
              ],
            ),
    );
  }
}
