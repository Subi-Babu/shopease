import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/screen/profile/service_book_details.dart';

import '../../providers/signin/project_provider.dart';
import '../../utils/colors.dart';

class MyServicePage extends StatelessWidget {
  const MyServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text(
          "Service Booking",
          style: TextStyle(
            color: primaryClr,
            fontFamily: "Manrope",
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<ProjectProvider>(
          builder: (context, order, _) {
            return Column(
              children: [
                // 🔍 Search
                Container(
                  padding: EdgeInsets.all(12),
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xffDFDFDF)),
                  ),
                  child: TextField(
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      hintText: "Search Services",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                      hintStyle: TextStyle(
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
                      prefixIconConstraints: BoxConstraints(
                        minHeight: 20,
                        minWidth: 30,
                      ),
                    ),
                  ),
                ),
                // const SizedBox(height: 20),
                //
                // // All Orders
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: Text(
                //     "All Orders",
                //     style: TextStyle(
                //       color: primaryClr,
                //       fontFamily: "Manrope",
                //       fontWeight: FontWeight.w500,
                //       fontSize: 18.sp,
                //     ),
                //   ),
                // ),
                const SizedBox(height: 12),

                Expanded(
                  child: ListView.separated(
                    itemCount: order.serviceBookingModel?.data?.length ?? 0,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
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
                            order
                                .serviceBookingModel
                                ?.data?[index]
                                ?.grandTotal ??
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
      ),
    );
  }
}

class OrderCard3 extends StatelessWidget {
  final String orderId;
  final String ordertatus;
  final dynamic items;
  final dynamic total;
  final void Function()? onTap;

  const OrderCard3({
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
                (total == null || total.toString().isEmpty)
                    ? const SizedBox()
                    : Text(
                        "Total: ₹${formatter.format(int.tryParse(total.toString()) ?? 0)}",
                        style: TextStyle(
                          color: primaryClr,
                          fontFamily: "Manrope",
                          fontWeight: FontWeight.w600,
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

String formatDate(String? date) {
  if (date == null || date.isEmpty) return "";

  try {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat("dd MMM yyyy").format(parsedDate);
  } catch (e) {
    return date; // fallback if parsing fails
  }
}
