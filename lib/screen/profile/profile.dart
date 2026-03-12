import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youbuilt/screen/onborading.dart';
import 'package:youbuilt/screen/profile/address.dart';
import 'package:youbuilt/screen/profile/edit_profile.dart';
import 'package:youbuilt/screen/profile/orders.dart';
import 'package:youbuilt/screen/profile/service_booking.dart';
import 'package:youbuilt/utils/colors.dart';
import 'package:youbuilt/utils/constants.dart';
import 'package:youbuilt/utils/sharedpref_util.dart';

import '../../providers/signin/project_provider.dart';

class ProfileMenuPage extends StatefulWidget {
  const ProfileMenuPage({super.key});

  @override
  State<ProfileMenuPage> createState() => _ProfileMenuPageState();
}

class _ProfileMenuPageState extends State<ProfileMenuPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = Provider.of<ProjectProvider>(context, listen: false);
      await reg.fetchProfile(context: context);
      await reg.fetchOrderList(context: context, keyword: "");
      await reg.fetchServiceBooking(context: context);
    });
    // TODO: implement initState
    super.initState();
  }

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
          child: Consumer<ProjectProvider>(
            builder: (context, project, _) {
              return Column(
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
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserProfilePage(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: const Color(0xffC1C1C1),
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          project
                                              .profileModel
                                              ?.data
                                              ?.profileImage ??
                                          '',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Color(0xffE0E0E0),
                                          ),
                                      errorWidget: (context, url, error) =>
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundColor: const Color(
                                              0xffC1C1C1,
                                            ),
                                            child: Text(
                                              project?.profileModel?.data?.name
                                                      ?.substring(0, 1)
                                                      .toUpperCase() ??
                                                  "",
                                              style: const TextStyle(
                                                color: primaryClr,
                                              ),
                                            ),
                                          ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      project?.profileModel?.data?.name ?? "",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: "Manrope",
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      project?.profileModel?.data?.cuId
                                              .toString() ??
                                          "",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: "Manrope",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserProfilePage(),
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
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
                        _menuTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddressPage(),
                              ),
                            );
                          },
                          assetPath: "assets/tdesign_location.png",
                          title: "Addresses",
                        ),
                        _divider(),
                        _menuTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyOrdersPage(),
                              ),
                            );
                          },
                          assetPath: "assets/10768855_4503794 1.png",
                          title: "My Orders",
                        ),
                        _divider(),
                        _menuTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyServicePage(),
                              ),
                            );
                          },
                          assetPath:
                              "assets/fluent_clipboard-task-24-regular.png",
                          title:
                              // Icons.calendar_today_outlined,
                              "Service Bookings",
                        ),
                        // _divider(),
                        // _menuTile(
                        //   assetPath: "assets/proicons_info.png",
                        //   title: "About Us",
                        // ),
                        _divider(),
                        _menuTile(
                          assetPath: "assets/stash_shield-duotone.png",
                          title: "Privacy Policy",
                          onTap: () {
                            launchPrivacyPolicy();
                          },
                        ),
                        _divider(),
                        _menuTile(
                          onTap: () {
                            launchContactUs();
                          },
                          assetPath: "assets/solar_phone-linear.png",
                          title: "Contact Us",
                        ),
                        _divider(),
                        _menuTile(
                          onTap: () {
                            launchTerms();
                          },
                          assetPath: "assets/basil_document-outline.png",
                          title: "Terms & Conditions",
                        ),
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
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _menuTile({
    String? assetPath,
    IconData? icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: assetPath != null
          ? Image.asset(assetPath, width: 22, color: Colors.black54)
          : Icon(icon, size: 22, color: Colors.black54),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: "Manrope",
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.black38,
      ),
      onTap: onTap,
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
  SharedPrefUtil.clear();
  accessToken = null;
  Future.delayed(Duration(milliseconds: 10), () {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  });
  // Navigate to login screen
  // Navigator.pushAndRemoveUntil(
  //   context,
  //   MaterialPageRoute(builder: (_) => const OnBoardingScreen()),
  //   (route) => false,
  // );
}

Future<void> launchPrivacyPolicy() async {
  final Uri url = Uri.parse("https://www.youbuilt.biz/privacy-policy");

  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication, // Opens in browser
  )) {
    throw Exception('Could not launch $url');
  }
}

Future<void> launchTerms() async {
  final Uri url = Uri.parse("https://www.youbuilt.biz/term-conditions");

  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication, // Opens in browser
  )) {
    throw Exception('Could not launch $url');
  }
}

Future<void> launchContactUs() async {
  final Uri url = Uri.parse(
    "https://tawk.to/chat/6986d3629501661c38bbc8b4/1jgrajf8v",
  );

  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}
