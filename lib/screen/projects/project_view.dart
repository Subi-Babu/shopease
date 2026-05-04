import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/providers/signin/project_provider.dart';
import 'package:youbuilt/screen/projects/widgets/approval.dart';
import 'package:youbuilt/screen/projects/widgets/filess.dart';
import 'package:youbuilt/screen/projects/widgets/overview.dart';
import 'package:youbuilt/screen/projects/widgets/snaglist.dart';
import 'package:youbuilt/screen/projects/widgets/wallet.dart';
import 'package:youbuilt/utils/colors.dart';
import 'package:youbuilt/utils/constants.dart';

class ProjectView extends StatefulWidget {
  final String? projectId;
  final String? projectIdKey;
  final String? projectName;
  const ProjectView({
    super.key,
    required this.projectId,
    required this.projectName,
    this.projectIdKey,
  });

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = Provider.of<ProjectProvider>(context, listen: false);
      reg.fetchProjectListView(context: context, id: widget.projectId ?? "");
      reg.fetchSingleProject(context: context, id: widget.projectId ?? "");
      reg.fetchProjectMember(context: context, id: widget.projectId ?? "");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // number of tabs
      child: Scaffold(
        backgroundColor: Color(0xffF4F4F4),
        // padding: EdgeInsets.all(16.w),,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          elevation: 0,
          title: Consumer<ProjectProvider>(
            builder: (context, project, _) {
              return Text(
                "${widget.projectName} (${project.projectWithIdModel?.data?.projectId ?? ""})",
                style: TextStyle(
                  color: primaryClr,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
                ),
              );
            },
          ),

          centerTitle: false,
          bottom: TabBar(
            unselectedLabelColor: Color(0xff737373),
            indicatorColor: Color(0xffFF3B30),
            labelColor: primaryClr,
            overlayColor: WidgetStatePropertyAll(Colors.transparent),
            tabAlignment: TabAlignment.start,
            indicatorSize: TabBarIndicatorSize.tab,
            isScrollable: true,
            labelStyle: TextStyle(
              fontFamily: "Manrope",
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
            tabs: [
              Tab(text: "Overview"),
              Tab(text: "Snag List"),
              Tab(text: "Wallet"),
              Tab(text: "Approvals"),
              Tab(text: "Files"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OverviewTab(projectId: widget.projectId),
            Snaglist(projectId: widget.projectId),
            WalletPage(projectId: widget.projectId),
            ApprovalsPage(projectId: widget.projectId),
            ProjectFilesPage(pid: widget.projectId),
          ],
        ),
      ),
    );
  }
}
