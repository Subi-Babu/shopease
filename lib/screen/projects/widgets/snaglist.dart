import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/custom_widgets/custom_button.dart';
import 'package:youbuilt/model/sanp_drop_model.dart';
import 'package:youbuilt/providers/signin/project_provider.dart';
import 'package:youbuilt/screen/sign_up.dart';
import 'package:youbuilt/utils/colors.dart';
import 'package:youbuilt/utils/constants.dart';

String selectedValue = "Low";

class Snaglist extends StatefulWidget {
  final String? projectId;
  const Snaglist({super.key, required this.projectId});

  @override
  State<Snaglist> createState() => _SnaglistState();
}

class _SnaglistState extends State<Snaglist> {
  // ✅ Track expanded state for each snag
  Map<String, bool> expandedSnags = {};

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = Provider.of<ProjectProvider>(context, listen: false);
      await reg.fetchSnagDropdown(context: context);
      await reg.fetchSnagList(context: context, id: widget.projectId ?? "");

      // ✅ INITIALIZE PRIORITY DROPDOWNS FROM API DATA
      _initializePriorityDropdowns(reg);
    });
    super.initState();
  }

  // ✅ NEW METHOD: Initialize dropdowns with API values
  void _initializePriorityDropdowns(ProjectProvider project) {
    final allSnags = project.snagListModel?.projectSnagList ?? [];
    final dropdownList = project.snagDropdownModel?.snagStatusDropDown ?? [];

    if (dropdownList.isEmpty) return;

    // Clear existing selections
    project.selectedSnagStatusDropList.clear();

    // For each snag, find matching dropdown item based on snagStatusId
    for (var snag in allSnags) {
      final snagStatusId = snag.snagStatusId;

      // Find the matching dropdown item
      SnagStatusDropDown matchedItem = dropdownList.firstWhere(
        (dropdownItem) => dropdownItem.value == snagStatusId,
        orElse: () => dropdownList.first, // Fallback to first item
      );

      project.selectedSnagStatusDropList.add(matchedItem);
    }

    // Trigger UI update
    project.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Pending & Completed
      child: Scaffold(
        backgroundColor: const Color(0xffF4F4F4),

        body: Column(children: [Expanded(child: _headerSection())]),

        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(16.w),
          child: CustomButton(
            text: "Add Snag",
            icon1: const Icon(Icons.add, color: Colors.white),
            onPress: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return Consumer<ProjectProvider>(
                    builder: (context, project, _) {
                      final list =
                          project.snagDropdownModel?.snagStatusDropDown ?? [];

                      return AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Snag",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: "Manrope",
                                fontSize: 16,
                                color: primaryClr,
                              ),
                            ),
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Icon(Icons.close),
                            ),
                          ],
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomTextField(
                              hintText: "Snag Title",
                              fillColor: Colors.white,
                              controller: project.titleController,
                            ),
                            SizedBox(height: 12),

                            Container(
                              height: 42,
                              width: ScreenUtil().screenWidth,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<SnagStatusDropDown>(
                                  value: project.selectedSnagStatus,

                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 14,
                                  ),

                                  items: list.map((e) {
                                    log(
                                      "--listtt--${e.label}------${project.selectedSnagStatus}",
                                    );
                                    return DropdownMenuItem<SnagStatusDropDown>(
                                      value: e,
                                      child: Text(
                                        e.label ?? "",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: _priorityColor(e.label),
                                        ),
                                      ),
                                    );
                                  }).toList(),

                                  onChanged: (SnagStatusDropDown? value) {
                                    if (value != null) {
                                      project.setSnagStatus(value);

                                      debugPrint(
                                        "Selected → ${value.label} | API value → ${value.value}",
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          CustomButton(
                            text: "Save",
                            onPress: () async {
                              await project.addSnagList(
                                context: context,
                                title: project.titleController.text ?? "",
                                id: project.selectedSnagId.toString() ?? "",
                                pid: widget.projectId,
                              );
                              project.titleController.clear();
                              project.selectedSnagId == 1;
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _headerSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xffDFDFDF)),
      ),
      child: Consumer<ProjectProvider>(
        builder: (context, project, _) {
          double progressValue = 0.0;

          final percentageList = project.snagListModel?.percentage;

          if (percentageList != null && percentageList.isNotEmpty) {
            progressValue = (double.tryParse(percentageList.first) ?? 0) / 100;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Snag List",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: primaryClr,
                  fontFamily: "Manrope",
                ),
              ),

              const SizedBox(height: 6),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Progress",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff737373),
                      fontFamily: "Manrope",
                    ),
                  ),
                  Text(
                    "${percentageList?.first ?? "0"}%",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff737373),
                      fontFamily: "Manrope",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: progressValue,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.green,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _tabBar(project),

              const SizedBox(height: 12),

              Expanded(child: _tabBarView()),
            ],
          );
        },
      ),
    );
  }

  Widget _tabBar(ProjectProvider project) {
    return TabBar(
      labelColor: primaryClr,
      unselectedLabelColor: const Color(0xffC1C1C1),
      indicatorColor: const Color(0xffFF3B30),

      tabAlignment: TabAlignment.fill,
      indicatorSize: TabBarIndicatorSize.tab,

      tabs: [
        Tab(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Pending",
                style: TextStyle(
                  fontSize: 16,
                  // color: primaryClr,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              CircleAvatar(
                radius: 15,
                backgroundColor: const Color(0xffFFEAE9),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "${project.snagListModel?.pendingSnags ?? ""}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xffFF766A),
                      fontWeight: FontWeight.w600,
                      fontFamily: "Manrope",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Tab(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Completed",
                style: TextStyle(
                  fontSize: 16,
                  // color: Color(0xffC1C1C1),
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              CircleAvatar(
                radius: 15,
                backgroundColor: Color(0xffD9F3DB),
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    "${project.snagListModel?.completedSnags ?? ""}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff00AF11),
                      fontWeight: FontWeight.w600,
                      fontFamily: "Manrope",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tabBarView() {
    return Consumer<ProjectProvider>(
      builder: (context, project, _) {
        final allSnags = project.snagListModel?.projectSnagList ?? [];

        final pendingList = allSnags
            .where((e) => e.isComplete == false)
            .toList();

        final completedList = allSnags
            .where((e) => e.isComplete == true)
            .toList();

        return TabBarView(
          children: [
            // 🔴 Pending list with priority-based border color and expandable text
            ListView.separated(
              itemCount: pendingList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final snag = pendingList[index];

                // Find the actual index in the full allSnags list
                final actualIndex = allSnags.indexOf(snag);

                // ✅ Get percentage value
                String percentageValue = "${snag.completePercentage ?? 0}%";
                if (project.selectedPercentages.length > actualIndex &&
                    project.selectedPercentages[actualIndex] != "0%") {
                  percentageValue = project.selectedPercentages[actualIndex];
                }

                // ✅ Get priority dropdown value for this snag's actual index
                SnagStatusDropDown? priorityValue;
                if (project.selectedSnagStatusDropList.length > actualIndex) {
                  priorityValue =
                      project.selectedSnagStatusDropList[actualIndex];
                } else {
                  // Fallback: match by snagStatusId
                  final list =
                      project.snagDropdownModel?.snagStatusDropDown ?? [];
                  priorityValue = list.firstWhere(
                    (item) => item.value == snag.snagStatusId,
                    orElse: () =>
                        list.isNotEmpty ? list.first : SnagStatusDropDown(),
                  );
                }

                return _snagCard(
                  data: snag.details ?? "",
                  borderColor: _priorityColor(priorityValue?.label),
                  checked: snag.isComplete ?? false,
                  deleteTap: () async {
                    await project.deleteSnag(
                      context: context,
                      pid: widget.projectId ?? "",
                      snagId: snag.id.toString(),
                    );
                  },
                  snagId: snag.id.toString(),
                  // Percentage dropdown handler
                  onChanged: (val) async {
                    if (val != null) {
                      while (project.selectedPercentages.length <=
                          actualIndex) {
                        project.selectedPercentages.add("0%");
                      }
                      project.updatePercentage(value: val, index: actualIndex);
                      print("----------%valuee--$val");
                      await project.updatePercentSnagList(
                        context: context,
                        snagId: snag.id.toString(),
                        completePercentage: val,
                      );
                    }
                  },
                  dataVal: percentageValue,

                  // Priority dropdown handler
                  onChangedDrop: (val) async {
                    if (val != null) {
                      // Ensure list is large enough
                      while (project.selectedSnagStatusDropList.length <=
                          actualIndex) {
                        project.selectedSnagStatusDropList.add(
                          project
                                  .snagDropdownModel
                                  ?.snagStatusDropDown
                                  ?.first ??
                              SnagStatusDropDown(),
                        );
                      }

                      // Update the priority for this specific index
                      project.setSnagStatusDrop(value: val, index: actualIndex);
                      await project.updatePercentSnagStatus(
                        context: context,
                        snagId: snag.id.toString(),
                        completePercentage: "",
                        snagStatus: val.value.toString(),
                      );

                      print(
                        "----------Priority changed at index $actualIndex--${val.label}",
                      );
                    }
                  },
                  datadrop: priorityValue,

                  // ✅ Checkbox handler for pending items
                  onCheckboxChanged: (bool? value) async {
                    if (value != null) {
                      await project.updateSnagCompleteStatus(
                        context: context,
                        completeStatus: value,
                        snagId: snag.id.toString(),
                      );

                      // Refresh the snag list after update
                      await project.fetchSnagList(
                        context: context,
                        id: widget.projectId ?? "",
                      );

                      // Re-initialize priority dropdowns after refresh
                      _initializePriorityDropdowns(project);
                    }
                  },

                  // ✅ NEW: Pass expanded state
                  isExpanded: expandedSnags[snag.id.toString()] ?? false,
                  onToggleExpand: () {
                    setState(() {
                      expandedSnags[snag.id.toString()] =
                          !(expandedSnags[snag.id.toString()] ?? false);
                    });
                  },
                );
              },
            ),

            // 🟢 Completed list with priority-based border color and expandable text
            ListView.separated(
              itemCount: completedList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final snag = completedList[index];

                // Find the actual index in the full allSnags list
                final actualIndex = allSnags.indexOf(snag);

                // ✅ Get priority for completed items
                SnagStatusDropDown? priorityValue;
                if (project.selectedSnagStatusDropList.length > actualIndex) {
                  priorityValue =
                      project.selectedSnagStatusDropList[actualIndex];
                } else {
                  final list =
                      project.snagDropdownModel?.snagStatusDropDown ?? [];
                  priorityValue = list.firstWhere(
                    (item) => item.value == snag.snagStatusId,
                    orElse: () =>
                        list.isNotEmpty ? list.first : SnagStatusDropDown(),
                  );
                }

                return project.loading1 == true
                    ? SizedBox()
                    : _snagCard(
                        data: snag.details ?? "",
                        borderColor: _priorityColor(priorityValue?.label),
                        dataVal: "${snag.completePercentage ?? 100}%",
                        checked: true,
                        snagId: snag.id.toString(),
                        onChanged: (val) {},
                        onChangedDrop: (val) {},
                        datadrop: priorityValue,
                        deleteTap: () async {
                          await project.deleteSnag(
                            context: context,
                            pid: widget.projectId ?? "",
                            snagId: snag.id.toString(),
                          );
                        },
                        // ✅ Enable checkbox for completed items to allow unchecking
                        onCheckboxChanged: (bool? value) async {
                          if (value != null) {
                            await project.updateSnagCompleteStatus(
                              context: context,
                              completeStatus: value,
                              snagId: snag.id.toString(),
                            );

                            // Refresh the snag list after update
                            await project.fetchSnagList(
                              context: context,
                              id: widget.projectId ?? "",
                            );

                            // Re-initialize priority dropdowns after refresh
                            _initializePriorityDropdowns(project);
                          }
                        },
                        // ✅ NEW: Enable expand/collapse for completed items too
                        isExpanded: expandedSnags[snag.id.toString()] ?? false,
                        onToggleExpand: () {
                          setState(() {
                            expandedSnags[snag.id.toString()] =
                                !(expandedSnags[snag.id.toString()] ?? false);
                          });
                        },
                      );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _snagCard({
    required Color borderColor,
    required String data,
    required String dataVal,
    required void Function(String?) onChanged,
    required void Function()? deleteTap,
    required SnagStatusDropDown? datadrop,
    required void Function(SnagStatusDropDown?) onChangedDrop,
    required bool checked,
    required String snagId,
    required void Function(bool?)? onCheckboxChanged,
    required bool isExpanded,
    required void Function()? onToggleExpand,
  }) {
    return Consumer<ProjectProvider>(
      builder: (context, project, _) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xffF4F4F4),
            borderRadius: BorderRadius.circular(10),
            border: Border(left: BorderSide(color: borderColor, width: 4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Expandable text with "More/Less" button
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data,
                    maxLines: isExpanded ? null : 2,
                    overflow: isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: primaryClr,
                      fontFamily: "Manrope",
                    ),
                  ),

                  // ✅ Show More/Less button only if text exceeds 2 lines and toggle is enabled
                  if (onToggleExpand != null && _shouldShowToggle(data))
                    InkWell(
                      onTap: onToggleExpand,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          isExpanded ? "Show Less" : "Show More",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                            fontFamily: "Manrope",
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 8),
              Row(
                children: [
                  _percentageDropdown(onChanged: onChanged, val: dataVal),
                  const SizedBox(width: 8),
                  _priorityDropdown(
                    onChangedDrop: onChangedDrop,
                    val: datadrop,
                    project: project,
                  ),
                  const Spacer(),
                  Checkbox(
                    value: checked,
                    checkColor: Colors.white,
                    activeColor: Colors.green,
                    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.green;
                      }
                      return Colors.grey.shade300;
                    }),
                    onChanged: onCheckboxChanged == null
                        ? null
                        : (project.memberLoads == false
                              ? null
                              : onCheckboxChanged),
                  ),
                  InkWell(
                    onTap: deleteTap,
                    child: Icon(Icons.delete_outline_sharp, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ✅ Helper method to determine if text needs "Show More" button
  bool _shouldShowToggle(String text) {
    final textPainter =
        TextPainter(
          text: TextSpan(
            text: text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: "Manrope",
            ),
          ),
          maxLines: 2,
          textDirection: TextDirection.ltr,
        )..layout(
          maxWidth: MediaQuery.of(context).size.width - 80,
        ); // Account for padding

    return textPainter.didExceedMaxLines;
  }

  Widget _priorityDropdown({
    required ProjectProvider project,
    required void Function(SnagStatusDropDown?) onChangedDrop,
    required SnagStatusDropDown? val,
  }) {
    final list = project.snagDropdownModel?.snagStatusDropDown ?? [];

    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SnagStatusDropDown>(
          value: val,
          icon: const Icon(Icons.keyboard_arrow_down, size: 14),
          items: list.map((e) {
            return DropdownMenuItem<SnagStatusDropDown>(
              value: e,
              child: Text(
                e.label ?? "",
                style: TextStyle(fontSize: 11, color: _priorityColor(e.label)),
              ),
            );
          }).toList(),
          onChanged: onChangedDrop,
        ),
      ),
    );
  }

  Widget _percentageDropdown({
    required void Function(String?) onChanged,
    String? val,
  }) {
    return Consumer<ProjectProvider>(
      builder: (context, project, _) {
        return Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: val,
              icon: const Icon(Icons.keyboard_arrow_down, size: 14),
              items: ["0%", "25%", "50%", "75%", "100%"]
                  .map(
                    (e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e, style: const TextStyle(fontSize: 11)),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        );
      },
    );
  }
}

Color _priorityColor(String? label) {
  switch (label) {
    case "Low":
      return Colors.green;
    case "Medium":
      return Colors.blueAccent;
    case "High":
      return Colors.orange;
    case "Critical":
      return Colors.red;
    default:
      return Colors.black;
  }
}
