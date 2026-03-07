import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/custom_widgets/custom_button.dart';
import 'package:youbuilt/providers/signin/project_provider.dart';

import '../../utils/colors.dart';

class PaymentMethodPage extends StatefulWidget {
  final String? total;
  final String? orderId;
  final String? pid;
  const PaymentMethodPage({
    super.key,
    required this.total,
    required this.orderId,
    required this.pid,
  });

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = context.read<ProjectProvider>();

      await reg.fetchCartList(context: context);
      await reg.fetchAddressList(context: context);
      await reg.fetchAssignProjectList(context: context);
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
        centerTitle: true,
      ),
      // bottomNavigationBar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
        child: Consumer<ProjectProvider>(
          builder: (context, pay, _) {
            return CustomButton(
              text: "Proceed to Pay ${widget.total ?? ""}",
              onPress: () async {
                await pay.placeOrdeer(
                  context: context,
                  pid: widget.pid ?? "",
                  orderId: widget.orderId ?? "",
                  adddressId:
                      pay.addressListModel?.data?.first?.id.toString() ?? "",
                  methodPay: "YBCash",
                );
              },
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<ProjectProvider>(
          builder: (context, pay, _) {
            final address = pay.addressListModel?.data ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "(${pay.cartListModel?.data?.length ?? 0} item) Total: ₹ ${widget.total}",
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
                          Spacer(),
                          Icon(Icons.radio_button_checked),
                        ],
                      ),
                      SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 38,
                        child: CustomButton(
                          text: "Pay using YB Wallet",
                          onPress: () async {},
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                _paymentOption("Razor Pay"),
                const SizedBox(height: 10),
                _paymentOption("Paytm"),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _paymentOption(String title) {
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
          const Icon(Icons.radio_button_off),
        ],
      ),
    );
  }
}
