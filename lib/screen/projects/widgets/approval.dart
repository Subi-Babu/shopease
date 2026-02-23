import 'package:flutter/material.dart';

class ApprovalsPage extends StatefulWidget {
  const ApprovalsPage({super.key});

  @override
  State<ApprovalsPage> createState() => _ApprovalsPageState();
}

class _ApprovalsPageState extends State<ApprovalsPage> {
  int selectedFilter = 0;

  final filters = ["Pending", "Approved", "Rejected"];

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
          const SizedBox(height: 12),
          _filterChips(),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _approvalCard();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _TabItem(title: "Overview"),
          _TabItem(title: "Snag List"),
          _TabItem(title: "Wallet"),
          _TabItem(title: "Approvals", isActive: true),
        ],
      ),
    );
  }

  Widget _filterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(filters.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filters[index]),
              selected: selectedFilter == index,
              onSelected: (_) {
                setState(() => selectedFilter = index);
              },
              selectedColor: Colors.black,
              labelStyle: TextStyle(
                color: selectedFilter == index ? Colors.white : Colors.black,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _approvalCard() {
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
            children: const [
              Text(
                "Steve Harrington",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text("₹5,000", style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Materials",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 4),
          const Text(
            "25 Oct, 2025",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _actionButton(
                title: "Reject",
                color: Colors.redAccent,
                onTap: () {},
              ),
              const SizedBox(width: 8),
              _actionButton(
                title: "Approve",
                color: Colors.green,
                onTap: () {},
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
