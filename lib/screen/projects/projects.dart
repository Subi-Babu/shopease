import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/custom_widgets/custom_button.dart';
import 'package:youbuilt/providers/signin/project_provider.dart';
import 'package:youbuilt/screen/projects/project_view.dart';
// import 'package:youbuilt/projects/add_projects.dart';
import 'package:youbuilt/utils/colors.dart';

import '../../model/project_list_model.dart';
import 'add_projects.dart';

String selectedValue = "All";
const Map<String, String> statusApiMap = {
  "All": "",
  "Completed": "Completed",
  "In Progress": "Progress",
  "On Hold": "On_Hold",
};

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = Provider.of<ProjectProvider>(context, listen: false);
      reg.fetchProjectList(context: context, status: "");


    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: SizedBox(),
        title: Text(
          "Projects",
          style: TextStyle(
            color: primaryClr,
            fontFamily: "Manrope",
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            // onTap: () {
            //   showDialog(
            //     context: context,
            //     builder: (context) {
            //       return AlertDialog(
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(12),
            //         ),
            //         title: const Text(
            //           "Invitations",
            //           style: TextStyle(fontWeight: FontWeight.w600),
            //         ),
            //         content: const Text("You have no new invitations."),
            //         actions: [
            //           TextButton(
            //             onPressed: () => Navigator.pop(context),
            //             child: const Text("Close"),
            //           ),
            //         ],
            //       );
            //     },
            //   );
            // },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Color(0xffF4F4F4),
                border: Border.all(color: Color(0xffD1D5DB)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Invitations",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Manrope",
                  color: primaryClr,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Consumer<ProjectProvider>(
          builder: (context, project, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Divider(color: Color(0xffECECEC), height: 5),
                Container(
                  margin: const EdgeInsets.only(right: 16, left: 16, top: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, width: 1),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search project",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Manrope",
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Image.asset(
                          "assets/search.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minHeight: 0,
                        minWidth: 0,
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffF4F4F4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IntrinsicHeight(
                    // 🔥 IMPORTANT
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _statColumn(
                          "Total",
                          "${project.projectListModel?.totalproject ?? ""}",
                          primaryClr,
                        ),
                        _vDivider(),
                        _statColumn(
                          "Completed",
                          "${project.projectListModel?.statusCount?.completed ?? ""}",
                          Color(0xff00AF11),
                        ),
                        _vDivider(),
                        _statColumn(
                          "In Progress",
                          "${project.projectListModel?.statusCount?.inProcess ?? ""}",
                          Color(0xff487FFF),
                        ),
                        _vDivider(),
                        _statColumn(
                          "On Hold",
                          "${project.projectListModel?.statusCount?.onHold ?? ""}",
                          Color(0xffFF766A),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 45.h,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedValue,
                            icon: Padding(
                              padding: const EdgeInsets.only(
                                left: 5,
                                bottom: 5,
                              ),
                              child: const Icon(Icons.keyboard_arrow_down),
                            ),

                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: "Manrope",
                              fontWeight: FontWeight.w500,
                            ),

                            onChanged: (String? newValue) {
                              if (newValue == null) return;

                              setState(() {
                                selectedValue = newValue;
                              });

                              /// ✅ convert UI value → API value
                              final status = statusApiMap[newValue] ?? "";

                              /// ✅ call API again
                              Provider.of<ProjectProvider>(
                                context,
                                listen: false,
                              ).fetchProjectList(
                                context: context,
                                status: status,
                              );
                            },

                            items: [
                              DropdownMenuItem(
                                value: "All",
                                child: Text("All"),
                              ),
                              DropdownMenuItem(
                                value: "Completed",
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 15,
                                      color: Colors.green,
                                    ),
                                    SizedBox(width: 8),
                                    Text("Completed"),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: "In Progress",
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/progress.png",
                                      height: 12,
                                    ),

                                    SizedBox(width: 4),
                                    Text("In Progress"),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: "On Hold",
                                child: Row(
                                  children: [
                                    Image.asset("assets/hold.png", height: 12),
                                    SizedBox(width: 4),
                                    Text("On Hold"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AddProjects()),
                          );
                        },
                        child: Container(
                          width: 180.h,
                          height: 45.h,
                          padding: EdgeInsets.all(8),
                          // flex: 0,
                          decoration: BoxDecoration(
                            color: primaryClr,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 18),
                              SizedBox(width: 5),

                              Text(
                                "Create Project",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Manrope",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                project.load == true
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: CircularProgressIndicator(color: primaryClr),
                        ),
                      )
                    : project.projectListModel?.projectList?.length == 0
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/undraw_no-data_ig65 1.png",
                              width: 256.w,
                              height: 250.h,
                            ),
                            Center(
                              child: Text(
                                "No projects yet",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: primaryClr,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Manrope",
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                "Create your first project to get started.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xfff737373),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Manrope",
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.separated(
                          // padding: const EdgeInsets.all(16),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                              project.projectListModel?.projectList?.length ??
                              0, // your list length
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 12);
                          },
                          itemBuilder: (context, index) {
                            final dueDate = project
                                .projectListModel
                                ?.projectList?[index]
                                .dueDate;

                            final formattedDate = dueDate == null
                                ? ""
                                : DateFormat(
                                    'dd MMM, yyyy',
                                  ).format(DateTime.parse(dueDate.toString()));
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProjectView(
                                          projectId: project
                                              .projectListModel
                                              ?.projectList?[index]
                                              .id
                                              .toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF4F4F4),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        /// Title Row
                                        Row(
                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              project
                                                      .projectListModel
                                                      ?.projectList?[index]
                                                      .name ??
                                                  "",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: primaryClr,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Manrope",
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    project
                                                            .projectListModel
                                                            ?.projectList?[index]
                                                            .workStatus ==
                                                        "Progress"
                                                    ? Color(0xffDAE2F6)
                                                    : project
                                                              .projectListModel
                                                              ?.projectList?[index]
                                                              .workStatus ==
                                                          "Completed"
                                                    ? Color(0xffCFEAD2)
                                                    : Color(0xffF6E1DF),
                                                border: Border.all(
                                                  color:
                                                      project
                                                              .projectListModel
                                                              ?.projectList?[index]
                                                              .workStatus ==
                                                          "Progress"
                                                      ? Color(0xff487FFF)
                                                      : project
                                                                .projectListModel
                                                                ?.projectList?[index]
                                                                .workStatus ==
                                                            "Completed"
                                                      ? Color(0xff00AF11)
                                                      : Color(0xffFF766A),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              padding: EdgeInsets.all(4),
                                              child: Text(
                                                project
                                                        .projectListModel
                                                        ?.projectList?[index]
                                                        .workStatus ??
                                                    "",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color:
                                                      project
                                                              .projectListModel
                                                              ?.projectList?[index]
                                                              .workStatus ==
                                                          "Progress"
                                                      ? Color(0xff487FFF)
                                                      : project
                                                                .projectListModel
                                                                ?.projectList?[index]
                                                                .workStatus ==
                                                            "Completed"
                                                      ? Color(0xff00AF11)
                                                      : Color(0xffFF766A),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Manrope",
                                                ),
                                              ),
                                            ),
                                            PopupMenuButton<String>(
                                              padding: EdgeInsets.zero,
                                              color: Colors
                                                  .white, // 👈 popup background color
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              icon: const Icon(
                                                Icons.more_horiz,
                                                color: Color(0xff737373),
                                              ),
                                              onSelected: (value) {
                                                if (value == 'edit') {
                                                  // Edit action
                                                } else if (value == 'delete') {
                                                  // Delete action
                                                }
                                              },
                                              itemBuilder:
                                                  (BuildContext context) => [
                                                    const PopupMenuItem(
                                                      value: 'edit',
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.edit,
                                                            color: Color(
                                                              0xff487FFF,
                                                            ),
                                                          ),

                                                          Text(
                                                            'Edit',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Color(
                                                                0xff487FFF,
                                                              ),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  "Manrope",
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const PopupMenuItem(
                                                      value: 'delete',
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .delete_rounded,
                                                            color: Color(
                                                              0xffFF766A,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Delete',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Color(
                                                                0xffFF766A,
                                                              ),

                                                              // color: Color(0xff8A8A8A),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  "Manrope",
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 4),

                                        /// Address
                                        // Text(
                                        //   project
                                        //           .projectListModel
                                        //           ?.projectList?[index]
                                        //           .description ??
                                        //       "",
                                        //   maxLines: 1,
                                        //   overflow: TextOverflow.ellipsis,
                                        //   style: TextStyle(
                                        //     fontSize: 14,
                                        //     color: Color(0xff8A8A8A),
                                        //     fontWeight: FontWeight.w500,
                                        //     fontFamily: "Manrope",
                                        //   ),
                                        // ),
                                        //
                                        // const SizedBox(height: 6),
                                        Divider(color: Color(0xffE0E0E0)),

                                        const SizedBox(height: 6),

                                        /// Date + Avatars
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_month_outlined,
                                              size: 18,
                                              color: Color(0xffA3A3A3),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              formattedDate ?? "",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff8A8A8A),
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Manrope",
                                              ),
                                            ),
                                            const Spacer(),

                                            /// Overlapping Avatars
                                            // SizedBox(
                                            //   width: 60,
                                            //   height: 24,
                                            //   child: Stack(
                                            //     children: [
                                            //       Positioned(
                                            //         left: 0,
                                            //         child: CircleAvatar(
                                            //           radius: 12,
                                            //           backgroundColor:
                                            //               Colors.blue,
                                            //         ),
                                            //       ),
                                            //       Positioned(
                                            //         left: 14,
                                            //         child: CircleAvatar(
                                            //           radius: 12,
                                            //           backgroundColor:
                                            //               Colors.green,
                                            //         ),
                                            //       ),
                                            //       Positioned(
                                            //         left: 28,
                                            //         child: CircleAvatar(
                                            //           radius: 12,
                                            //           backgroundColor: Color(
                                            //             0xffE0E0E0,
                                            //           ),
                                            //           child: Text(
                                            //             "2+",
                                            //             style: TextStyle(
                                            //               fontSize: 10,
                                            //               color: Color(
                                            //                 0xff727272,
                                            //               ),
                                            //               fontWeight:
                                            //                   FontWeight.w500,
                                            //             ),
                                            //           ),
                                            //         ),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
                                            projectMembersStack(
                                              project
                                                  .projectListModel
                                                  ?.projectList?[index]
                                                  .projectMembers,
                                            ),

                                            Icon(
                                              Icons
                                                  .keyboard_arrow_right_outlined,
                                              color: Color(0xff8A8A8A),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
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

  Widget _vDivider() {
    return VerticalDivider(
      width: 20,
      thickness: 1.2,
      color: Colors.grey.shade400, // 👈 visible
    );
  }

  Widget _statColumn(String title, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: color,
            fontFamily: "Manrope",
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: primaryClr,
            fontFamily: "Manrope",
          ),
        ),
      ],
    );
  }

  Widget projectMembersStack(List<ProjectMember>? members) {
    if (members == null || members.isEmpty) {
      return const SizedBox.shrink();
    }

    final visibleMembers = members.take(2).toList();
    final remainingCount = members.length - visibleMembers.length;

    return SizedBox(
      width: 60,
      height: 24,
      child: Stack(
        children: [
          for (int i = 0; i < visibleMembers.length; i++)
            Positioned(
              left: i * 14.0,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: primaryClr,
                backgroundImage: visibleMembers[i].users?.profileImage != null
                    ? NetworkImage(
                        visibleMembers[i].users!.profileImage.toString(),
                      )
                    : null,
                child: visibleMembers[i].users?.profileImage == null
                    ? Text(
                        _getInitials(visibleMembers[i].users?.name),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : null,
              ),
            ),

          if (remainingCount > 0)
            Positioned(
              left: visibleMembers.length * 14.0,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: const Color(0xffE0E0E0),
                child: Text(
                  "+$remainingCount",
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xff727272),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return "";
    final parts = name.trim().split(" ");
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return "${parts[0][0]}${parts[1][0]}".toUpperCase();
  }
}
