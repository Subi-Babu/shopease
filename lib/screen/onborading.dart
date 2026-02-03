import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:youbuilt/custom_widgets/center_widget.dart';
import 'package:youbuilt/screen/sign_up.dart';

import '../../../utils/colors.dart';
import '../custom_widgets/custom_button.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserSignUpScreen()),
      );
      // Navigate to login when page=2 and button pressed
      // Navigator.pushNamed(context, Routers.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top PageView
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              children: [
                CenterWidget(
                  imageUrl: 'assets/splash1 1.png',
                  heading: "Purchase",
                  description:
                      "Shop building materials \n& machinery with ease.",
                  onSkip: nextPage,
                ),
                CenterWidget(
                  imageUrl: 'assets/splash3 1.png',
                  heading: "Service",
                  description:
                      "Book trusted construction \nservices anytime, anywhere.",
                  onSkip: nextPage,
                ),
                CenterWidget(
                  imageUrl: 'assets/splash2 1.png',
                  heading: "Projects",
                  description:
                      "Manage your project, budget \n& tasks in one place.",
                  onSkip: nextPage,
                ),
              ],
            ),
          ),

          // Smooth Indicator
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 16),
            child: Align(
              alignment: Alignment.center,
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 3,
                effect: const ExpandingDotsEffect(
                  dotColor: Color(0xffD9D9D9),
                  activeDotColor: primaryClr,
                  dotWidth: 10,
                  dotHeight: 6,
                  expansionFactor: 4,
                ),
              ),
            ),
          ),

          // Bottom Button + Text
          Padding(
            padding: const EdgeInsets.only(
              bottom: 40,
              right: 16,
              left: 16,
              top: 15,
            ),
            child: Column(
              children: [
                CustomButton(
                  text: "Next",
                  bgColor: const Color(0XFF242424),
                  onPress: nextPage,
                ),

                // const SizedBox(height: 10),
                //
                // RichText(
                //   text: TextSpan(
                //     text: "Already Have an Account? ",
                //     style: const TextStyle(
                //       color: Colors.white,
                //       fontFamily: "Manrope",
                //
                //       fontWeight: FontWeight.w400,
                //       fontSize: 15,
                //     ),
                //     children: [
                //       TextSpan(
                //         text: "Log In",
                //         style: const TextStyle(
                //           fontFamily: "Manrope",
                //           color: Colors.blue,
                //           fontWeight: FontWeight.w500,
                //           fontSize: 15,
                //         ),
                //         recognizer: TapGestureRecognizer()
                //           ..onTap = () {
                //             // Navigator.pushReplacement(
                //             //   context,
                //             //   MaterialPageRoute(
                //             //     builder: (context) => const LoginScreen(),
                //             //   ),
                //             // );
                //           },
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
