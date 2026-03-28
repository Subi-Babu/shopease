import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/custom_widgets/custom_button.dart';
import 'package:youbuilt/screen/sign_up.dart';
import 'package:youbuilt/utils/colors.dart';
import '../../providers/signin/project_provider.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool isEditing = false;

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController phonecodeController;
  late TextEditingController emailController;
  late TextEditingController genderController;
  late TextEditingController gstController;

  String selectedGender = "";
  File? selectedImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    phoneController = TextEditingController();
    phonecodeController = TextEditingController();
    emailController = TextEditingController();
    genderController = TextEditingController();
    gstController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<ProjectProvider>(context, listen: false);
      await provider.fetchProfile(context: context);

      final data = provider.profileModel?.data;

      if (mounted) {
        setState(() {
          nameController.text = data?.name ?? "";
          phoneController.text = data?.phoneNumber ?? "";
          phonecodeController.text = data?.code ?? "";
          emailController.text = data?.email ?? "";
          selectedGender = data?.gender ?? "";
          genderController.text = selectedGender;
          gstController.text = data?.gst ?? "";
        });
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    genderController.dispose();
    gstController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  void _showImagePicker() {
    final ctx = context;
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Choose Profile Picture",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Camera"),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Gallery"),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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
                /// HEADER
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Image.asset(
                      "assets/Group 1000004378.png",
                      width: double.infinity,
                      height: 180.h,
                      fit: BoxFit.cover,
                    ),

                    Positioned(
                      top: 60.h,
                      left: 16.w,
                      right: 16.w,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
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

                    /// PROFILE IMAGE (Tap To Edit)
                    Positioned(
                      bottom: -60.h,
                      left: 0,
                      right: 0,
                      child:
                          /// HEADER
                          Column(
                            children: [
                              Stack(
                                children: [
                                  Image.asset(
                                    "assets/Group 1000004378.png",
                                    width: double.infinity,
                                    height: 180.h,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 50.h,
                                    left: 16.w,
                                    right: 16.w,
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () => Navigator.pop(context),
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
                                ],
                              ),

                              /// PROFILE IMAGE OUTSIDE THE STACK
                              Transform.translate(
                                offset: Offset(0, -40.h),
                                child: GestureDetector(
                                  onTap: () {
                                    print("TAPPED"); // test this first
                                    if (isEditing) {
                                      _showImagePicker();
                                    }
                                  },
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      CircleAvatar(
                                        radius: 45,
                                        backgroundColor: const Color(
                                          0xffE0E0E0,
                                        ),
                                        child: ClipOval(
                                          child: selectedImage != null
                                              ? Image.file(
                                                  selectedImage!,
                                                  height: 90,
                                                  width: 90,
                                                  fit: BoxFit.cover,
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl:
                                                      profile
                                                          .profileModel
                                                          ?.data
                                                          ?.profileImage ??
                                                      '',
                                                  height: 90,
                                                  width: 90,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      const CircularProgressIndicator(),
                                                  errorWidget:
                                                      (
                                                        context,
                                                        url,
                                                        error,
                                                      ) => Center(
                                                        child: Text(
                                                          nameController
                                                                  .text
                                                                  .isNotEmpty
                                                              ? nameController
                                                                    .text[0]
                                                                    .toUpperCase()
                                                              : "",
                                                          style: TextStyle(
                                                            color: primaryClr,
                                                            fontSize: 22,
                                                          ),
                                                        ),
                                                      ),
                                                ),
                                        ),
                                      ),
                                      if (isEditing)
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.edit,
                                            size: 18,
                                            color: Colors.red,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                    ),
                  ],
                ),

                SizedBox(height: 60.h),

                /// FORM
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CustomTextField(
                            hintText: "Name",
                            readonly: !isEditing,
                            controller: nameController,
                          ),
                          SizedBox(height: 12.h),

                          Row(
                            children: [
                              /// COUNTRY CODE
                              Container(
                                width: 80.w,
                                child: CustomTextField(
                                  hintText: "+91",
                                  readonly: true,
                                  controller: phonecodeController,
                                ),
                              ),

                              SizedBox(width: 10.w),

                              /// PHONE NUMBER
                              Expanded(
                                child: CustomTextField(
                                  hintText: "Phone Number",
                                  readonly: true,
                                  controller: phoneController,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 12.h),

                          CustomTextField(
                            hintText: "Email",
                            readonly: !isEditing,
                            controller: emailController,
                          ),
                          SizedBox(height: 12.h),

                          isEditing
                              ? DropdownButtonFormField<String>(
                                  value: selectedGender.isEmpty
                                      ? null
                                      : selectedGender,
                                  decoration: InputDecoration(
                                    hintText: "Gender",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: "MALE",
                                      child: Text("Male"),
                                    ),
                                    DropdownMenuItem(
                                      value: "FEMALE",
                                      child: Text("Female"),
                                    ),
                                    DropdownMenuItem(
                                      value: "OTHERS",
                                      child: Text("Others"),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value ?? "";
                                      genderController.text = selectedGender;
                                    });
                                  },
                                )
                              : CustomTextField(
                                  hintText: "Gender",
                                  readonly: true,
                                  controller: genderController,
                                ),
                          SizedBox(height: 12),
                          CustomTextField(
                            hintText: "Gst Number",
                            readonly: !isEditing,
                            controller: gstController,
                            // controller: genderController,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// BUTTON
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: CustomButton(
                    text: profile.expense
                        ? "Updating..."
                        : isEditing
                        ? "Save"
                        : "Edit",
                    onPress: profile.expense
                        ? null
                        : () async {
                            if (isEditing) {
                              await profile.editProfile(
                                context: context,
                                name: nameController.text.trim(),
                                email: emailController.text.trim(),
                                gender: selectedGender,
                                number: phoneController.text.trim(),
                                file: selectedImage,
                              );

                              await profile.fetchProfile(context: context);

                              if (mounted) {
                                setState(() {
                                  isEditing = false;
                                  selectedImage = null;
                                });
                              }
                            } else {
                              setState(() {
                                isEditing = true;
                              });
                            }
                          },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
