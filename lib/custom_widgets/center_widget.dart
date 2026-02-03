import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youbuilt/utils/colors.dart';

class CenterWidget extends StatelessWidget {
  final String imageUrl;
  final String heading;
  final String description;
  final VoidCallback? onSkip; // optional skip action

  const CenterWidget({
    required this.imageUrl,
    required this.heading,
    required this.description,
    this.onSkip,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: SizedBox(
                height: 300.h,
                width: double.infinity,
                child: Image.asset(imageUrl, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 40, // adjust for top padding if needed
              right: 20,
              child: GestureDetector(
                onTap: onSkip,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0XFF241522),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      fontFamily: "Manrope",

                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                heading,
                style: const TextStyle(
                  fontFamily: "Manrope",
                  color: primaryClr,
                  fontWeight: FontWeight.w700,
                  fontSize: 33,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "Manrope",
                  color: Color(0xff808080),
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
