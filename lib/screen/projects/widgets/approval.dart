import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/screen/home.dart';

import '../../../model/approval_model.dart';
import '../../../providers/signin/project_provider.dart';
import '../../profile/service_book_details.dart';

class ApprovalsPage extends StatefulWidget {
  final String? projectId;
  const ApprovalsPage({super.key, this.projectId});

  @override
  State<ApprovalsPage> createState() => _ApprovalsPageState();
}

class _ApprovalsPageState extends State<ApprovalsPage> {
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    final reg = Provider.of<ProjectProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await reg.fetchApprovalList(
        context: context,
        id: widget.projectId ?? "",
        page: "1",
        limit: "10",
      );
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final provider = Provider.of<ProjectProvider>(context, listen: false);

        if (provider.hasMore && !provider.isPaginationLoading) {
          provider.fetchApprovalList(
            context: context,
            id: widget.projectId ?? "",
            page: (provider.currentPage + 1).toString(),
            limit: "10",
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   leading: const Icon(Icons.arrow_back, color: Colors.black),
      //   title: const Text(
      //     "Home Renovation",
      //     style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      //   ),
      //   centerTitle: true,
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              "Approval requests",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              "View and manage all expenses and approvals for your project.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          // const SizedBox(height: 12),
          // _filterChips(),
          // const SizedBox(height: 12),
          Expanded(
            child: Consumer<ProjectProvider>(
              builder: (context, provider, _) {
                return ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount:
                      provider.approvalList.length +
                      (provider.isPaginationLoading ? 1 : 0),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    // loader at bottom
                    if (index == provider.approvalList.length) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final item = provider.approvalList[index];

                    return _approvalCard(item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget _tabBar() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: const [
  //         _TabItem(title: "Overview"),
  //         _TabItem(title: "Snag List"),
  //         _TabItem(title: "Wallet"),
  //         _TabItem(title: "Approvals"),
  //       ],
  //     ),
  //   );
  // }

  Widget _approvalCard(Datum item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.users?.name ?? "",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "#${item.orderId ?? ""}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff737373),
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "",

                style: const TextStyle(
                  fontSize: 14,
                  color: primaryClr,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.w600,
                ),
              ),

              Text(
                "₹${formatter.format(item.grandTotal ?? "")}",

                style: const TextStyle(
                  fontSize: 14,
                  color: primaryClr,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Divider(),

          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.createdAt != null
                    ? DateFormat("dd MMM yyyy").format(item.createdAt!)
                    : "",
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff737373),
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2),
                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.blue),
                ),
                child: Text(
                  item?.paymentStatus ?? "",
                  style: TextStyle(
                    color: Colors.blue,
                    fontFamily: "Manrope",
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isActive;

  const _TabItem({required this.title, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? Colors.black : Colors.grey,
          ),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 2,
            width: 40,
            color: Colors.black,
          ),
      ],
    );
  }
}
