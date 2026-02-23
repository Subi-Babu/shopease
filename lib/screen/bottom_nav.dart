import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:liquid_glass_bottom_bar/liquid_glass_bottom_bar.dart';
import 'package:youbuilt/screen/cart/cart.dart';
import 'package:youbuilt/screen/profile/profile.dart';
import 'package:youbuilt/screen/projects/projects.dart';

import 'home.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    AllProductsPage(),
    ProjectScreen(),
    ProfileMenuPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // REQUIRED for transparent nav
      body: _pages[currentIndex],

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(999),
          clipBehavior: Clip.antiAlias,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                // color: Colors.black.withOpacity(0.10), // glass look
                color: Colors.black, // glass look
                border: Border.all(color: Colors.white, width: 0),
              ),
              child: LiquidGlassBottomBar(
                height: 60,
                margin: const EdgeInsets.all(0),
                currentIndex: currentIndex,
                showLabels: true,

                /// Keep bar transparent
                barBlurSigma: 0,
                activeBlurSigma: 10,
                activeColor: Colors.white,
                onTap: (index) {
                  setState(() => currentIndex = index);
                },

                items: const [
                  LiquidGlassBottomBarItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: "Home",
                  ),
                  LiquidGlassBottomBarItem(
                    icon: Icons.shopping_cart_outlined,
                    activeIcon: Icons.shopping_cart,
                    label: "Cart",
                  ),
                  LiquidGlassBottomBarItem(
                    icon: Icons.work_outline,
                    activeIcon: Icons.work,
                    label: "Projects",
                  ),
                  LiquidGlassBottomBarItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: "Profile",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
