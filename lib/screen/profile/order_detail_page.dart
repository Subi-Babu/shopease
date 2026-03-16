import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/providers/signin/project_provider.dart';

import '../../utils/colors.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key});

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
          "Order Details",
          style: TextStyle(
            color: primaryClr,
            fontFamily: "Manrope",
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Consumer<ProjectProvider>(
          builder: (context, order, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(color: Color(0xffF4F4F4)),

                Text(
                  "Order #${order.orderViewModel?.data?.orderId.toString() ?? ""}",
                  style: TextStyle(
                    color: Color(0xff737373),
                    fontFamily: "Manrope",
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                // const SizedBox(height: 4),
                // const Text(
                //   "25 Oct, 2025",
                //   style: TextStyle(color: Colors.grey),
                // ),
                Divider(color: Color(0xffF4F4F4)),

                // Delivery Details
                Text(
                  "Delivery Details",
                  style: TextStyle(
                    color: Color(0xff737373),
                    fontFamily: "Manrope",
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xffF4F4F4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person, color: Color(0xff737373)),
                          SizedBox(width: 8),
                          Text(
                            order.orderViewModel?.data?.users?.name ?? "",
                            style: TextStyle(
                              color: primaryClr,
                              fontFamily: "Manrope",
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Icon(Icons.location_pin, color: Color(0xff737373)),
                          SizedBox(width: 8),

                          Text(
                            "${order.orderViewModel?.data?.userAddress?.address ?? ""},${order.orderViewModel?.data?.userAddress?.addressTitle ?? ""}",
                            style: TextStyle(
                              color: primaryClr,
                              fontFamily: "Manrope",
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  "Order Summary",
                  style: TextStyle(
                    color: Color(0xff737373),
                    fontFamily: "Manrope",
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                Divider(color: Color(0xffF4F4F4)),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      /// 🔹 Order Items List
                      ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            order.orderViewModel?.data?.orderItems?.length ?? 0,
                        separatorBuilder: (_, __) => const Divider(height: 24),
                        itemBuilder: (context, index) {
                          final item =
                              order.orderViewModel?.data?.orderItems?[index];

                          return Row(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      order
                                          .orderViewModel
                                          ?.data
                                          ?.orderItems?[index]
                                          ?.item
                                          ?.itemImages
                                          ?.first
                                          ?.image ??
                                      "",
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.image_not_supported),
                                ),
                              ),
                              const SizedBox(width: 12),

                              /// Product Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      order
                                              .orderViewModel
                                              ?.data
                                              ?.orderItems?[index]
                                              ?.item
                                              ?.name ??
                                          "",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text("Qty: ${item?.qty ?? 1}"),
                                  ],
                                ),
                              ),

                              /// Price
                              Text(
                                "₹${order.orderViewModel?.data?.orderItems?[index]?.calculatorPrice ?? ""}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      const Divider(height: 24),

                      /// 🔹 Price Details
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xffF4F4F4),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color(0xffDFDFDF)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Item Total (${order.orderViewModel?.data?.orderItems?.length ?? 0}item)",
                                ),
                                Text(
                                  "₹${order.orderViewModel?.data?.grandTotal.toStringAsFixed(2) ?? 0}",
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Tax"),
                                Text(
                                  "₹${order.orderViewModel?.data?.totalGst.toStringAsFixed(2) ?? 0}",
                                  style: const TextStyle(color: Colors.green),
                                ),
                              ],
                            ),

                            const Divider(height: 24),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Grand Total",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "₹${order.orderViewModel?.data?.totalPrice.toStringAsFixed(2) ?? 0}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Payment Method
                // Container(
                //   padding: EdgeInsets.all(8),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(10),
                //     border: Border.all(color: Color(0xffDFDFDF)),
                //   ),
                //   child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       const Text(
                //         "Payment Method",
                //         style: TextStyle(fontWeight: FontWeight.w600),
                //       ),
                //       Text(
                //           order.orderViewModel?.data?.orderItems? ?? "",
                //         style: TextStyle(fontWeight: FontWeight.w600),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            );
          },
        ),
      ),
    );
  }
}
