import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/custom_widgets/custom_button.dart';
import 'package:youbuilt/screen/home.dart';

import '../../providers/signin/project_provider.dart';

class ServiceInvoicePage extends StatefulWidget {
  String? id;
  ServiceInvoicePage({super.key, this.id});

  @override
  State<ServiceInvoicePage> createState() => _ServiceInvoicePageState();

  /// TABLE CELL
  static Widget tableCell(String text) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 2,
        style: const TextStyle(fontSize: 10),
      ),
    );
  }
}

class _ServiceInvoicePageState extends State<ServiceInvoicePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = Provider.of<ProjectProvider>(context, listen: false);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text("Estimation Details"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        child: Consumer<ProjectProvider>(
          builder: (context, vieww, _) {
            return Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// DATE
                  Text(
                    vieww.invoiceModel?.data?.date != null
                        ? DateFormat('dd MMM, yyyy').format(
                            DateTime.parse(
                              vieww.invoiceModel!.data!.date.toString(),
                            ),
                          )
                        : "",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 10),

                  /// TABLE
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        tableHeader(),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              vieww
                                      .invoiceModel
                                      ?.data
                                      ?.adminEstimations
                                      ?.isNotEmpty ==
                                  true
                              ? vieww!
                                        .invoiceModel!
                                        .data!
                                        .adminEstimations!
                                        .first
                                        .adminEstimationItems
                                        ?.length ??
                                    0
                              : 0,
                          separatorBuilder: (context, index) =>
                              Divider(color: Colors.grey.shade300, height: 1),
                          itemBuilder: (context, index) {
                            final item = vieww
                                .invoiceModel
                                ?.data
                                ?.adminEstimations
                                ?.first
                                .adminEstimationItems?[index];

                            return tableRow(
                              (index + 1).toString(),
                              item?.description ?? "-",
                              item?.qty.toString() ?? "0",
                              formatAmount(item?.cost),
                              formatAmount(item?.tax),
                              formatAmount(item?.totalCost),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// SUMMARY
                  summaryRow(
                    "Sub Total:",

                    formatAmount(
                      vieww
                          ?.invoiceModel
                          ?.data
                          ?.adminEstimations
                          ?.first
                          ?.subTotal,
                    ),
                  ),
                  summaryRow(
                    "Discount:",

                    formatAmount(
                      vieww
                          ?.invoiceModel
                          ?.data
                          ?.adminEstimations
                          ?.first
                          ?.discount,
                    ),
                  ),
                  summaryRow(
                    "Total:",

                    formatAmount(
                      vieww
                          ?.invoiceModel
                          ?.data
                          ?.adminEstimations
                          ?.first
                          ?.grandTotal,
                    ),
                    isBold: true,
                  ),

                  const SizedBox(height: 16),

                  /// NOTES
                  const Text(
                    "Notes:",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    removeHtmlTags(
                      vieww
                              ?.invoiceModel
                              ?.data
                              ?.adminEstimations
                              ?.first
                              ?.notes ??
                          "",
                    ),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 12),

                  /// TERMS
                  const Text(
                    "Terms & Conditions:",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    removeHtmlTags(
                      vieww
                              ?.invoiceModel
                              ?.data
                              ?.adminEstimations
                              ?.first
                              ?.terms ??
                          "",
                    ),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          },
        ),
      ),

      /// BOTTOM BUTTONS
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                text: "Reject",
                onPress: () async {
                  await Provider.of<ProjectProvider>(
                    context,
                    listen: false,
                  ).estimationStatuss(
                    context: context,
                    id: widget.id.toString() ?? "",
                    status: "Rejected",
                  );
                },
                textColor: primaryClr,
                bgColor: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomButton(
                text: "Accept",
                onPress: () async {
                  await Provider.of<ProjectProvider>(
                    context,
                    listen: false,
                  ).estimationStatuss(
                    context: context,
                    id: widget.id.toString() ?? "",
                    status: "Confirmed",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// TABLE HEADER
  Widget tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ServiceInvoicePage.tableCell("Sl"),
          ServiceInvoicePage.tableCell("Description"),
          ServiceInvoicePage.tableCell("Qty"),
          ServiceInvoicePage.tableCell("Cost"),
          ServiceInvoicePage.tableCell("Tax"),
          ServiceInvoicePage.tableCell("Total"),
        ],
      ),
    );
  }

  /// TABLE ROW
  Widget tableRow(
    String sl,
    String desc,
    String qty,
    String cost,
    String tax,
    String total,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ServiceInvoicePage.tableCell(sl),
          ServiceInvoicePage.tableCell(desc),
          ServiceInvoicePage.tableCell(qty),
          ServiceInvoicePage.tableCell(cost),
          ServiceInvoicePage.tableCell(tax),
          ServiceInvoicePage.tableCell(total),
        ],
      ),
    );
  }

  /// SUMMARY ROW
  Widget summaryRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(title),
          const SizedBox(width: 40),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

String formatAmount(dynamic amount) {
  try {
    if (amount == null) return "₹0.00";

    final number = double.tryParse(amount.toString()) ?? 0;

    final formatter = NumberFormat.currency(
      locale: 'en_IN', // Indian format
      symbol: '₹',
      decimalDigits: 2, // .00
    );

    return formatter.format(number);
  } catch (e) {
    return "₹0.00";
  }
}

String removeHtmlTags(String? htmlText) {
  if (htmlText == null) return "";

  final exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: false);
  return htmlText.replaceAll(exp, "").trim();
}
