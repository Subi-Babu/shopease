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

  int page = 1;
  bool isLoadingMore = false;
  bool hasMoreData = true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollController.addListener(_scrollListener);
      final reg = Provider.of<ProjectProvider>(context, listen: false);
      await reg.fetchSnagDropdown(context: context);
      await reg.fetchSnagList(
        context: context,
        id: widget.projectId ?? "",
        pge: page.toString(),
        limit: "10",
      );

      // ✅ INITIALIZE PRIORITY DROPDOWNS FROM API DATA
      _initializePriorityDropdowns(reg);
    });
    super.initState();
  }

  void _scrollListener() async {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!isLoadingMore && hasMoreData) {
        isLoadingMore = true;

        page++;

        final project = Provider.of<ProjectProvider>(context, listen: false);

        await project.fetchSnagList(
          context: context,
          id: widget.projectId ?? "",
          pge: page.toString(),
          limit: "10",
        );

        if ((project.snagListModel?.projectSnagList?.length ?? 0) < page * 10) {
          hasMoreData = false;
        }

        isLoadingMore = false;
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ✅ FIXED: Proper initialization with type-safe comparison
  void _initializePriorityDropdowns(ProjectProvider project) {
    final allSnags = project.snagListModel?.projectSnagList ?? [];
    final dropdownList = project.snagDropdownModel?.snagStatusDropDown ?? [];

    if (dropdownList.isEmpty) return;

    // Clear existing selections
    project.selectedSnagStatusDropList.clear();

    // For each snag, find matching dropdown item based on snagStatusId
    for (var snag in allSnags) {
      final snagStatusId = snag.snagStatusId;

      // ✅ Debug: Print what we're looking for
      debugPrint(
        "Looking for snagStatusId: $snagStatusId for snag: ${snag.details}",
      );

      // ✅ Find the EXACT object from the dropdown list by comparing VALUES
      SnagStatusDropDown matchedItem = dropdownList.firstWhere(
        (dropdownItem) {
          // Convert both to strings for comparison to avoid type mismatches
          final dropdownValue = dropdownItem.value?.toString();
          final snagValue = snagStatusId?.toString();

          debugPrint(
            "Comparing dropdown value: $dropdownValue with snag value: $snagValue",
          );

          return dropdownValue == snagValue;
        },
        orElse: () {
          debugPrint("No match found, using first item");
          return dropdownList.first;
        },
      );

      debugPrint(
        "Matched item label: ${matchedItem.label}, value: ${matchedItem.value}",
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

        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: _topHeader(), // Snag List + Progress
                ),

                SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabBarDelegate(
                    TabBar(
                      labelColor: primaryClr,
                      unselectedLabelColor: const Color(0xffC1C1C1),
                      indicatorColor: const Color(0xffFF3B30),
                      tabs: [
                        Tab(
                          child: Consumer<ProjectProvider>(
                            builder: (context, project, _) => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Pending",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Manrope",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: const Color(0xffFFEAE9),
                                  child: Text(
                                    "${project.snagListModel?.pendingSnags ?? "0"}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xffFF766A),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Manrope",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Tab(
                          child: Consumer<ProjectProvider>(
                            builder: (context, project, _) => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Completed",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Manrope",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: const Color(0xffD9F3DB),
                                  child: Text(
                                    "${project.snagListModel?.completedSnags ?? "0"}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff00AF11),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Manrope",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },

            body: _tabBarView(), // Only list scrolls
          ),
        ),

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
                                  // ✅ Add hint to show "Select Priority" when null
                                  hint: Text(
                                    "Select Priority",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
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
                              project.fetchSnagList(
                                context: context,
                                id: widget.projectId ?? "",
                                pge: page.toString(),
                                limit: "10",
                              );
                              project.titleController.clear();
                              // ✅ Reset to null instead of 1
                              project.selectedSnagStatus = null;
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

  Widget _topHeader() {
    return Consumer<ProjectProvider>(
      builder: (context, project, _) {
        double progressValue = 0.0;

        final percentageList = project.snagListModel?.percentage;

        if (percentageList != null && percentageList.isNotEmpty) {
          progressValue = (double.tryParse(percentageList.first) ?? 0) / 100;
        }

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xffDFDFDF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Snag List",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: primaryClr,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () async {
                      await project.downloadSnagPdf(
                        id: int.parse(widget.projectId.toString()) ?? 0,
                        context: context,
                      );
                    },
                    child: const Text(
                      "Download",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: primaryClr,
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  InkWell(
                    onTap: () async {
                      await project.downloadSnagPdf(
                        id: int.parse(widget.projectId.toString()) ?? 0,
                        context: context,
                      );
                    },
                    child: Icon(
                      Icons.file_download_outlined,
                      color: primaryClr,
                      size: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Progress", style: TextStyle(fontSize: 12)),
                  Text("${percentageList?.first ?? "0"}%"),
                ],
              ),

              const SizedBox(height: 8),

              LinearProgressIndicator(
                value: progressValue,
                minHeight: 6,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ],
          ),
        );
      },
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
      isScrollable: false,
      tabAlignment: TabAlignment.start,
      // labelPadding: const EdgeInsets.only(right: 20),

      // tabAlignment: TabAlignment.fill,
      indicatorSize: TabBarIndicatorSize.label,
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

        return Container(
          color: Colors.white,
          child: TabBarView(
            children: [
              // 🔴 Pending list with priority-based border color and expandable text
              ListView.separated(
                controller: _scrollController,
                // physics: NeverScrollableScrollPhysics(),
                itemCount: pendingList.length + (isLoadingMore ? 1 : 0),
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: 20,
                ),
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
                    // Fallback: match by snagStatusId using string comparison
                    final list =
                        project.snagDropdownModel?.snagStatusDropDown ?? [];
                    priorityValue = list.firstWhere(
                      (item) =>
                          item.value?.toString() ==
                          snag.snagStatusId?.toString(),
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
                        project.updatePercentage(
                          value: val,
                          index: actualIndex,
                        );
                        print("----------%valuee--$val");
                        await project.updatePercentSnagList(
                          context: context,
                          snagId: snag.id.toString(),
                          completePercentage: val,
                        );
                      }
                    },
                    dataVal: percentageValue,

                    // ✅ FIXED: Priority dropdown handler with debug logging
                    onChangedDrop: (val) async {
                      if (val != null) {
                        // ✅ Debug logging
                        debugPrint("=== PRIORITY CHANGE DEBUG ===");
                        debugPrint("Selected label: ${val.label}");
                        debugPrint("Selected value: ${val.value}");
                        debugPrint(
                          "Selected value type: ${val.value.runtimeType}",
                        );
                        debugPrint("Snag ID: ${snag.id}");
                        debugPrint(
                          "Current snagStatusId: ${snag.snagStatusId}",
                        );
                        debugPrint(
                          "Current snagStatusId type: ${snag.snagStatusId.runtimeType}",
                        );

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
                        project.setSnagStatusDrop(
                          value: val,
                          index: actualIndex,
                        );
                        await project.updatePercentSnagStatus(
                          context: context,
                          snagId: snag.id.toString(),
                          completePercentage: "",
                          snagStatus: val.value.toString(),
                        );

                        print(
                          "----------Priority changed at index $actualIndex--${val.label}",
                        );

                        // ✅ Refresh data after update to ensure sync
                        await project.fetchSnagList(
                          context: context,
                          id: widget.projectId ?? "",
                          pge: page.toString(),
                          limit: "10",
                        );
                        _initializePriorityDropdowns(project);
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
                          pge: page.toString(),

                          limit: "10",
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
              Container(
                color: Colors.white,
                child: ListView.separated(
                  controller: _scrollController,

                  // physics: NeverScrollableScrollPhysics(),
                  itemCount: completedList.length + (isLoadingMore ? 1 : 0),
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 20,
                  ),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final snag = completedList[index];

                    // Find the actual index in the full allSnags list
                    final actualIndex = allSnags.indexOf(snag);

                    // ✅ Get priority for completed items with string comparison
                    SnagStatusDropDown? priorityValue;
                    if (project.selectedSnagStatusDropList.length >
                        actualIndex) {
                      priorityValue =
                          project.selectedSnagStatusDropList[actualIndex];
                    } else {
                      final list =
                          project.snagDropdownModel?.snagStatusDropDown ?? [];
                      priorityValue = list.firstWhere(
                        (item) =>
                            item.value?.toString() ==
                            snag.snagStatusId?.toString(),
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
                                  pge: page.toString(),

                                  limit: "10",
                                );

                                // Re-initialize priority dropdowns after refresh
                                _initializePriorityDropdowns(project);
                              }
                            },
                            // ✅ NEW: Enable expand/collapse for completed items too
                            isExpanded:
                                expandedSnags[snag.id.toString()] ?? false,
                            onToggleExpand: () {
                              setState(() {
                                expandedSnags[snag.id.toString()] =
                                    !(expandedSnags[snag.id.toString()] ??
                                        false);
                              });
                            },
                          );
                  },
                ),
              ),
            ],
          ),
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
                    onChanged: onCheckboxChanged,
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

  // ✅ FIXED: Priority dropdown with proper value matching using string comparison
  Widget _priorityDropdown({
    required ProjectProvider project,
    required void Function(SnagStatusDropDown?) onChangedDrop,
    required SnagStatusDropDown? val,
  }) {
    final list = project.snagDropdownModel?.snagStatusDropDown ?? [];

    // Handle empty list case
    if (list.isEmpty) {
      return Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Text("No options", style: TextStyle(fontSize: 11)),
        ),
      );
    }

    // ✅ Find exact match by value (ID) using string comparison to avoid type issues
    SnagStatusDropDown? selectedItem;
    if (val?.value != null) {
      try {
        selectedItem = list.firstWhere(
          (item) => item.value?.toString() == val!.value?.toString(),
        );
        debugPrint(
          "Priority Dropdown - Found match: ${selectedItem.label} with value: ${selectedItem.value}",
        );
      } catch (e) {
        debugPrint(
          "Priority Dropdown - No match found for value: ${val?.value}",
        );
        selectedItem = null; // If no match found, show "Select Priority"
      }
    }

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
          value: selectedItem, // ✅ Use the matched item or null
          hint: Text(
            "Select Priority",
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
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

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16), // ✅ left padding
        child: tabBar,
      ),
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) => false;
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
