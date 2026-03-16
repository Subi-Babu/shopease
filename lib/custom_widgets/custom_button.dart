import 'package:flutter/material.dart';
import 'package:youbuilt/utils/colors.dart';
import 'package:youbuilt/utils/constants.dart';

class CustomButton extends StatefulWidget {
  final Function()? onPress;
  final bool isLoading;
  final String text;
  final Widget? icon;
  final Widget? icon1;
  final Color? bgColor;
  final Color? textColor;
  final BorderSide? borderSide;

  const CustomButton({
    super.key,
    this.onPress,
    required this.text,
    this.icon,
    this.icon1,
    this.bgColor,
    this.borderSide,
    this.isLoading = false,
    this.textColor,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (!widget.isLoading) {
          setState(() => _isPressed = true);
        }
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: widget.bgColor ?? primaryClr,
            shape: RoundedRectangleBorder(
              side: widget.borderSide ?? BorderSide.none,
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          onPressed: widget.isLoading ? null : widget.onPress,
          child: widget.isLoading
              ? kLoading
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon1 != null) const SizedBox(width: 8),
                    widget.icon1 ?? const SizedBox.shrink(),
                    if (widget.icon1 != null) const SizedBox(width: 8),

                    Flexible(
                      child: Text(
                        widget.text,
                        style: TextStyle(
                          fontFamily: "Manrope",
                          fontSize: 17,
                          color: widget.textColor ?? backgroundColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    if (widget.icon != null) const SizedBox(width: 5),
                    widget.icon ?? const SizedBox.shrink(),
                  ],
                ),
        ),
      ),
    );
  }
}
