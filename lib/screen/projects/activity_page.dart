import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/providers/signin/project_provider.dart';
import 'package:youbuilt/utils/colors.dart';

class ActivityPage extends StatefulWidget {
  final String? projectId;
  const ActivityPage({super.key, required this.projectId});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  String selectedValues = "Today";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchActivity();
    });
  }

  void _fetchActivity() {
    Provider.of<ProjectProvider>(context, listen: false).fetchActivity(
      context: context,
      id: widget.projectId ?? "",
      keyword: selectedValues,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Activities",
          style: TextStyle(
            color: primaryClr,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            fontFamily: "Manrope",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Activity",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: primaryClr,
                      fontFamily: "Manrope",
                    ),
                  ),
                  Container(
                    height: 42.h,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffC1C1C1)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedValues,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        onChanged: (value) {
                          if (value == null) return;

                          setState(() {
                            selectedValues = value;
                          });

                          _fetchActivity(); // 🔥 API call
                        },
                        items: const [
                          DropdownMenuItem(
                            value: "Today",
                            child: Text(
                              "Today",
                              style: TextStyle(color: Color(0xff00AF11)),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "This_week",
                            child: Text(
                              "This Week",
                              style: TextStyle(color: Color(0xff487FFF)),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "This_month",
                            child: Text(
                              "This Month",
                              style: TextStyle(color: Color(0xffFF766A)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// LIST
              Expanded(
                child: Consumer<ProjectProvider>(
                  builder: (context, project, _) {
                    final activities =
                        project.activityModel?.projectActivity ?? [];

                    if (activities.isEmpty) {
                      return const Center(
                        child: Text(
                          "No activities found",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: activities.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final activity = activities[index];

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl: activity?.users?.profileImage ?? '',
                              height: 30,
                              width: 30,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const CircleAvatar(
                                radius: 15,
                                backgroundColor: Color(0xffE0E0E0),
                              ),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundColor: const Color(0xffC1C1C1),
                                    child: Text(
                                      activity?.users?.name
                                              ?.substring(0, 1)
                                              .toUpperCase() ??
                                          "",
                                      style: const TextStyle(color: primaryClr),
                                    ),
                                  ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        activity?.users?.name ?? "",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: primaryClr,
                                          fontFamily: "Manrope",
                                        ),
                                      ),
                                      Text(
                                        activity?.createdAt != null
                                            ? DateFormat(
                                                'd MMM yyyy, hh:mm a',
                                              ).format(activity!.createdAt!)
                                            : "",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontFamily: "Manrope",
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xffA3A3A3),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    activity?.description ?? "",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Manrope",
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff737373),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
