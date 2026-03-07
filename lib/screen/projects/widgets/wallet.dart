import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/custom_widgets/custom_button.dart';
import 'package:youbuilt/model/expense_model.dart';
import 'package:youbuilt/providers/signin/project_provider.dart';
import 'package:youbuilt/screen/sign_up.dart';
import 'package:youbuilt/utils/colors.dart';
import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';

import '../../../model/sanp_drop_model.dart';
import '../../../utils/toast_util.dart';

class WalletPage extends StatefulWidget {
  final String? projectId;

  const WalletPage({super.key, required this.projectId});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = Provider.of<ProjectProvider>(context, listen: false);
      await reg.fetchExpenseDropdown(context: context);
      await reg.fetchWallet(context: context, id: widget.projectId ?? "");
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF4F4F4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _walletBalanceCard(),
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _budgetRow(),
                  const SizedBox(height: 16),
                  _budgetUtilization(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _lastTransactions(),
            const SizedBox(height: 16),
            // _weeklyOverview(),
            // const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: _bottomButtons(
        context,
        projectId: widget.projectId ?? "",
      ),
    );
  }
}

Widget _budgetRow() {
  return Consumer<ProjectProvider>(
    builder: (context, project, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _amountCard(
            "Budget",
            "₹ ${project.walletModel?.budget.toString() ?? ""}",
            Colors.blue,
          ),

          _verticalDivider(),

          _amountCard(
            "Expenses",
            "₹ ${project.walletModel?.expenses.toString() ?? ""}",
            Colors.red,
          ),

          _verticalDivider(),

          _amountCard(
            "Balance",
            "₹ ${project.walletModel?.walletBalance.toString() ?? ""}",
            Colors.green,
          ),
        ],
      );
    },
  );
}

class _verticalDivider extends StatelessWidget {
  const _verticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 32, width: 1, color: Colors.grey.shade300);
  }
}

class _amountCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;

  const _amountCard(this.title, this.amount, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            fontFamily: "Manrope",
            color: primaryClr,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            fontFamily: "Manrope",
            color: color,
          ),
        ),
      ],
    );
  }
}

