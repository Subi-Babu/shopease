import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/custom_widgets/custom_button.dart';
import 'package:youbuilt/utils/colors.dart';

import '../../providers/signin/project_provider.dart';
import '../sign_up.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = Provider.of<ProjectProvider>(context, listen: false);
      await reg.fetchProfile(context: context);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<ProjectProvider>(
          builder: (context, profile, _) {
            return Column(
              children: [
                // HEADER + AVATAR STACK
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Header Image
                    Container(
                      width: double.infinity,
                      height: 180.h,
                      child: Image.asset(
                        "assets/Group 1000004378.png",
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Header Content
                    Positioned(
                      top: 50.h,
                      left: 16.w,
                      right: 16.w,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "User Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),

                    // Profile Avatar
                    Positioned(
                      bottom: -40.h,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Color(0xffE0E0E0),

                              child: CachedNetworkImage(
                                imageUrl:
                                    profile.profileModel?.data?.profileImage ??
                                    '',
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Color(0xffE0E0E0),
                                    ),
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
                                      radius: 80.r,
                                      backgroundColor: const Color(0xffF0F1F4),
                                      child: Text(
                                        profile?.profileModel?.data?.name
                                                ?.substring(0, 1)
                                                .toUpperCase() ??
                                            "",
                                        style: TextStyle(color: primaryClr),
                                      ),
                                    ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 14.r,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.edit,
                                  size: 14.sp,
                                  color: const Color(0xff8A8A8A),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // SPACE FOR OVERLAP
                SizedBox(height: 60.h),

                // FORM
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CustomTextField(
                            hintText: "Name",
                            fillColor: Colors.white,
                            readonly: true,
                            controller: TextEditingController(
                              text: profile.profileModel?.data?.name ?? "",
                            ),
                          ),
                          SizedBox(height: 10),
                          CustomTextField(
                            hintText: "Phone Number",
                            fillColor: Colors.white,
                            readonly: true,
                            controller: TextEditingController(
                              text:
                                  "${profile.profileModel?.data?.code ?? ""}  ${profile.profileModel?.data?.phoneNumber ?? ""}",
                            ),
                          ),
                          SizedBox(height: 10),
                          CustomTextField(
                            hintText: "Email",
                            fillColor: Colors.white,
                            readonly: true,
                            controller: TextEditingController(
                              text: profile.profileModel?.data?.email ?? "",
                            ),
                          ),
                          SizedBox(height: 10),
                          CustomTextField(
                            hintText: "Gender",
                            fillColor: Colors.white,
                            readonly: true,
                            controller: TextEditingController(
                              text: profile.profileModel?.data?.gender ?? "",
                            ),
                          ),
                          SizedBox(height: 10),
                          CustomTextField(
                            hintText: "Gst Number",
                            fillColor: Colors.white,
                            readonly: true,
                            controller: TextEditingController(
                              // text: profile.profileModel?.data?. ?? "",
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ),

                // SAVE BUTTON
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: CustomButton(text: "Edit", onPress: () {}),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // TEXT FIELD
  Widget _inputField({required String label}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  // PHONE FIELD
  Widget _phoneField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text("+91"),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // GENDER DROPDOWN
  Widget _dropdownField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "Gender",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: const [
          DropdownMenuItem(value: "Male", child: Text("Male")),
          DropdownMenuItem(value: "Female", child: Text("Female")),
        ],
        onChanged: (value) {},
      ),
    );
  }
}
