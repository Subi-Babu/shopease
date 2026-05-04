import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/signin/project_provider.dart';
import '../../utils/colors.dart';

class MyOrdersPage extends StatefulWidget {
  final bool btn;

  const MyOrdersPage({super.key, this.btn = false});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _searchKeyword = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = Provider.of<ProjectProvider>(context, listen: false);
      await reg.fetchOrderList(context: context, keyword: "");
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ✅ Local filter: searches orderId AND name (cCount or other fields)
  List<dynamic> _getFilteredOrders(List<dynamic>? allOrders) {
    if (allOrders == null) return [];
    if (_searchKeyword.isEmpty) return allOrders;

    final keyword = _searchKeyword.toLowerCase().trim();

    return allOrders.where((order) {
      final orderId = order.orderId?.toString().toLowerCase() ?? "";
      // Add any other fields you want to search, e.g. name, product name
      final itemName = order.cCount?.toString().toLowerCase() ?? "";
      // Example: order.customerName?.toLowerCase() ?? ""

      return orderId.contains(keyword) || itemName.contains(keyword);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // leading: SizedBox(),
        leading: (widget.btn ?? false)
            ? const SizedBox()
            : const BackButton(color: Colors.black),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text(
          "My Orders",
          style: TextStyle(
            color: primaryClr,
            fontFamily: "Manrope",
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: (widget.btn ?? true) ? true : false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<ProjectProvider>(
          builder: (context, order, _) {
            // ✅ Apply local filter on top of API data
            final filteredOrders = _getFilteredOrders(
              order.orderListModel?.data,
            );

            return Column(
              children: [
                // 🔍 Search
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xffDFDFDF)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      // ✅ Update local state immediately for instant UI filter
                      setState(() {
                        _searchKeyword = value;
                      });

                      // ✅ Debounce API call
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(
                        const Duration(milliseconds: 500),
                        () async {
                          final reg = Provider.of<ProjectProvider>(
                            context,
                            listen: false,
                          );
                          await reg.fetchOrderList(
                            context: context,
                            keyword: value,
                          );
                        },
                      );
                    },
                    decoration: InputDecoration(
                      hintText: "Search by Order ID",
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Manrope",
                        color: Color(0xffAAAAAA),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 6),
                        child: Image.asset(
                          "assets/search.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minHeight: 20,
                        minWidth: 36,
                      ),
                      // ✅ Clear button
                      suffixIcon: _searchKeyword.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchKeyword = "");
                                // Re-fetch all orders
                                Provider.of<ProjectProvider>(
                                  context,
                                  listen: false,
                                ).fetchOrderList(context: context, keyword: "");
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // All Orders header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "All Orders",
                      style: TextStyle(
                        color: primaryClr,
                        fontFamily: "Manrope",
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                      ),
                    ),
                    // ✅ Show result count
                    if (_searchKeyword.isNotEmpty)
                      Text(
                        "${filteredOrders.length} result${filteredOrders.length != 1 ? 's' : ''}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: "Manrope",
                          fontSize: 13.sp,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: filteredOrders.isEmpty
                      // ✅ Empty state
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 60,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _searchKeyword.isEmpty
                                    ? "No orders found"
                                    : "No results for \"$_searchKeyword\"",
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontFamily: "Manrope",
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: filteredOrders.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = filteredOrders[index];
                            return OrderCard(
                              onTap: () async {
                                HapticFeedback.heavyImpact();
                                await order.fetchOrderView(
                                  context: context,
                                  id: item.id?.toString() ?? "",
                                );
                              },
                              ordertatus: item.orderStatus ?? "",
                              orderId: item.orderId?.toString() ?? "",
                              items: DateFormat(
                                'dd-MM-yyyy',
                              ).format(DateTime.parse(item.createdAt)),
                              total: item.totalPrice ?? "",
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
}

class OrderCard extends StatelessWidget {
  final String orderId;
  final String ordertatus;
  final dynamic items;
  final dynamic total;
  final void Function()? onTap;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.ordertatus,
    required this.items,
    required this.total,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xffF4F4F4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xffD1D5DB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text(
                  "#$orderId",
                  style: TextStyle(
                    color: const Color(0xff737373),
                    fontFamily: "Manrope",
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 4,
                    right: 4,
                    top: 2,
                    bottom: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Text(
                    "$ordertatus",
                    style: TextStyle(
                      color: Colors.green,
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$items",
                  style: TextStyle(
                    color: primaryClr,
                    fontFamily: "Manrope",
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  "Total: ₹$total",
                  style: TextStyle(
                    color: primaryClr,
                    fontFamily: "Manrope",
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