Widget _transactionItem(
  BuildContext context,
  String name,
  String date,
  String amount,
  Color color,
  String tag, {
  VoidCallback? onEdit,
  VoidCallback? onDelete,
}) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(
      name,
      style: const TextStyle(
        fontSize: 14,
        fontFamily: "Manrope",
        color: primaryClr,
        fontWeight: FontWeight.w600,
      ),
    ),
    subtitle: Text(
      date,
      style: const TextStyle(
        fontSize: 12,
        fontFamily: "Manrope",
        color: Color(0xff737373),
        fontWeight: FontWeight.w500,
      ),
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              amount,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Text(
              tag,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: "Manrope",
                color: Color(0xff737373),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        PopupMenuButton<String>(
          color: Colors.white,
          icon: const Icon(Icons.more_vert, color: Color(0xff737373), size: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onSelected: (value) {
            if (value == 'edit') {
              onEdit?.call();
            } else if (value == 'delete') {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text(
                    "Delete ?",
                    style: TextStyle(
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  content: const Text(
                    "Are you sure you want to delete this transaction?",
                    style: TextStyle(
                      fontFamily: "Manrope",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff737373),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontFamily: "Manrope",
                          color: Color(0xff737373),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        onDelete?.call();
                      },
                      child: const Text(
                        "Delete",
                        style: TextStyle(
                          fontFamily: "Manrope",
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: const [
                  Icon(Icons.edit_outlined, size: 18, color: primaryClr),
                  SizedBox(width: 8),
                  Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: const [
                  Icon(Icons.delete_outline, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Manrope",
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _budgetUtilization() {
  return Consumer<ProjectProvider>(
    builder: (context, project, _) {
      // Calculate remaining budget percentage
      double budget = project.walletModel?.budget?.toDouble() ?? 0;
      double expenses = project.walletModel?.expenses?.toDouble() ?? 0;
      double remaining = budget - expenses;
      double remainingPercent = budget > 0 ? (remaining / budget) * 100 : 0;
      double remainingValue = budget > 0 ? (remaining / budget) : 0;

      return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Budget Utilization",
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: "Manrope",
                    fontWeight: FontWeight.w500,
                    color: Color(0xff737373),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${remainingPercent.toStringAsFixed(1)}%",
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.w500,
                      color: Color(0xff737373),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: remainingValue.clamp(0.0, 1.0),
              backgroundColor: Colors.grey.shade300,
              color: remainingPercent < 10 ? Colors.red : Colors.green,
            ),
            const SizedBox(height: 4),
          ],
        ),
      );
    },
  );
}

Widget _bottomButtons(BuildContext context, {required String projectId}) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Expanded(
          child: CustomButton(
            text: "Add Fund",
            icon1: const Icon(Icons.add, color: Colors.white),
            onPress: () {
              final project = Provider.of<ProjectProvider>(
                context,
                listen: false,
              );
              project.clearExpenseCategory();
              project.formattedFundDate == ""; //
              _showAddFundDialog(context, projectId: projectId ?? "");
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomButton(
            text: "Add Expense",
            icon1: const Icon(Icons.add, color: primaryClr),
            borderSide: const BorderSide(color: Color(0xff737373)),
            bgColor: Colors.white,
            textColor: primaryClr,
            onPress: () {
              final project = Provider.of<ProjectProvider>(
                context,
                listen: false,
              );

              project.clearExpenseCategory(); //
              project.formattedExpenseDate == ""; //

              _showAddExpenseDialog(context, projectId: projectId ?? "");
            },
          ),
        ),
      ],
    ),
  );
}

Widget _walletBalanceCard() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Consumer<ProjectProvider>(
      builder: (context, project, _) {
        return Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "YB MONEY",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            SizedBox(width: 10),

            Image.asset("assets/ion_wallet-outline.png", height: 20, width: 20),
            Spacer(),
            Text(
              "₹ ${project.walletModel?.ybCash.toString() ?? ""} ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    ),
  );
}

Widget _lastTransactions() {
  return Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Last Transactions",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: "Manrope",
                color: primaryClr,
              ),
            ),
            Text(
              "View all",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xffFF3B30),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Use Consumer to get transaction data from provider
        Consumer<ProjectProvider>(
          builder: (context, project, _) {
            final transactions = project.walletModel?.data ?? [];

            if (transactions.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "No transactions yet",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              );
            }

            return project.load == true
                ? CircularProgressIndicator(color: primaryClr)
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    padding: EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      // Format the date
                      String formattedDate = "";
                      if (transaction.createdAt != null) {
                        formattedDate = DateFormat('dd MMM, yyyy').format(
                          DateTime.parse(transaction.createdAt.toString()),
                        );
                      }

                      return _transactionItem(
                        context,
                        transaction.projectName ?? "",
                        formattedDate ?? "",
                        "${transaction.type == "expensemoney" ? "-" : "+"} ₹${transaction.amount ?? ""}",
                        transaction.type == "expensemoney"
                            ? Colors.red
                            : Colors.green,
                        transaction.type ?? "",
                        onDelete: () async {
                          await project.deleteExpense(
                            context: context,
                            eid: transaction.id.toString(),
                          );

                          await Future.delayed(
                            const Duration(milliseconds: 500),
                          );

                          await project.fetchWallet(
                            context: context,
                            id: transaction.projectId.toString(),
                          );
                        },
                        onEdit: () {},
                        //
                      );
                    },
                  );
          },
        ),
      ],
    ),
  );
}

Widget _weeklyOverview() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Weekly Spend Overview",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Manrope",
                  ),
                ),
                // Container(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 8,
                //     vertical: 4,
                //   ),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(6),
                //     border: Border.all(color: Colors.grey.shade300),
                //   ),
                //   child: Row(
                //     children: const [
                //       Text("7 days", style: TextStyle(fontSize: 11)),
                //       SizedBox(width: 4),
                //       Icon(Icons.keyboard_arrow_down, size: 14),
                //     ],
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 12),

            // Container(
            //   height: 180,
            //   padding: const EdgeInsets.all(12),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(10),
            //     border: Border.all(color: Colors.grey.shade300),
            //   ),
            //   child: LineChart(_lineChartData()),
            // ),
          ],
        ),
      ),
    ],
  );
}

LineChartData _lineChartData() {
  return LineChartData(
    gridData: FlGridData(show: false),
    borderData: FlBorderData(show: false),

    titlesData: FlTitlesData(
      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: (value, meta) {
            const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                days[value.toInt()],
                style: const TextStyle(fontSize: 10),
              ),
            );
          },
        ),
      ),
    ),

    minX: 0,
    maxX: 6,
    minY: 0,
    maxY: 100,

    lineBarsData: [
      LineChartBarData(
        spots: const [
          FlSpot(0, 30),
          FlSpot(1, 80),
          FlSpot(2, 50),
          FlSpot(3, 70),
          FlSpot(4, 40),
          FlSpot(5, 60),
          FlSpot(6, 45),
        ],
        isCurved: true,
        color: Colors.redAccent,
        barWidth: 2.5,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [Colors.redAccent.withOpacity(0.3), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    ],
  );
}

