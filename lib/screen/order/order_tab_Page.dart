import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/providers/signin/project_provider.dart';
import 'package:youbuilt/screen/profile/service_booking.dart';

import '../../utils/colors.dart';
import '../bottom_nav.dart';
import '../profile/orders.dart';

class OrderTabPage extends StatefulWidget {
  const OrderTabPage({super.key});

  @override
  State<OrderTabPage> createState() => _OrderTabPageState();
}

class _OrderTabPageState extends State<OrderTabPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _searchKeyword = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = Provider.of<ProjectProvider>(context, listen: false);
      await reg.fetchOrderList(context: context, keyword: "");
      // await reg.fetchServiceBookView(context: context, id: widget.id ?? "");
      await reg.fetchServiceBooking(context: context);
      await reg.fetchRentalBookList(context: context);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  List<dynamic> _getFilteredOrders(List<dynamic>? allOrders) {
    if (allOrders == null) return [];
    if (_searchKeyword.isEmpty) return allOrders;

    final keyword = _searchKeyword.toLowerCase().trim();

    return allOrders.where((order) {
      final orderId = order.orderId?.toString().toLowerCase() ?? "";
      final itemName = order.cCount?.toString().toLowerCase() ?? "";

      return orderId.contains(keyword) || itemName.contains(keyword);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => BottomNavScreen()),
              );
            },
            child: Icon(Icons.arrow_back),
          ),

          elevation: 0,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Text(
            "Orders",
            style: TextStyle(
              color: primaryClr,
              fontFamily: "Manrope",
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
            ),
          ),
          centerTitle: false,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: TabBar(
              unselectedLabelColor: const Color(0xff737373),
              indicatorColor: const Color(0xffFF3B30),
              labelColor: primaryClr,
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
              labelStyle: TextStyle(
                fontFamily: "Manrope",
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
              tabs: const [
                Tab(text: "Products"),
                Tab(text: "Services"),
                Tab(text: "Rentals"),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [productOrders(), serviceOrders(), rentalOrders()],
        ),
      ),
    );
  }

  /// PRODUCT ORDERS TAB
  Widget productOrders() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Consumer<ProjectProvider>(
        builder: (context, order, _) {
          final filteredOrders = _getFilteredOrders(order.orderListModel?.data);

          return Column(
            children: [
              /// SEARCH FIELD
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
                    setState(() {
                      _searchKeyword = value;
                    });

                    if (_debounce?.isActive ?? false) {
                      _debounce!.cancel();
                    }

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
                    suffixIcon: _searchKeyword.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchKeyword = "";
                              });

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

              /// HEADER
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "All Orders",
              //       style: TextStyle(
              //         color: primaryClr,
              //         fontFamily: "Manrope",
              //         fontWeight: FontWeight.w500,
              //         fontSize: 18.sp,
              //       ),
              //     ),
              //     if (_searchKeyword.isNotEmpty)
              //       Text(
              //         "${filteredOrders.length} results",
              //         style: TextStyle(
              //           color: Colors.grey,
              //           fontFamily: "Manrope",
              //           fontSize: 13.sp,
              //         ),
              //       ),
              //   ],
              // ),
              //
              // const SizedBox(height: 12),

              /// ORDER LIST
              Expanded(
                child: filteredOrders.isEmpty
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
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
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
                            ordertatus:
                                item.orderStatus?.replaceAll("_", " ") ?? "",
                            orderId: item.orderId?.toString() ?? "",
                            items: item.cCount?.orderItems ?? "0",
                            total: item.totalPrice ?? "",
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// SERVICE ORDERS TAB
  Widget serviceOrders() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Consumer<ProjectProvider>(
        builder: (context, order, _) {
          return Column(
            children: [
              /// SEARCH
              Container(
                padding: const EdgeInsets.all(12),
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xffDFDFDF)),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search Services",
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Manrope",
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Image.asset(
                        "assets/search.png",
                        height: 20,
                        width: 20,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minHeight: 20,
                      minWidth: 30,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: ListView.separated(
                  itemCount: order.serviceBookingModel?.data?.length ?? 0,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = order.serviceBookingModel?.data?[index];

                    return OrderCard3(
                      ordertatus:
                          order.serviceBookingModel?.data?[index]?.status
                              ?.replaceAll("_", " ")
                              .toString() ??
                          "",
                      onTap: () async {
                        await order.fetchServiceDetails(
                          context: context,
                          id:
                              order.serviceBookingModel?.data?[index]?.id
                                  .toString() ??
                              "",
                        );
                        // await order.fetchOrderView(
                        //   context: context,
                        //   id:
                        //       order.orderListModel?.data?[index].id
                        //           .toString() ??
                        //       "",
                        // );
                      },
                      // imageUrl:
                      //     order?.serviceBookingModel?.data?[index].file ?? "",
                      orderId:
                          order
                              .serviceBookingModel
                              ?.data?[index]
                              ?.serviceBookingId
                              .toString() ??
                          "",
                      // items:
                      //     order.serviceBookingModel?.data?[index]?.name ?? "",
                      total:
                          order.serviceBookingModel?.data?[index]?.grandTotal ??
                          "",
                      items: formatDate(
                        order.serviceBookingModel?.data?[index]?.date
                                .toString() ??
                            "",
                      ),
                      // deliveredDate: orders[index]["date"] as String,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget rentalOrders() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Consumer<ProjectProvider>(
        builder: (context, order, _) {
          return Column(
            children: [
              /// SEARCH
              Container(
                padding: const EdgeInsets.all(12),
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xffDFDFDF)),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search Rentals",
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Manrope",
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Image.asset(
                        "assets/search.png",
                        height: 20,
                        width: 20,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minHeight: 20,
                      minWidth: 30,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: ListView.separated(
                  itemCount: order.rentalBookListModel?.data?.length ?? 0,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = order.rentalBookListModel?.data?[index];

                    return OrderCard3(
                      ordertatus:
                          order.rentalBookListModel?.data?[index]?.status
                              ?.replaceAll("_", " ")
                              .toString() ??
                          "",
                      onTap: () async {
                        await order.fetchServiceDetails(
                          context: context,
                          id:
                              order.rentalBookListModel?.data?[index]?.id
                                  .toString() ??
                              "",
                        );
                        // await order.fetchOrderView(
                        //   context: context,
                        //   id:
                        //       order.orderListModel?.data?[index].id
                        //           .toString() ??
                        //       "",
                        // );
                      },
                      // imageUrl:
                      //     order?.serviceBookingModel?.data?[index].file ?? "",
                      orderId:
                          order
                              .rentalBookListModel
                              ?.data?[index]
                              ?.rentalBookingId
                              .toString() ??
                          "",
                      // items:
                      //     order.serviceBookingModel?.data?[index]?.name ?? "",
                      total:
                          // orderId.rentalBookListModel?.data?[index]?. ??
                          "",
                      items: formatDate(
                        order.rentalBookListModel?.data?[index]?.date
                                .toString() ??
                            "",
                      ),
                      // deliveredDate: orders[index]["date"] as String,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
