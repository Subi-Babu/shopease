import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:youbuilt/model/countrycode.dart';
import 'package:youbuilt/model/expense_model.dart';
import 'package:youbuilt/model/project_list_model.dart';
import 'package:youbuilt/model/project_members.dart';
import 'package:youbuilt/model/project_view_model.dart';
import 'package:youbuilt/model/sanp_drop_model.dart';
import 'package:youbuilt/model/snaglist_model.dart';
import 'package:youbuilt/model/wallet_model.dart';
import 'package:youbuilt/screen/bottom_nav.dart';
import 'package:youbuilt/screen/otp.dart';
import 'package:youbuilt/utils/constants.dart';

import '../../services/api.dart';
import '../../utils/sharedpref_util.dart';
import '../../utils/toast_util.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProjectProvider extends ChangeNotifier {
  DateTime? _dueDate;

  DateTime? get dueDate => _dueDate;

  String get formattedDueDate {
    if (_dueDate == null) return "";
    return DateFormat('MM-dd-yyyy').format(_dueDate!);
  }

  Future<void> pickDueDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      _dueDate = pickedDate;
      print("-------------${dueDate}");
      notifyListeners();
    }
  }

  TextEditingController titleCntrl = TextEditingController();
  TextEditingController budgetCntrl = TextEditingController();
  TextEditingController desCntrl = TextEditingController();
  bool? loading = false;
  Future<void> addProject({
    required BuildContext context,
    String? title,
    String? budget,
    String? datee,
    String? description,
  }) async {
    loading = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().addProject(
        context: context,
        title: title ?? "",
        budget: budget ?? "",
        description: description ?? "",
        duedate: datee ?? "",
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"]);

        if (!context.mounted) return;

        log("Navigating to LoginSuccessfulScreen...");

        Navigator.pop(context);
        fetchProjectList(context: context, status: "");
      } else {
        String errorMessage =
            responseData["message"] ??
            responseData["error"] ??
            "SignIn failed. Please try again.";
        log("SignIn failed: $errorMessage");

        if (!context.mounted) return;
        ToastUtil.show("An error occurred. Please try again.");
      }
    } catch (e, stack) {
      log("❌ exception: $e\n$stack");
      log("Error: $e");
      // ToastUtil.show("An error occurred. Please try again.");
      ToastUtil.show("An error occurred. Please try again.");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  bool? memberLoads = false;
  TextEditingController phController = TextEditingController();
  Future<void> inviteMembers({
    required BuildContext context,
    String? phone,
    String? id,
  }) async {
    memberLoads = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().inviteMembers(
        context: context,
        phoneNumber: phone ?? "",
        id: id ?? "",
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"]);

        if (!context.mounted) return;

        log("Navigating to LoginSuccessfulScreen...");

        Navigator.pop(context);
        // fetchProjectMember(context: context, id: );
      } else {
        String errorMessage =
            responseData["message"] ??
            responseData["error"] ??
            "SignIn failed. Please try again.";
        log("SignIn failed: $errorMessage");

        if (!context.mounted) return;
        ToastUtil.show("An error occurred. Please try again.");
      }
    } catch (e, stack) {
      log("❌ exception: $e\n$stack");
      log("Error: $e");
      // ToastUtil.show("An error occurred. Please try again.");
      ToastUtil.show("An error occurred. Please try again.");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  ProjectListModel? projectListModel;
  bool? load = false;
  Future fetchProjectList({
    required BuildContext context,
    required String status,
  }) async {
    load = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getProjectList(context, status);

      if (response != null) {
        projectListModel = response; // Store fetched subcategories
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ViewBookTaskDetails(
        //       taskId: idd.toString(),
        //     ),
        //   ),
        // );
        log("Fetched details successfully.");
      } else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching : $e");
    } finally {
      load = false;
      notifyListeners();
    }
  }

  ProjectListViewModel? projectListViewModel;
  Future fetchProjectListView({
    required BuildContext context,
    required String id,
  }) async {
    load = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getProjectView(context, id);

      if (response != null) {
        projectListViewModel = response; // Store fetched subcategories
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ViewBookTaskDetails(
        //       taskId: idd.toString(),
        //     ),
        //   ),
        // );
        log("Fetched details successfully.");
      } else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching : $e");
    } finally {
      load = false;
      notifyListeners();
    }
  }

  ProjectMembersModel? projectMembersModel;
  Future fetchProjectMember({
    required BuildContext context,
    required String id,
  }) async {
    loading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getProjectMember(context, id);

      if (response != null) {
        projectMembersModel = response; // Store fetched subcategories
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ViewBookTaskDetails(
        //       taskId: idd.toString(),
        //     ),
        //   ),
        // );
        log("Fetched details successfully.");
      } else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching : $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void clearForm() {
    titleCntrl.clear();
    budgetCntrl.clear();
    desCntrl.clear();
    _dueDate = null;
    // selectedDate = null; // if used
    notifyListeners();
  }

  SnagDropdownModel? snagDropdownModel;
  SnagStatusDropDown? selectedSnagStatus; // 👈 selected item

  Future fetchSnagDropdown({required BuildContext context}) async {
    loading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getSnagDropdown(context);

      if (response != null) {
        snagDropdownModel = response;

        // ✅ default selection
        if (snagDropdownModel!.snagStatusDropDown!.isNotEmpty) {
          selectedSnagStatus = snagDropdownModel!.snagStatusDropDown!.first;
        }
        notifyListeners();
        // Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Error fetching : $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  //
  int? selectedSnagId;
  void setSnagStatus(SnagStatusDropDown value) {
    selectedSnagStatus = value;

    selectedSnagId = value.value;
    print("object---$selectedSnagStatus");
    print("object---$selectedSnagId");
    notifyListeners();
  }

  int? selectedSnagIddrop;
  SnagStatusDropDown? selectedSnagStatusDrop; // 👈 selected item

  // void setSnagStatusDrop(SnagStatusDropDown value) {
  //   selectedSnagStatusDrop = value;
  //
  //   selectedSnagIddrop = value.value;
  //   print("object---$selectedSnagStatusDrop");
  //   print("object---$selectedSnagIddrop");
  //   notifyListeners();
  // }

  TextEditingController titleController = TextEditingController();
  Future<void> addSnagList({
    required BuildContext context,
    String? title,
    String? id,
    String? pid,
  }) async {
    memberLoads = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().addSnag(
        context: context,
        title: title ?? "",
        snagId: id ?? "",
        projectId: pid ?? "",
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"]);
        fetchSnagList(id: pid ?? "", context: context);

        if (!context.mounted) return;

        log("Navigating to LoginSuccessfulScreen...");

        Navigator.pop(context);
        // fetchProjectMember(context: context, id: );
      } else {
        String errorMessage =
            responseData["message"] ??
            responseData["error"] ??
            "Please try again.";
        log("Sign$errorMessage");

        if (!context.mounted) return;
        ToastUtil.show("An error occurred. Please try again.");
      }
    } catch (e, stack) {
      log("❌ exception: $e\n$stack");
      log("Error: $e");
      // ToastUtil.show("An error occurred. Please try again.");
      ToastUtil.show("An error occurred. Please try again.");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> updatePercentSnagList({
    required BuildContext context,
    String? completePercentage,
    String? snagId,
  }) async {
    memberLoads = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().snagPercent(
        context: context,
        completeValue: completePercentage ?? "",
        snagId: snagId ?? "",
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"]);

        if (!context.mounted) return;

        // log("Navigating to LoginSuccessfulScreen...");
        //
        // Navigator.pop(context);
        // fetchProjectMember(context: context, id: );
      } else {
        String errorMessage =
            responseData["message"] ??
            responseData["error"] ??
            "Please try again.";
        log("Sign$errorMessage");

        if (!context.mounted) return;
        ToastUtil.show("An error occurred. Please try again.");
      }
    } catch (e, stack) {
      log("❌ exception: $e\n$stack");
      log("Error: $e");
      // ToastUtil.show("An error occurred. Please try again.");
      ToastUtil.show("An error occurred. Please try again.");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> updatePercentSnagStatus({
    required BuildContext context,
    String? completePercentage,
    String? snagId,
    String? snagStatus,
  }) async {
    memberLoads = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().snagStatus(
        context: context,
        // completeValue: completePercentage ?? "",
        snagId: snagId ?? "",
        snagstatus: snagStatus ?? "",
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"]);

        if (!context.mounted) return;

        // log("Navigating to LoginSuccessfulScreen...");
        //
        // Navigator.pop(context);
        // fetchProjectMember(context: context, id: );
      } else {
        String errorMessage =
            responseData["message"] ??
            responseData["error"] ??
            "Please try again.";
        log("Sign$errorMessage");

        if (!context.mounted) return;
        ToastUtil.show("An error occurred. Please try again.");
      }
    } catch (e, stack) {
      log("❌ exception: $e\n$stack");
      log("Error: $e");
      // ToastUtil.show("An error occurred. Please try again.");
      ToastUtil.show("An error occurred. Please try again.");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> updateSnagCompleteStatus({
    required BuildContext context,
    bool? completeStatus,
    String? snagId,
  }) async {
    memberLoads = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().snagComplete(
        context: context,
        // completeValue: completePercentage ?? "",
        snagId: snagId ?? "",
        completeValue: completeStatus ?? false,
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"]);

        if (!context.mounted) return;

        // log("Navigating to LoginSuccessfulScreen...");
        //
        // Navigator.pop(context);
        // fetchProjectMember(context: context, id: );
      } else {
        String errorMessage =
            responseData["message"] ??
            responseData["error"] ??
            "Please try again.";
        log("Sign$errorMessage");

        if (!context.mounted) return;
        ToastUtil.show("An error occurred. Please try again.");
      }
    } catch (e, stack) {
      log("❌ exception: $e\n$stack");
      log("Error: $e");
      // ToastUtil.show("An error occurred. Please try again.");
      ToastUtil.show("An error occurred. Please try again.");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> deleteSnag({
    required BuildContext context,
    required String pid,

    String? snagId,
  }) async {
    memberLoads = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().snagDelete(
        context: context,
        snagId: snagId ?? "",
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"]);
        fetchSnagList(context: context, id: pid ?? "");
      } else {
        String errorMessage =
            responseData["message"] ??
            responseData["error"] ??
            "Please try again.";
        log("Sign$errorMessage");

        if (!context.mounted) return;
        ToastUtil.show("An error occurred. Please try again.");
      }
    } catch (e, stack) {
      log("❌ exception: $e\n$stack");
      log("Error: $e");
      // ToastUtil.show("An error occurred. Please try again.");
      ToastUtil.show("An error occurred. Please try again.");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  SnagListModel? snagListModel;
  bool loading1 = false;
  Future fetchSnagList({
    required BuildContext context,
    required String id,
  }) async {
    loading1 = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getSnagList(context, id);

      if (response != null) {
        snagListModel = response; // Store fetched subcategories
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ViewBookTaskDetails(
        //       taskId: idd.toString(),
        //     ),
        //   ),
        // );
        final pendingCount =
            snagListModel?.projectSnagList
                ?.where((e) => e.isComplete == false)
                .length ??
            0;

        selectedPercentages = List.generate(pendingCount, (index) => "0%");
        notifyListeners();

        log("Fetched details successfully.");
      } else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching : $e");
    } finally {
      loading1 = false;
      notifyListeners();
    }
  }

  List<String> selectedPercentages = [];

  void initPercentages(int length) {
    if (selectedPercentages.length != length) {
      selectedPercentages = List.generate(length, (_) => "0%");
    }
  }

  void updatePercentage({required int index, required String value}) {
    selectedPercentages[index] = value;
    notifyListeners();
  }

  List<SnagStatusDropDown> selectedSnagStatusDropList = [];
  List<int> selectedSnagIdDropList = [];

  // Method to update priority at specific index
  void setSnagStatusDrop({
    required SnagStatusDropDown value,
    required int index,
  }) {
    // Ensure the list is large enough
    while (selectedSnagStatusDropList.length <= index) {
      selectedSnagStatusDropList.add(
        snagDropdownModel?.snagStatusDropDown?.first ?? SnagStatusDropDown(),
      );
    }
    while (selectedSnagIdDropList.length <= index) {
      selectedSnagIdDropList.add(0);
    }

    // Update the specific index
    selectedSnagStatusDropList[index] = value;
    selectedSnagIdDropList[index] = value.value ?? 0;

    print("Priority updated at index $index:");
    print("  Label: ${value.label}");
    print("  Value: ${value.value}");
    print(
      "  Full list: ${selectedSnagStatusDropList.map((e) => e.label).toList()}",
    );

    notifyListeners();
  }

  bool expense = false;
  TextEditingController amountCtrl = TextEditingController();
  TextEditingController detailsCtrl = TextEditingController();

  Future<void> addExpenses({
    required BuildContext context,
    required String amount,
    required String amountDetails,
    required String catId,
    required File? file, // ✅ change here
    required String projectId,
  }) async {
    expense = true;
    notifyListeners();

    try {
      final responseData = await NetworkHelper().addExpenses(
        context: context,
        projectId: projectId,
        amount: amount,
        catId: catId,
        amountDetails: amountDetails,
        file: file, // ✅ pass File
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        ToastUtil.show(
          responseData["message"] ?? "Expenses added successfully",
        );

        if (!context.mounted) return;
        Navigator.pop(context);
      } else {
        final errorMessage =
            responseData["message"] ??
            responseData["error"] ??
            "Please try again.";

        log("❌ API error: $errorMessage");

        if (!context.mounted) return;
        ToastUtil.show(errorMessage);
      }
    } catch (e, stack) {
      log("❌ Exception: $e\n$stack");
      ToastUtil.show("An error occurred. Please try again.");
    } finally {
      expense = false;
      notifyListeners();
    }
  }

  TextEditingController amountFundCtrl = TextEditingController();
  TextEditingController detailsFundCtrl = TextEditingController();

  Future<void> addFund({
    required BuildContext context,
    required String fund,
    required String fundDetails,
    required File? file, // ✅ change here
    required String projectId,
  }) async {
    expense = true;
    notifyListeners();

    try {
      final responseData = await NetworkHelper().addFund(
        context: context,
        projectId: projectId,
        amount: fund,
        // catId: catId,
        details: fundDetails,
        file: file, // ✅ pass File
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        ToastUtil.show(
          responseData["message"] ?? "Expenses added successfully",
        );

        if (!context.mounted) return;
        Navigator.pop(context);
      } else {
        final errorMessage =
            responseData["message"] ??
            responseData["error"] ??
            "Please try again.";

        log("❌ API error: $errorMessage");

        if (!context.mounted) return;
        ToastUtil.show(errorMessage);
      }
    } catch (e, stack) {
      log("❌ Exception: $e\n$stack");
      ToastUtil.show("An error occurred. Please try again.");
    } finally {
      expense = false;
      notifyListeners();
    }
  }

  File? expenseFile;
  Future<void> pickExpenseFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      expenseFile = File(result.files.single.path!);
      notifyListeners();
    }
  }

  File? fundFile;
  Future<void> pickFundFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      fundFile = File(result.files.single.path!);
      notifyListeners();
    }
  }

  ExpensesDropModel? expensesDropModel;

  Future<void> fetchExpenseDropdown({required BuildContext context}) async {
    loading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getExpenseDropdown(context);
      if (response != null && response.expenseCategoryDropDown != null) {
        setExpenseCategories(response.expenseCategoryDropDown!);
      }
    } catch (e) {
      debugPrint("Error fetching expense dropdown: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  ExpenseCategoryDropDown? selectedExpenseCategory;
  List<ExpenseCategoryDropDown> expenseCategories = [];

  void setExpenseCategory(ExpenseCategoryDropDown category) {
    selectedExpenseCategory = category;
    selectedExpenseCategoryId = category.value; // 👈 store ID

    debugPrint("Selected category: ${category.label}");
    debugPrint("Selected category ID: $selectedExpenseCategoryId");

    notifyListeners();
  }

  void setExpenseCategories(List<ExpenseCategoryDropDown> categories) {
    expenseCategories = categories;
    notifyListeners();
  }

  void clearExpenseCategory() {
    // selectedExpenseCategory = null;
    selectedExpenseCategoryId = null;
    selectedExpenseCategory = null;
    expenseFile = null;
    fundFile = null;
    amountCtrl.clear();
    detailsCtrl.clear();
    amountFundCtrl.clear();
    detailsFundCtrl.clear();
    // notifyListeners();
    notifyListeners();
  }

  int? selectedExpenseCategoryId;

  WalletModel? walletModel;
  Future fetchWallet({
    required BuildContext context,
    required String id,
  }) async {
    load = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getWalletList(context, id);

      if (response != null) {
        walletModel = response; // Store fetched subcategories
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ViewBookTaskDetails(
        //       taskId: idd.toString(),
        //     ),
        //   ),
        // );
        log("Fetched details successfully.");
      } else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching : $e");
    } finally {
      load = false;
      notifyListeners();
    }
  }
}