void _showAddFundDialog(BuildContext context, {required String projectId}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Add Fund",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: "Manrope",
                        fontSize: 18,
                        color: primaryClr,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Content
                Consumer<ProjectProvider>(
                  builder: (context, project, _) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextField(
                          hintText: "Amount",
                          keyboardType: TextInputType.number,
                          fillColor: Colors.white,
                          controller: project.amountFundCtrl,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          hintText: "Details",
                          fillColor: Colors.white,
                          controller: project.detailsFundCtrl,
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            context.read<ProjectProvider>().pickFundDate(
                              context,
                            );
                          },
                          child: AbsorbPointer(
                            child: CustomTextField(
                              hintText: "Date",
                              fillColor: Colors.white,
                              controller: TextEditingController(
                                text: project.formattedFundDate,
                              ),
                              suffixIcon: const Icon(
                                Icons.calendar_month_outlined,
                                color: Color(0xff737373),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        uploadFileBox(
                          title: project.fundFile == null
                              ? "Upload file"
                              : project.fundFile!.path.split('/').last,
                          onTap: () {
                            project.pickFundFile();
                          },
                        ),
                        const SizedBox(height: 16),

                        // Button
                        CustomButton(
                          text: project.expense ? "Please wait..." : "Confirm",
                          onPress: project.expense
                              ? null
                              : () {
                                  // if (project.selectedExpenseCategory == null) {
                                  //   ToastUtil.show("Select expense category");
                                  //   return;
                                  // }
                                  project.addFund(
                                    context: context,
                                    date: project.formattedFundDate,
                                    projectId: projectId,
                                    fund: project.amountFundCtrl.text.trim(),
                                    fundDetails: project.detailsFundCtrl.text
                                        .trim(),

                                    file: project.fundFile,
                                  );
                                  project.fetchWallet(
                                    context: context,
                                    id: projectId,
                                  );
                                },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void _showAddExpenseDialog(BuildContext context, {required String projectId}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Add Expense",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: "Manrope",
                        fontSize: 18,
                        color: primaryClr,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Content
                Consumer<ProjectProvider>(
                  builder: (context, project, _) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextField(
                          hintText: "Amount",
                          keyboardType: TextInputType.number,
                          fillColor: Colors.white,
                          controller: project.amountCtrl,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          hintText: "Expense Details",
                          fillColor: Colors.white,
                          controller: project.detailsCtrl,
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            context.read<ProjectProvider>().pickExpanseDate(
                              context,
                            );
                          },
                          child: AbsorbPointer(
                            child: CustomTextField(
                              hintText: "Date",
                              fillColor: Colors.white,
                              controller: TextEditingController(
                                text: project.formattedExpenseDate,
                              ),
                              suffixIcon: const Icon(
                                Icons.calendar_month_outlined,
                                color: Color(0xff737373),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Dropdown
                        Container(
                          height: 48,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<ExpenseCategoryDropDown>(
                              value: project.selectedExpenseCategory,
                              hint: const Text(
                                "Select Category",
                                style: TextStyle(
                                  color: Color(0xFFCACACA),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                size: 20,
                              ),
                              isExpanded: true,
                              items: project.expenseCategories.map((e) {
                                return DropdownMenuItem<
                                  ExpenseCategoryDropDown
                                >(
                                  value: e,
                                  child: Text(
                                    e.label ?? "",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  project.setExpenseCategory(value);
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        uploadFileBox(
                          title: project.expenseFile == null
                              ? "Upload file"
                              : project.expenseFile!.path.split('/').last,
                          onTap: () {
                            project.pickExpenseFile();
                          },
                        ),
                        const SizedBox(height: 16),

                        // Button
                        CustomButton(
                          text: project.expense ? "Please wait..." : "Confirm",
                          onPress: project.expense
                              ? null
                              : () {
                                  if (project.selectedExpenseCategory == null) {
                                    ToastUtil.show("Select expense category");
                                    return;
                                  }
                                  project.addExpenses(
                                    context: context,
                                    projectId: projectId,
                                    date: project.formattedExpenseDate,
                                    amount: project.amountCtrl.text.trim(),
                                    amountDetails: project.detailsCtrl.text
                                        .trim(),
                                    catId: project
                                        .selectedExpenseCategory!
                                        .value
                                        .toString(),
                                    file: project.expenseFile,
                                  );
                                },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget uploadFileBox({
  required VoidCallback onTap,
  String title = "Upload file",
  // String subTitle = "PDF, JPG, PNG (Max 10MB)",
}) {
  return DottedBorder(
    options: RectDottedBorderOptions(
      color: Color(0xffC1C1C1),
      strokeWidth: 1.2,
      dashPattern: const [6, 4],

      // radius: const Radius.circular(12),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        color: Color(0xffF4F4F4),
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/uploadd.png", height: 18, width: 18),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffA3A3A3),
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 4),
            // Text(
            //   subTitle,
            //   style: const TextStyle(fontSize: 11, color: Colors.grey),
            // ),
          ],
        ),
      ),
    ),
  );
}
