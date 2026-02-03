import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/custom_widgets/custom_button.dart';
import 'package:youbuilt/model/project_members.dart';
import 'package:youbuilt/providers/signin/project_provider.dart';
import 'package:youbuilt/screen/sign_up.dart';
import 'package:youbuilt/utils/colors.dart';
import 'package:youbuilt/utils/constants.dart';

class OverviewTab extends StatefulWidget {
  const OverviewTab({super.key});

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  // Store access level for each member by their index
  Map<int, String> memberAccessLevels = {};
  final List<String> accessList = ["Owner", "Full Access", "Limited"];

  // Search controller for filtering members
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<ProjectProvider>(
        builder: (context, project, _) {
          final dueDate = project.projectListViewModel?.data?.dueDate;
          final startDate = project.projectListViewModel?.data?.createdAt;
          final formattedDate = dueDate == null
              ? ""
              : DateFormat(
                  'dd MMM, yyyy',
                ).format(DateTime.parse(dueDate.toString()));
          final formattedDate2 = startDate == null
              ? ""
              : DateFormat(
                  'dd MMM, yyyy',
                ).format(DateTime.parse(startDate.toString()));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section with Members and Status
              Container(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Project Members Avatars
                    Consumer<ProjectProvider>(
                      builder: (context, provider, _) {
                        final members =
                            provider.projectMembersModel?.data?.members ?? [];
                        if (members.isEmpty) {
                          return const SizedBox();
                        }
                        return projectMembersAvatars(
                          members: members,
                          maxVisible: 4,
                        );
                      },
                    ),
                    const SizedBox(width: 5),

                    // Add Member Button
                    GestureDetector(
                      onTap: () {
                        _showInviteMembersDialog(context, project);
                      },
                      child: const Icon(
                        Icons.add_circle_outline,
                        color: Color(0xffFF3B30),
                      ),
                    ),
                    const Spacer(),

                    // Work Status Badge
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _getStatusBackgroundColor(
                          project.projectListViewModel?.data?.workStatus,
                        ),
                        border: Border.all(
                          color: _getStatusBorderColor(
                            project.projectListViewModel?.data?.workStatus,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "${project.projectListViewModel?.data?.workStatus ?? ""}",
                        style: TextStyle(
                          color: _getStatusTextColor(
                            project.projectListViewModel?.data?.workStatus,
                          ),
                          fontFamily: "Manrope",
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),

              // Description Card
              _infoCard(
                title: "Description",
                subtitle: project.projectListViewModel?.data?.description ?? "",
              ),

              // Start Date and End Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _infoCard(
                      title: "Start Date",
                      subtitle: formattedDate2,
                    ),
                  ),
                  Expanded(
                    child: _infoCard(
                      title: "End Date",
                      subtitle: formattedDate,
                    ),
                  ),
                ],
              ),

              kSpacer,

              // Recent Activity Section
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Activity",
                          style: TextStyle(
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: Color(0xff131313),
                          ),
                        ),
                        Text(
                          "View All",
                          style: TextStyle(
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Latest : ",
                          style: TextStyle(
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: Color(0xff131313),
                          ),
                        ),
                        Text(
                          "gfhg mkbhgfyuuyikuh",
                          style: TextStyle(
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: Color(0xff737373),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Best Practice Steps Info
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Follow these 8 best-practice steps to complete your project efficiently.",
                  style: TextStyle(
                    fontFamily: "Manrope",
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: Color(0xff282828),
                  ),
                ),
              ),

              // Project Steps List
              ListView.separated(
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      // Navigate to project detail view
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xffF4F4F4)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Icon
                          CircleAvatar(
                            backgroundColor: const Color(0xffF4F4F4),
                            radius: 30,
                            child: Image.asset(
                              "assets/planning_888979.png",
                              height: 30,
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Right Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title Row
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Preliminary Works",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: primaryClr,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Manrope",
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                // Date Row
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month_outlined,
                                      size: 18,
                                      color: Color(0xffA3A3A3),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        "13 Oct, 25 - 25 Feb, 26",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff8A8A8A),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Manrope",
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_right_outlined,
                                      color: Color(0xff8A8A8A),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // Show Invite Members Dialog
  void _showInviteMembersDialog(BuildContext context, ProjectProvider project) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Filter members based on search query
            final allMembers = project.projectMembersModel?.data?.members ?? [];
            final filteredMembers = allMembers.where((member) {
              if (searchQuery.isEmpty) return true;
              final userName = member.userName?.toLowerCase() ?? "";
              final phoneNumber = member.phoneNumber?.toLowerCase() ?? "";
              final query = searchQuery.toLowerCase();
              return userName.contains(query) || phoneNumber.contains(query);
            }).toList();

            return Dialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Invite Members",
                            style: TextStyle(
                              color: primaryClr,
                              fontFamily: "Manrope",
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1),

                    // Scrollable Content
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Mobile Number Input
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: CustomTextField(
                                    maxLine: 1,
                                    keyboardType: TextInputType.number,
                                    maxLength: 10,
                                    controller: project.phController,
                                    hintText: "Enter Mobile Number",
                                    fillColor: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: SizedBox(
                                    width: 50,
                                    child: CustomButton(
                                      text: "Invite",
                                      onPress: () async {
                                        if (project.phController.text.isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Please enter mobile number",
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        await project.inviteMembers(
                                          context: context,
                                          id:
                                              project
                                                  .projectListViewModel
                                                  ?.data
                                                  ?.id
                                                  .toString() ??
                                              "",
                                          phone: project.phController.text,
                                        );
                                        project.phController.clear();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Invite Link Section
                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xffF4F4F4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Invite Link",
                                          style: TextStyle(
                                            fontFamily: "Manrope",
                                            fontWeight: FontWeight.w600,
                                            color: primaryClr,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                        Text(
                                          "https://youbuilt.com/invitelink/076567",
                                          style: TextStyle(
                                            fontFamily: "Manrope",
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff0F7AF4),
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 6),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/solar_share-linear.png",
                                          height: 20,
                                          width: 20,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "Share",
                                          style: TextStyle(
                                            fontFamily: "Manrope",
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff737373),
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Members List Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Members List",
                                  style: TextStyle(
                                    fontFamily: "Manrope",
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff737373),
                                    fontSize: 14.sp,
                                  ),
                                ),
                                Text(
                                  (allMembers.length).toString(),
                                  style: TextStyle(
                                    fontFamily: "Manrope",
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff737373),
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),

                            // Members List Container
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Color(0xffDFDFDF)),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Search Field
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xffDFDFDF),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: TextField(
                                      controller: searchController,
                                      onChanged: (value) {
                                        setDialogState(() {
                                          searchQuery = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Search members",
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 12,
                                        ),
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Manrope",
                                        ),
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                          ),
                                          child: Image.asset(
                                            "assets/search.png",
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                        prefixIconConstraints: BoxConstraints(
                                          minHeight: 20,
                                          minWidth: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),

                                  // Members ListView
                                  ConstrainedBox(
                                    constraints: BoxConstraints(maxHeight: 150),
                                    child: filteredMembers.isEmpty
                                        ? Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                16.0,
                                              ),
                                              child: Text(
                                                "No members found",
                                                style: TextStyle(
                                                  fontFamily: "Manrope",
                                                  fontSize: 14,
                                                  color: Color(0xff737373),
                                                ),
                                              ),
                                            ),
                                          )
                                        : ListView.separated(
                                            shrinkWrap: true,
                                            physics: BouncingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              final member =
                                                  filteredMembers[index];

                                              // Initialize access level from member data or default
                                              final actualIndex = allMembers
                                                  .indexOf(member);
                                              memberAccessLevels.putIfAbsent(
                                                actualIndex,
                                                () =>
                                                    member.accessType ??
                                                    "Limited",
                                              );

                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    // Avatar
                                                    CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor:
                                                          primaryClr,
                                                      backgroundImage:
                                                          member.profileImage !=
                                                                  null &&
                                                              member
                                                                  .profileImage
                                                                  .toString()
                                                                  .isNotEmpty
                                                          ? NetworkImage(
                                                              member
                                                                  .profileImage,
                                                            )
                                                          : null,
                                                      child:
                                                          member.profileImage ==
                                                                  null ||
                                                              member
                                                                  .profileImage
                                                                  .toString()
                                                                  .isEmpty
                                                          ? Text(
                                                              _getInitials(
                                                                member.userName,
                                                              ),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "Manrope",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )
                                                          : null,
                                                    ),
                                                    SizedBox(width: 10),

                                                    // User Info
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            member.userName ??
                                                                "Unknown User",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  "Manrope",
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: primaryClr,
                                                            ),
                                                          ),
                                                          Text(
                                                            member.phoneNumber ??
                                                                "",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  "Manrope",
                                                              fontSize: 12,
                                                              color: Color(
                                                                0xff737373,
                                                              ),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    // Access Level Dropdown
                                                    Container(
                                                      width: 80,
                                                      height: 30,
                                                      padding: EdgeInsets.all(
                                                        4,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Color(
                                                          0xffF4F4F4,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                      ),
                                                      child: DropdownButtonHideUnderline(
                                                        child: DropdownButton<String>(
                                                          value:
                                                              memberAccessLevels[actualIndex],
                                                          icon: const Icon(
                                                            Icons
                                                                .keyboard_arrow_down,
                                                            color: Color(
                                                              0xff737373,
                                                            ),
                                                          ),
                                                          dropdownColor:
                                                              Colors.white,
                                                          isExpanded: true,
                                                          style:
                                                              const TextStyle(
                                                                color: Color(
                                                                  0xff737373,
                                                                ),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 14,
                                                              ),
                                                          onChanged: (value) {
                                                            setDialogState(() {
                                                              memberAccessLevels[actualIndex] =
                                                                  value!;
                                                            });
                                                          },
                                                          items: accessList.map((
                                                            item,
                                                          ) {
                                                            return DropdownMenuItem<
                                                              String
                                                            >(
                                                              value: item,
                                                              child: Text(
                                                                item,
                                                                style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    ),

                                                    // More Options
                                                    Icon(
                                                      Icons.more_vert,
                                                      color: Color(0xff737373),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return Divider(
                                                height: 1,
                                                color: Color(0xffDFDFDF),
                                              );
                                            },
                                            itemCount: filteredMembers.length,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Action Buttons
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: "Cancel",
                              borderSide: BorderSide(color: Color(0xff737373)),
                              bgColor: Colors.white,
                              textColor: primaryClr,
                              onPress: () {
                                searchController.clear();
                                searchQuery = "";
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: CustomButton(
                              text: "Save",
                              onPress: () {
                                // TODO: Implement save functionality
                                // Update member access levels on the server
                                searchController.clear();
                                searchQuery = "";
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Helper Methods

  Widget _infoCard({required String title, required String subtitle}) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: "Manrope",
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              color: Color(0xffA3A3A3),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: "Manrope",
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              color: Color(0xff282828),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return "?";
    final parts = name.trim().split(" ");
    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  Widget projectMembersAvatars({
    required List<Member> members,
    double radius = 15,
    double overlap = 14,
    int maxVisible = 4,
  }) {
    final visibleMembers = members.take(maxVisible).toList();
    final remainingCount = members.length - maxVisible;

    return SizedBox(
      height: radius * 2,
      width:
          (radius * 2) +
          (visibleMembers.length - 1) * overlap +
          (remainingCount > 0 ? overlap : 0),
      child: Stack(
        children: [
          ...List.generate(visibleMembers.length, (index) {
            final member = visibleMembers[index];
            return Positioned(
              left: index * overlap,
              child: CircleAvatar(
                radius: radius,
                backgroundColor: primaryClr,
                backgroundImage:
                    member.profileImage != null &&
                        member.profileImage.toString().isNotEmpty
                    ? NetworkImage(member.profileImage)
                    : null,
                child:
                    member.profileImage == null ||
                        member.profileImage.toString().isEmpty
                    ? Text(
                        _getInitials(member.userName),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
            );
          }),

          // Show "+N" badge if there are more members
          if (remainingCount > 0)
            Positioned(
              left: visibleMembers.length * overlap,
              child: CircleAvatar(
                radius: radius,
                backgroundColor: Color(0xff737373),
                child: Text(
                  "+$remainingCount",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Status color helpers
  Color _getStatusBackgroundColor(String? status) {
    switch (status) {
      case "Progress":
        return Color(0xffDAE2F6);
      case "Completed":
        return Color(0xffCFEAD2);
      default:
        return Color(0xffF6E1DF);
    }
  }

  Color _getStatusBorderColor(String? status) {
    switch (status) {
      case "Progress":
        return Color(0xff487FFF);
      case "Completed":
        return Color(0xff00AF11);
      default:
        return Color(0xffFF766A);
    }
  }

  Color _getStatusTextColor(String? status) {
    switch (status) {
      case "Progress":
        return Color(0xff487FFF);
      case "Completed":
        return Color(0xff00AF11);
      default:
        return Color(0xffFF766A);
    }
  }
}
