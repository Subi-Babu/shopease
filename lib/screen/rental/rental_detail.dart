import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/custom_widgets/custom_button.dart';
import 'package:youbuilt/providers/signin/project_provider.dart';

import '../../model/service.dart';
import '../../utils/colors.dart';
import 'package:intl/intl.dart';

final formatter = NumberFormat('#,##0.00');

class RentalDetails extends StatefulWidget {
  final String? id;
  const RentalDetails({super.key, required this.id});

  @override
  State<RentalDetails> createState() => _RentalDetailsState();
}

class _RentalDetailsState extends State<RentalDetails> {
  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = Provider.of<ProjectProvider>(context, listen: false);
      await reg.fetchRentalDetails(context: context, id: widget.id ?? "");
    });
  }

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
          "Rental Details",
          style: TextStyle(
            color: primaryClr,
            fontFamily: "Manrope",
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            bookingInfo(),
            customerDetails(),
            // Padding(
            //   padding: const EdgeInsets.only(top: 10, bottom: 10),
            //   child: serviceDescription(),
            // ),
            // materialsList(),
            // actionButtons(context),
            // priceSummary(),
          ],
        ),
      ),
      bottomNavigationBar: bottomButton(),
    );
  }
}

Widget customerDetails() {
  return ExpansionTile(
    initiallyExpanded: true,
    tilePadding: EdgeInsets.symmetric(horizontal: 12),
    childrenPadding: EdgeInsets.zero,

    // Red divider (collapsed & expanded)
    shape: Border(
      top: BorderSide(color: Color(0xffF4F4F4)),
      bottom: BorderSide(color: Color(0xffF4F4F4)),
    ),
    collapsedShape: Border(
      top: BorderSide(color: Color(0xffF4F4F4), width: 2),
      bottom: BorderSide(color: Color(0xffF4F4F4), width: 2),
    ),

    title: Text(
      "Customer Details",
      style: TextStyle(
        color: Color(0xff737373),
        fontSize: 16,
        fontFamily: "Manrope",
        fontWeight: FontWeight.w600,
      ),
    ),

    children: [
      Consumer<ProjectProvider>(
        builder: (context, user, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name Row
                Row(
                  children: [
                    Icon(Icons.person_outline),
                    SizedBox(width: 8),
                    Text(
                      "${user.rentalDetailsModel?.data?.name ?? ""}",
                      style: TextStyle(
                        color: primaryClr,
                        fontSize: 14,
                        fontFamily: "Manrope",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10), // 👈 GAP BETWEEN TITLE & SUBTITLE
                // Phone Row
                Row(
                  children: [
                    Icon(Icons.local_phone_outlined),
                    SizedBox(width: 8),
                    Text(
                      "${user.rentalDetailsModel?.data?.users?.phoneNumber ?? ""}",
                      style: TextStyle(
                        color: primaryClr,
                        fontSize: 14,
                        fontFamily: "Manrope",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                // 👈 RED DIVIDER
              ],
            ),
          );
        },
      ),
    ],
  );
}

Widget bookingInfo() {
  return Padding(
    padding: EdgeInsets.all(12),
    child: Consumer<ProjectProvider>(
      builder: (context, service, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Booking ID: #${service.rentalDetailsModel?.data?.rentalBookingId ?? ""}",
                  style: TextStyle(
                    color: primaryClr,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "${service.rentalDetailsModel?.data?.status?.replaceAll("_", " ") ?? ""}",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
            Text(
              service.rentalDetailsModel?.data?.date != null
                  ? DateFormat('dd-MM-yyyy').format(
                      DateTime.parse(
                        service.rentalDetailsModel!.data!.date.toString(),
                      ),
                    )
                  : "",

              style: TextStyle(
                color: Color(0xff737373),
                fontSize: 16,
                fontFamily: "Manrope",
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    ),
  );
}

// Widget priceSummary() {
//   return Consumer<ProjectProvider>(
//     builder: (context, service, _) {
//       final grandTotal = service?.rentalDetailsModel?.data?.grandTotal ?? 0;
//       final igst = service?.rentalDetailsModel?.data?.igst ?? 0;
//
//       // Convert to num (important if dynamic/string)
//       final serviceCharge = (grandTotal as num) - (igst as num);
//       return Container(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 12, right: 12),
//               child: Text(
//                 "Service Cost Summary",
//                 style: TextStyle(
//                   color: Color(0xff737373),
//                   fontSize: 16,
//                   fontFamily: "Manrope",
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.all(12),
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Color(0xffF4F4F4),
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Color(0xffD1D5DB)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   rowItem(
//                     "Service Charge",
//                     "₹${formatter.format(serviceCharge)}",
//                   ),
//                   rowItem("Tax", "₹${formatter.format(igst)}"),
//                   Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Divider(height: 5),
//                   ),
//                   rowItem("Grand Total", "₹${formatter.format(grandTotal)}"),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
//
// Widget rowItem(String title, String value) {
//   return Padding(
//     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [Text(title), Text(value)],
//     ),
//   );
// }

// Widget actionButtons(BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.all(16.0),
//     child: Row(
//       children: [
//         Expanded(
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               elevation: 0,
//               backgroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 side: BorderSide(color: primaryClr),
//               ),
//             ),
//
//             onPressed: () {
//               // Navigator.pop(context); // close dialog
//             },
//             child: const Text(
//               "Reject",
//               style: TextStyle(fontFamily: "Manrope", color: primaryClr),
//             ),
//           ),
//         ),
//         SizedBox(width: 10),
//         Expanded(
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               elevation: 0,
//               backgroundColor: Colors.black,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             onPressed: () {
//               // Navigator.pop(context); // close dialog
//             },
//             child: const Text(
//               "Accept",
//               style: TextStyle(fontFamily: "Manrope", color: Colors.white),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget serviceDescription() {
//   return Consumer<ProjectProvider>(
//     builder: (context, service, _) {
//       return ListTile(
//         leading: CachedNetworkImage(
//           imageUrl: service?.rentalDetailsModel?.data?.service?.image ?? "",
//           width: 70,
//           height: 70,
//           fit: BoxFit.cover,
//           placeholder: (context, url) => const CircleAvatar(
//             radius: 15,
//             backgroundColor: Color(0xffE0E0E0),
//           ),
//           errorWidget: (context, url, error) => CircleAvatar(
//             radius: 30,
//             backgroundColor: const Color(0xffC1C1C1),
//             child: Text(
//               service?.rentalDetailsModel?.data?.service?.name?[0] ?? "",
//               style: const TextStyle(color: primaryClr),
//             ),
//           ),
//         ),
//         title: Text(
//           service?.rentalDetailsModel?.data?.service?.name ?? "",
//           style: const TextStyle(color: primaryClr),
//         ),
//         // subtitle: Text("Lorem ipsum is simply dummy text..."),
//       );
//     },
//   );
// }
//
// Widget materialsList() {
//   return Consumer<ProjectProvider>(
//     builder: (context, service, _) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//
//         children: [
//           service?.rentalDetailsModel?.data?.serviceCarts?.length == 0
//               ? SizedBox()
//               : Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Text(
//                     "Required Materials",
//                     style: TextStyle(
//                       color: Color(0xff737373),
//                       fontSize: 16,
//                       fontFamily: "Manrope",
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//           Container(
//             margin: EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Color(0xffD1D5DB)),
//             ),
//             child: Column(
//               children: [
//                 ListView.separated(
//                   shrinkWrap: true,
//
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount:
//                       service?.rentalDetailsModel?.data?.serviceCarts?.length ??
//                       0,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       leading: CachedNetworkImage(
//                         imageUrl:
//                             service
//                                 ?.rentalDetailsModel
//                                 ?.data
//                                 ?.serviceCarts?[index]
//                                 .item
//                                 ?.itemImages
//                                 ?.first
//                                 .image ??
//                             "",
//                         width: 60,
//                         height: 60,
//                         fit: BoxFit.cover,
//                         placeholder: (context, url) => const CircleAvatar(
//                           radius: 15,
//                           backgroundColor: Color(0xffE0E0E0),
//                         ),
//                         errorWidget: (context, url, error) => CircleAvatar(
//                           radius: 30,
//                           backgroundColor: const Color(0xffC1C1C1),
//                           child: Text(
//                             service
//                                     ?.rentalDetailsModel
//                                     ?.data
//                                     ?.serviceCarts?[index]
//                                     .item
//                                     ?.name?[0] ??
//                                 "",
//                             style: const TextStyle(color: primaryClr),
//                           ),
//                         ),
//                       ),
//                       title: Text(
//                         service
//                                 ?.rentalDetailsModel
//                                 ?.data
//                                 ?.serviceCarts?[index]
//                                 .item
//                                 ?.name ??
//                             "",
//                       ),
//                       subtitle: Text(
//                         getAttributesText(
//                           service
//                               ?.rentalDetailsModel
//                               ?.data
//                               ?.serviceCarts?[index],
//                         ),
//                       ),
//
//                       trailing: Text(
//                         "₹${formatter.format(double.tryParse(service?.rentalDetailsModel?.data?.serviceCarts?[index]?.calculatorPrice.toString() ?? "0") ?? 0)}",
//                       ),
//                     );
//                   },
//                   separatorBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.only(left: 12, right: 12),
//                       child: Divider(color: Color(0xffD1D5DB)),
//                     );
//                   },
//                 ),
//                 service?.rentalDetailsModel?.data?.serviceCarts?.length == 0
//                     ? SizedBox()
//                     : Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   elevation: 0,
//                                   backgroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                     side: BorderSide(color: primaryClr),
//                                   ),
//                                 ),
//
//                                 onPressed: () {
//                                   showRejectDialog(context);
//
//                                   // Navigator.pop(context); // close dialog
//                                 },
//                                 child: const Text(
//                                   "Reject",
//                                   style: TextStyle(
//                                     fontFamily: "Manrope",
//                                     color: primaryClr,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 10),
//                             Expanded(
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   elevation: 0,
//                                   backgroundColor: Colors.black,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                                 onPressed: () {
//                                   // showRejectDialog(context);
//                                   // Navigator.pop(context); // close dialog
//                                 },
//                                 child: const Text(
//                                   "Accept",
//                                   style: TextStyle(
//                                     fontFamily: "Manrope",
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//               ],
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }

String getAttributesText(ServiceCart? cart) {
  return (cart?.attributeName?.values
              .map((e) => e.label ?? "")
              .where((e) => e.isNotEmpty)
              .toList() ??
          [])
      .join("|");
}

void showRejectDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Consumer<ProjectProvider>(
        builder: (context, service, _) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text(
              "Are you sure you want to reject product purchase?",
              style: TextStyle(
                fontFamily: "Manrope",
                fontSize: 16,
                color: primaryClr,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: const Text(
              " If you reject the material purchase, you will need to arrange the required materials yourself.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontFamily: "Manrope",
                fontSize: 14,

                fontWeight: FontWeight.w400,
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Color(0xffF4F4F4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                onPressed: () {
                  Navigator.pop(context); // close dialog
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(fontFamily: "Manrope", color: primaryClr),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  await service.serviceStatus(
                    context: context,
                    id: service.rentalDetailsModel?.data?.id.toString() ?? "",
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  "Reject",
                  style: TextStyle(fontFamily: "Manrope", color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget bottomButton() {
  return Consumer<ProjectProvider>(
    builder: (context, service, _) {
      final carts = service.serviceDetailsModel?.data?.serviceCarts;
      final paymentStatus = service.serviceDetailsModel?.data?.paymentStatus;

      // ❌ Hide button if carts null/empty OR paymentStatus null
      if (carts == null || carts.isEmpty || paymentStatus == null) {
        return SizedBox(); // nothing shown
      }

      // ✅ Show button only when valid
      return Padding(
        padding: EdgeInsets.all(12),
        child: CustomButton(
          text: "Accept Proposal",
          onPress: () {
            showAcceptRejectDialog(context);
          },
        ),
      );
    },
  );
}

void showAcceptRejectDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image.asset("assets/suff.jpg", height: 50, width: 50),
            Icon(Icons.warning, color: Colors.red, size: 40),
            const SizedBox(height: 10),
            const Text("Accept or Reject the materials to continue"),
          ],
        ),
        actions: [
          CustomButton(text: "Dismiss", onPress: () => Navigator.pop(context)),
        ],
      );
    },
  );
}
