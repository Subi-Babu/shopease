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
  Map<String, bool> expandedSnags = {};

  int page = 1;
  bool isLoadingMore = false;
  bool hasMoreData = true;

  final ScrollController _nestedScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _nestedScrollController.addListener(_scrollListener);
      final project = Provider.of<ProjectProvider>(context, listen: false);
      await project.fetchSnagDropdown(context: context);
      await project.fetchSnagList(
        context: context,
        id: widget.projectId ?? "",
        pge: "1",
        limit: "10",
      );
      _initializePriorityDropdowns(project);
    });
  }

  // ✅ Unified reset + refresh — always call this after add/delete/update
  Future<void> _resetAndRefresh() async {
    final project = Provider.of<ProjectProvider>(context, listen: false);

    setState(() {
      page = 1;
      hasMoreData = true;
      isLoadingMore = false;
    });

    await project.fetchSnagList(
      context: context,
      id: widget.projectId ?? "",
      pge: "1",
      limit: "10",
    );
    _initializePriorityDropdowns(project);
  }

  void _scrollListener() async {
    if (_nestedScrollController.position.pixels >=
        _nestedScrollController.position.maxScrollExtent - 100) {
      if (!isLoadingMore && hasMoreData) {
        setState(() => isLoadingMore = true);

        final project = Provider.of<ProjectProvider>(context, listen: false);

        page++;

        await project.fetchSnagList(
          context: context,
          id: widget.projectId ?? "",
          pge: page.toString(),
          limit: "10",
        );

        final currentLength =
            project.snagListModel?.projectSnagList?.length ?? 0;

        setState(() {
          // If total items fetched are less than expected, no more pages
          if (currentLength < page * 10) {
            hasMoreData = false;
          }
          isLoadingMore = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nestedScrollController.removeListener(_scrollListener);
    _nestedScrollController.dispose();
    super.dispose();
  }

  void _initializePriorityDropdowns(ProjectProvider project) {
    final allSnags = project.snagListModel?.projectSnagList ?? [];
    final dropdownList = project.snagDropdownModel?.snagStatusDropDown ?? [];

    if (dropdownList.isEmpty) return;

    project.selectedSnagStatusDropList.clear();

    for (var snag in allSnags) {
      final snagStatusId = snag.snagStatusId;

      SnagStatusDropDown matchedItem = dropdownList.firstWhere((dropdownItem) {
        final dropdownValue = dropdownItem.value?.toString();
        final snagValue = snagStatusId?.toString();
        return dropdownValue == snagValue;
      }, orElse: () => dropdownList.first);

      project.selectedSnagStatusDropList.add(matchedItem);
    }

    project.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          controller: _nestedScrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(child: _topHeader()),
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
          body: _tabBarView(),
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
                              child: const Icon(Icons.close),
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
                            const SizedBox(height: 12),
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
                                title: project.titleController.text,
                                id: project.selectedSnagId.toString(),
                                pid: widget.projectId,
                              );
                              project.titleController.clear();
                              project.selectedSnagStatus = null;
                              Navigator.pop(context);
                              // ✅ Use reset refresh so page resets to 1
                              await _resetAndRefresh();
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
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      await project.downloadSnagPdf(
                        id: int.parse(widget.projectId.toString()),
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
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () async {
                      await project.downloadSnagPdf(
                        id: int.parse(widget.projectId.toString()),
                        context: context,
                      );
                    },
                    child: const Icon(
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
            // 🔴 Pending Tab
            ListView.separated(
              itemCount: pendingList.length + (isLoadingMore ? 1 : 0),
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 20,
              ),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == pendingList.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final snag = pendingList[index];
                // ✅ Use the snag's actual index in allSnags for correct dropdown mapping
                final actualIndex = allSnags.indexOf(snag);

                String percentageValue = "${snag.completePercentage ?? 0}%";
                if (project.selectedPercentages.length > actualIndex &&
                    project.selectedPercentages[actualIndex] != "0%") {
                  percentageValue = project.selectedPercentages[actualIndex];
                }

                SnagStatusDropDown? priorityValue;
                if (project.selectedSnagStatusDropList.length > actualIndex) {
                  priorityValue =
                      project.selectedSnagStatusDropList[actualIndex];
                } else {
                  final list =
                      project.snagDropdownModel?.snagStatusDropDown ?? [];
                  priorityValue = list.firstWhere(
                    (item) =>
                        item.value?.toString() == snag.snagStatusId?.toString(),
                    orElse: () =>
                        list.isNotEmpty ? list.first : SnagStatusDropDown(),
                  );
                }

                return _snagCard(
                  key: ValueKey(snag.id),
                  data: snag.details ?? "",
                  borderColor: _priorityColor(priorityValue?.label),
                  checked: snag.isComplete ?? false,
                  deleteTap: () async {
                    await project.deleteSnag(
                      context: context,
                      pid: widget.projectId ?? "",
                      snagId: snag.id.toString(),
                    );
                    // ✅ Reset and refresh after delete
                    await _resetAndRefresh();
                  },
                  snagId: snag.id.toString(),
                  onChanged: (val) async {
                    if (val != null) {
                      while (project.selectedPercentages.length <=
                          actualIndex) {
                        project.selectedPercentages.add("0%");
                      }
                      project.updatePercentage(value: val, index: actualIndex);
                      await project.updatePercentSnagList(
                        context: context,
                        snagId: snag.id.toString(),
                        completePercentage: val,
                      );
                      // ✅ Reset and refresh after update
                      await _resetAndRefresh();
                    }
                  },
                  dataVal: percentageValue,
                  onChangedDrop: (val) async {
                    if (val != null) {
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
                      project.setSnagStatusDrop(value: val, index: actualIndex);
                      await project.updatePercentSnagStatus(
                        context: context,
                        snagId: snag.id.toString(),
                        completePercentage: "",
                        snagStatus: val.value.toString(),
                      );
                      // ✅ Reset and refresh after status update
                      await _resetAndRefresh();
                    }
                  },
                  datadrop: priorityValue,
                  onCheckboxChanged: (bool? value) async {
                    if (value != null) {
                      await project.updateSnagCompleteStatus(
                        context: context,
                        completeStatus: value,
                        snagId: snag.id.toString(),
                      );
                      // ✅ Reset and refresh after checkbox change
                      await _resetAndRefresh();
                    }
                  },
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

            // 🟢 Completed Tab
            ListView.separated(
              itemCount: completedList.length + (isLoadingMore ? 1 : 0),
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 20,
              ),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == completedList.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final snag = completedList[index];
                final actualIndex = allSnags.indexOf(snag);

                SnagStatusDropDown? priorityValue;
                if (project.selectedSnagStatusDropList.length > actualIndex) {
                  priorityValue =
                      project.selectedSnagStatusDropList[actualIndex];
                } else {
                  final list =
                      project.snagDropdownModel?.snagStatusDropDown ?? [];
                  priorityValue = list.firstWhere(
                    (item) =>
                        item.value?.toString() == snag.snagStatusId?.toString(),
                    orElse: () =>
                        list.isNotEmpty ? list.first : SnagStatusDropDown(),
                  );
                }

                return project.loading1 == true
                    ? const SizedBox()
                    : _snagCard(
                        key: ValueKey(snag.id),
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
                          // ✅ Reset and refresh after delete
                          await _resetAndRefresh();
                        },
                        onCheckboxChanged: (bool? value) async {
                          if (value != null) {
                            await project.updateSnagCompleteStatus(
                              context: context,
                              completeStatus: value,
                              snagId: snag.id.toString(),
                            );
                            // ✅ Reset and refresh after checkbox change
                            await _resetAndRefresh();
                          }
                        },
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
    Key? key,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data,
                    maxLines: isExpanded ? null : 2,
                    overflow: isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: primaryClr,
                      fontFamily: "Manrope",
                    ),
                  ),
                  if (onToggleExpand != null && _shouldShowToggle(data))
                    InkWell(
                      onTap: onToggleExpand,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          isExpanded ? "Show Less" : "Show More",
                          style: const TextStyle(
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
                    child: const Icon(
                      Icons.delete_outline_sharp,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  bool _shouldShowToggle(String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: "Manrope",
        ),
      ),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 80);
    return textPainter.didExceedMaxLines;
  }

  Widget _priorityDropdown({
    required ProjectProvider project,
    required void Function(SnagStatusDropDown?) onChangedDrop,
    required SnagStatusDropDown? val,
  }) {
    final list = project.snagDropdownModel?.snagStatusDropDown ?? [];
    if (list.isEmpty) {
      return Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Center(
          child: Text("No options", style: TextStyle(fontSize: 11)),
        ),
      );
    }

    SnagStatusDropDown? selectedItem;
    if (val?.value != null) {
      try {
        selectedItem = list.firstWhere(
          (item) => item.value?.toString() == val!.value?.toString(),
        );
      } catch (e) {
        selectedItem = null;
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
          value: selectedItem,
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
        padding: const EdgeInsets.only(left: 16, right: 16),
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
