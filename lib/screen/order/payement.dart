import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/custom_widgets/custom_button.dart';
import 'package:youbuilt/providers/signin/project_provider.dart';

import '../../utils/colors.dart';
import '../profile/service_book_details.dart';

class PaymentMethodPage2 extends StatefulWidget {
  // final String? total;
  // final String? orderId;
  final String? pid;
  const PaymentMethodPage2({
    super.key,
    // key required this.total,
    //  required this.orderId,
    required this.pid,
  });

  @override
  State<PaymentMethodPage2> createState() => _PaymentMethodPage2State();
}

class _PaymentMethodPage2State extends State<PaymentMethodPage2> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = context.read<ProjectProvider>();

      await reg.fetchAddressList(context: context);
      await reg.fetchAssignProjectList(context: context);
      await reg.fetchPriceList(context: context, id: widget.pid ?? "");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF4F4F4),
      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text(
          "Payment Method",
          style: TextStyle(
            color: primaryClr,
            fontFamily: "Manrope",
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: false,
      ),
      // bottomNavigationBar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
        child: Consumer<ProjectProvider>(
          builder: (context, pay, _) {
            return CustomButton(text: "Place Order", onPress: () {});
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<ProjectProvider>(
            builder: (context, pay, _) {
              final address = pay.addressListModel?.data ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Deliver To",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Manrope",
                      color: primaryClr,
                    ),
                  ),
                  Text(
                    "${address?.first?.address ?? ""},${address?.first?.addressTitle ?? ""}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Manrope",
                      color: primaryClr,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Recommended Payment",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Manrope",
                      color: primaryClr,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/ion_wallet-outline.png",
                              height: 20,
                              width: 20,
                              color: primaryClr,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "YB Wallet",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Manrope",
                                color: primaryClr,
                              ),
                            ),
                            SizedBox(width: 50),
                            Text(
                              "Balance : ${pay.selectedProjectBalance ?? 0.0}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Manrope",
                                color: primaryClr,
                              ),
                            ),
                            Spacer(),
                            Radio<String>(
                              value: "YBCash",
                              groupValue: selectedPayment,
                              activeColor: primaryClr,
                              onChanged: (value) {
                                setState(() {
                                  selectedPayment = value!;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          height: 38,
                          child: CustomButton(
                            text: "Pay using YB Wallet",

                            // onPress: () async {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _paymentOption("Pay Later", "cod"),

                  const SizedBox(height: 10),
                  _paymentOption("Razor Pay", "RazorPay"),
                  const SizedBox(height: 10),
                  _paymentOption("Paytm", "Paytm"),
                  SizedBox(height: 20),
                  priceSummary2(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget priceSummary2() {
    return Consumer<ProjectProvider>(
      builder: (context, service, _) {
        final price = service?.priceModel?.data?.grandTotal ?? "";
        final pricetax = service?.priceModel?.data?.totalGst ?? "";

        final serviceCharge = price - pricetax;

        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  "Bill Details",
                  style: TextStyle(
                    color: Color(0xff737373),
                    fontSize: 16,
                    fontFamily: "Manrope",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 4),
              Container(
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xffD1D5DB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    rowItem(
                      "Service Charge",
                      "₹${formatter.format(serviceCharge)}",
                    ),
                    rowItem("Tax", "₹${formatter.format(pricetax)}"),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Divider(height: 5),
                    ),
                    rowItem("Grand Total", "₹${formatter.format(price)}"),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String selectedPayment = "YBCash"; // default selected
  Widget _paymentOption(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.payment),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: "Manrope",
              color: primaryClr,
            ),
          ),
          const Spacer(),
          Radio<String>(
            value: value,
            groupValue: selectedPayment,
            activeColor: primaryClr,
            onChanged: (val) {
              setState(() {
                selectedPayment = val!;
              });
            },
          ),
        ],
      ),
    );
  }
}
