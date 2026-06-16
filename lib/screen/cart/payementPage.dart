import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
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
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = context.read<ProjectProvider>();

      reg.razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, reg.handlePaymentSuccess);
      reg.razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, reg.handlePaymentError);
      reg.razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, reg.handleExternalWallet);

      await reg.fetchCartList(context: context);
      await reg.fetchAddressList(context: context);
      await reg.fetchAssignProjectList(context: context);
    });
  }

  @override
  void dispose() {
    final reg = context.read<ProjectProvider>();

    // reg.razorpay.clear();
    super.dispose();
  }
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     final reg = context.read<ProjectProvider>();
  //
  //     await reg.fetchCartList(context: context);
  //     await reg.fetchAddressList(context: context);
  //     await reg.fetchAssignProjectList(context: context);
  //   });
  //   super.initState();
  // }

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
            return CustomButton(
              text: "Proceed to Pay ${widget.total ?? ""}",
              onPress: () async {
                final pay = context.read<ProjectProvider>();

                final addressId =
                    pay.addressListModel?.data?.first?.id.toString() ?? "";

                final pidValue =
                    (widget.pid == null ||
                        widget.pid == "null" ||
                        widget.pid!.isEmpty)
                    ? ""
                    : widget.pid!;
                final double parsedAmount =
                    double.tryParse(widget.total ?? "0") ?? 0;
                final int cleanAmount = parsedAmount.toInt(); // removes .0

                // If sending to API as string

                /// ✅ RAZORPAY FLOW
                if (selectedPayment == "RazorPay") {
                  await pay.payementRazopay(
                    context: context,
                    oId: widget.orderId ?? "",
                    itemType: "productOrder",
                    amount: cleanAmount.toString(),
                  );

                  return; // ❗ stop here (DO NOT call placeOrder)
                }

                /// ✅ WALLET CHECK
                if (selectedPayment == "YBCash") {
                  final balance = pay.selectedProjectBalance;

                  if (balance == null || balance <= 0) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        content: const Text("Insufficient Wallet Amount"),
                      ),
                    );
                    return;
                  }
                }

                /// ✅ COD / WALLET → DIRECT ORDER
                await pay.placeOrdeer(
                  context: context,
                  pid: pidValue,
                  orderId: widget.orderId ?? "",
                  adddressId: addressId,
                  methodPay: selectedPayment,
                );
              },
              // onPress: () async {
              //   final pidValue =
              //       (widget.pid == null ||
              //           widget.pid == "null" ||
              //           widget.pid!.isEmpty)
              //       ? null
              //       : widget.pid;
              //   log("----1----${widget.pid}");
              //
              //   // ✅ If pid is NULL → place order directly
              //   if (pidValue == null) {
              //     log("----3----${widget.pid}");
              //     final addressId =
              //         pay.addressListModel?.data?.first?.id.toString() ?? "";
              //     log("----5---- addressId: $addressId");
              //     await pay.placeOrdeer(
              //       context: context,
              //       pid: "",
              //       orderId: widget.orderId ?? "",
              //       adddressId: addressId,
              //       methodPay: selectedPayment,
              //     );
              //     return;
              //   }
              //
              //   // ✅ pid exists — check if balance has loaded yet
              //   final balance =
              //       pay.selectedProjectBalance; // Keep as nullable double?
              //
              //   // ✅ Only check wallet balance if YB Wallet is selected
              //   if (selectedPayment == "YBCash") {
              //     final balance = pay.selectedProjectBalance;
              //
              //     if (balance == null) {
              //       return;
              //     }
              //
              //     if (balance <= 0.0) {
              //       showDialog(
              //         context: context,
              //         builder: (context) {
              //           return AlertDialog(
              //             content: Column(
              //               crossAxisAlignment: CrossAxisAlignment.center,
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 Image.asset(
              //                   "assets/suff.jpg",
              //                   height: 50,
              //                   width: 50,
              //                 ),
              //                 const SizedBox(height: 10),
              //                 const Text("Insufficient Wallet Amount"),
              //               ],
              //             ),
              //             actions: [
              //               CustomButton(
              //                 text: "Close",
              //                 onPress: () => Navigator.pop(context),
              //               ),
              //             ],
              //           );
              //         },
              //       );
              //       return;
              //     }
              //   }
              //   log("----6----${balance}");
              //   log("----7----${widget.pid}");
              //   if (selectedPayment == "RazorPay") {
              //     bool success = await pay.payementRazopay(
              //       context: context,
              //       oId: widget.orderId ?? "",
              //       itemType: "productOrder",
              //       amount: widget.total ?? "",
              //     );
              //
              //     if (success) {
              //       openRazorpay(); // ✅ only opens on success
              //     }
              //
              //     return;
              //   } // ✅ pid exists + balance sufficient → place order
              //   // await pay.placeOrdeer(
              //   //   context: context,
              //   //   pid: widget.pid ?? "",
              //   //   orderId: widget.orderId ?? "",
              //   //   adddressId:
              //   //       pay.addressListModel?.data?.first?.id.toString() ?? "",
              //   //   methodPay: selectedPayment,
              //   // );
              // },
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
                _paymentOption("Pay Later", "cod", "assets/wallet.png"),

                const SizedBox(height: 10),
                _paymentOption("Razor Pay", "RazorPay", "assets/images.jpeg"),
                const SizedBox(height: 10),
                _paymentOption("Paytm", "paytm", "assets/download.png"),
              ],
            );
          },
        ),
      ),
    );
  }

  String selectedPayment = "YBCash"; // default selected
  Widget _paymentOption(String title, String value, String imagePath) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(imagePath, width: 24, height: 24),
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

  // void _handlePaymentSuccess(PaymentSuccessResponse response) async {
  //   print("SUCCESS: ${response.paymentId}");
  //
  //   // Call your backend to verify payment
  //   // await context.read<ProjectProvider>().verifyPayment(
  //   //   paymentId: response.paymentId!,
  //   //   orderId: response.orderId!,
  //   // );
  // }
  //
  // void _handlePaymentError(PaymentFailureResponse response) {
  //   print("ERROR: ${response.message}");
  // }
  //
  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   print("WALLET: ${response.walletName}");
  // }
  //
  // void openRazorpay() {
  //   var options = {
  //     'key': 'YOUR_RAZORPAY_KEY',
  //     'amount': (double.parse(widget.total ?? "0") * 100).toInt(), // in paise
  //     'name': 'Youbuilt',
  //     'description': 'Order Payment',
  //     'prefill': {'contact': '', 'email': 'customer@example.com'},
  //   };
  //
  //   try {
  //     _razorpay.open(options);
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  // }
}
