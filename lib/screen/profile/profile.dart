import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youbuilt/screen/onborading.dart';
import 'package:youbuilt/utils/colors.dart';

class ProfileMenuPage extends StatelessWidget {
  const ProfileMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        // statusBarColor: Colors.white, // ✅ White status bar
        statusBarIconBrightness: Brightness.light, // Android icons
        statusBarBrightness: Brightness.dark, // iOS icons
      ),
      child: Scaffold(
        backgroundColor: Colors.white,

        body: SingleChildScrollView(
          child: Column(
            children: [
              // 🔹 Header
              Container(
                width: double.infinity,
                height: 180,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      "assets/Group 1000004378.png",
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 80, 16, 24),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Steve Harrington",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: "Manrope",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Trivandrum, Kerala",
                                style: TextStyle(
                                  color: Color(0xffA3A3A3),
                                  fontSize: 14,
                                  fontFamily: "Manrope",
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 🔹 Menu Card
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xffE0E0E0)),
                ),
                child: Column(
                  children: [
                    _menuTile(Icons.location_on_outlined, "Addresses"),
                    _divider(),
                    _menuTile(Icons.shopping_bag_outlined, "My Orders"),
                    _divider(),
                    _menuTile(
                      Icons.calendar_today_outlined,
                      "Service Bookings",
                    ),
                    _divider(),
                    _menuTile(Icons.info_outline, "About Us"),
                    _divider(),
                    _menuTile(Icons.privacy_tip_outlined, "Privacy Policy"),
                    _divider(),
                    _menuTile(Icons.phone_outlined, "Contact Us"),
                    _divider(),
                    _menuTile(Icons.description_outlined, "Terms & Conditions"),
                  ],
                ),
              ),

              // 🔹 Logout
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Container(
                  width: ScreenUtil().screenWidth,
                  decoration: BoxDecoration(color: Color(0xffF4F4F4)),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showLogoutDialog(context);
                    },

                    icon: const Icon(Icons.logout),
                    label: const Text("Logout"),
                    style: OutlinedButton.styleFrom(
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: "Manrope",
                        fontWeight: FontWeight.w600,
                        color: primaryClr,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Color(0xffA3A3A3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuTile(IconData icon, String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.black54),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.black38,
      ),
      onTap: () {},
    );
  }
}

Widget _divider() => const Divider(height: 1, color: Color(0xffE0E0E0));
void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "Logout",
          style: TextStyle(
            fontFamily: "Manrope",
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          "Are you sure you want to logout?",
          style: TextStyle(
            fontFamily: "Manrope",
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Color(0xffF4F4F4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            onPressed: () {
              Navigator.pop(context); // close dialog
            },
            child: const Text(
              "Cancel",
              style: TextStyle(fontFamily: "Manrope", color: primaryClr),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context); // close dialog

              // 🔥 CLEAR SHARED PREFERENCES HERE
              _logoutUser(context);
            },
            child: const Text(
              "Logout",
              style: TextStyle(fontFamily: "Manrope", color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}

Future<void> _logoutUser(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // 🔥 clears everything

  // Navigate to login screen
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => const OnBoardingScreen()),
    (route) => false,
  );
}
