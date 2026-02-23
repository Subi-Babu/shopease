import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:youbuilt/model/activity_model.dart';
import 'package:youbuilt/model/brandmodel.dart';
import 'package:youbuilt/model/category_list_model.dart';
import 'package:youbuilt/model/countrycode.dart';
import 'package:youbuilt/model/estimaton.dart';
import 'package:youbuilt/model/expense_model.dart';
import 'package:youbuilt/model/item_list_model.dart';
import 'package:youbuilt/model/profile_model.dart';
import 'package:youbuilt/model/project_file_list_model.dart';
import 'package:youbuilt/model/project_list_model.dart';
import 'package:youbuilt/model/project_members.dart';
import 'package:youbuilt/model/project_view_model.dart';
import 'package:youbuilt/model/projectfolder_model.dart';
import 'package:youbuilt/model/quatation.dart';
import 'package:youbuilt/model/sanp_drop_model.dart';
import 'package:youbuilt/model/snaglist_model.dart';
import 'package:youbuilt/model/stage_model.dart';
import 'package:youbuilt/model/subcatgeory_model.dart';
import 'package:youbuilt/model/variation_model.dart';
import 'package:youbuilt/model/wallet_model.dart';
import 'package:youbuilt/screen/bottom_nav.dart';
import 'package:youbuilt/screen/cart/view_cart.dart';
import 'package:youbuilt/screen/otp.dart';
import 'package:youbuilt/utils/constants.dart';

import '../../model/item_details.dart';
import '../../model/project_type_model.dart';
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
            "Please try again.";
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
            "Please try again.";
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

      log("${responseData["status"]}");

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

  TextEditingController nameFileCntrl = TextEditingController();

  Future<void> addFile({
    required BuildContext context,
    required String name,
    required String projectFolderId,
    required File? file, // ✅ change here
    required String projectId,
  }) async {
    expense = true;
    notifyListeners();

    try {
      final responseData = await NetworkHelper().addFile(
        context: context,
        projectId: projectId,
        name: name,
        // catId: catId,
        projectFolderId: projectFolderId,
        file: file, // ✅ pass File
      );

      log("${responseData["status"]}");

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"] ?? "File added successfully");

        Navigator.pop(context);
        fetchProjectListsFile(
          context: context,
          pid: projectId,
          pfid: projectFolderId,
        );
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

  StageCategoryModel? stageCategoryModel;
  Future fetchStageCategory({
    required BuildContext context,
    required String id,
  }) async {
    load = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getStageCategoryList(context, id);

      if (response != null) {
        stageCategoryModel = response; // Store fetched subcategories
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

  ActivityModel? activityModel;
  bool activityLoad = false;
  Future fetchActivity({
    required BuildContext context,
    required String id,
    required String keyword,
  }) async {
    activityLoad = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getActivityList(
        context,
        id,
        keyword,
      );

      if (response != null) {
        activityModel = response; // Store fetched subcategories

        log("Fetched activities successfully.");
      } else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching : $e");
    } finally {
      activityLoad = false;
      notifyListeners();
    }
  }

  ProjectFolderModel? folderModel;
  bool Load = false;
  Future fetchFolderList({
    required BuildContext context,
    required String id,
  }) async {
    Load = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getProjectFolderList(context, id);

      if (response != null) {
        folderModel = response; // Store fetched subcategories

        log("Fetched activities successfully.");
      } else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching : $e");
    } finally {
      Load = false;
      notifyListeners();
    }
  }

  bool? loading2 = false;
  TextEditingController nameCntrl = TextEditingController();
  Future<void> addProjectFolder({
    required BuildContext context,
    String? title,
    String? pid,
  }) async {
    loading2 = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().addFolder(
        context: context,
        title: title ?? "",
        projectId: pid ?? "",
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"]);

        if (!context.mounted) return;

        log("Navigating to LoginSuccessfulScreen...");

        Navigator.pop(context);
        fetchFolderList(context: context, id: pid ?? "");
      } else {
        String errorMessage =
            responseData["message"] ??
            responseData["error"] ??
            "Please try again.";
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
      loading2 = false;
      notifyListeners();
    }
  }

  ProfileModel? profileModel;

  Future fetchProfile({required BuildContext context}) async {
    Loading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getProfile(context);

      if (response != null) {
        profileModel = response; // Store fetched subcategories

        log("Fetched activities successfully.");
      } else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching : $e");
    } finally {
      Loading = false;
      notifyListeners();
    }
  }

  EstimationModel? estimationModel;

  Future fetchEstimation({required BuildContext context}) async {
    Loading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getEstimation(context);

      if (response != null) {
        estimationModel = response; // Store fetched subcategories

        log("Fetched estimation successfully.");
      } else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching : $e");
    } finally {
      Loading = false;
      notifyListeners();
    }
  }

  QuatationModel? quatationModel;
  bool qLoading = false;
  Future fetchQuatation({required BuildContext context}) async {
    qLoading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getQuatation(context);

      if (response != null) {
        quatationModel = response; // Store fetched subcategories

        log("Fetched quotes successfully.");
      } else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching : $e");
    } finally {
      qLoading = false;
      notifyListeners();
    }
  }

  ProjectTypeModel? projectTypeModel;

  Future fetchProjectType({required BuildContext context}) async {
    qLoading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getproTypeDrop(context);

      if (response != null) {
        projectTypeModel = response; // Store fetched subcategories

        log("Fetched  successfully.");
      } else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching : $e");
    } finally {
      qLoading = false;
      notifyListeners();
    }
  }

  ProjectTypeDropDown? selectedProjectType;
  String? projectTypeName;

  void setProjectType(ProjectTypeDropDown value) {
    selectedProjectType = value;
    projectTypeName = selectedProjectType?.label;
    print("================${selectedProjectType?.value}");
    notifyListeners();
  }

  String? qprojectTypeName;
  ProjectTypeDropDown? selectedqProjectType;

  void setQuoteProjectType(ProjectTypeDropDown value) {
    selectedqProjectType = value;
    qprojectTypeName = selectedqProjectType?.label;
    print("================${selectedqProjectType?.value}");
    notifyListeners();
  }

  ProjectFileListModel? projectFileListModel;
  bool Loading = false;
  Future fetchProjectListsFile({
    required BuildContext context,
    required String pid,
    required String pfid,
  }) async {
    Loading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getProjectFileLists(
        context,
        pid,
        pfid,
      );

      if (response != null) {
        projectFileListModel = response; // Store fetched subcategories

        log("Fetched activities successfully.");
      } else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching : $e");
    } finally {
      Loading = false;
      notifyListeners();
    }
  }

  String? selectedFolderId;

  void setSelectedFolder(String? id) {
    selectedFolderId = id;
    print("$selectedFolderId");
    notifyListeners();
  }

  File? fileFile;
  Future<void> pickFileSection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      fileFile = File(result.files.single.path!);
      notifyListeners();
    }
  }

  String selectedFolderName = "General";
  String selectedFolderIdForList = "general";

  void setSelectedFolderForList({required String name, required String id}) {
    selectedFolderName = name;
    selectedFolderIdForList = id;
    notifyListeners();
  }

  TextEditingController nameClientCntrl = TextEditingController();
  TextEditingController emailCntrl = TextEditingController();
  TextEditingController phoneClientCntrl = TextEditingController();
  TextEditingController pincodeCntrl = TextEditingController();
  TextEditingController addressCntrl = TextEditingController();
  TextEditingController budgetAmountCntrl = TextEditingController();
  TextEditingController buildareaCntrl = TextEditingController();
  TextEditingController descriptionCntrl = TextEditingController();
  Future<void> addEstimationReq({
    required BuildContext context,
    required String amount,
    required String email,
    required String phoneNo,
    required String pinCode,
    required String address,
    required String buildarea,
    required String clientName,
    required File? file,
    required String projectTypeNAme,
    required String description,
    required String date,
  }) async {
    expense = true;
    notifyListeners();

    try {
      final responseData = await NetworkHelper().addEstimation(
        context: context,
        amount: amount ?? "",
        clientName: clientName ?? "",
        date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        description: description ?? "",
        address: address ?? "",
        email: email ?? "",
        buildarea: buildarea ?? "",
        file: file,
        phoneNo: phoneNo ?? "",
        pinCode: pinCode ?? "",
        projectTypeNAme: projectTypeNAme ?? "",
        // ✅ pass File
      );

      log("${responseData["status"]}");

      if (responseData["status"] == true) {
        ToastUtil.show(
          responseData["message"] ?? "Estimation added successfully",
        );
        fetchEstimation(context: context);
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

  File? estimationFile;
  Future<void> pickEstimationFileSection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      estimationFile = File(result.files.single.path!);
      notifyListeners();
    }
  }

  TextEditingController qnameClientCntrl = TextEditingController();
  TextEditingController qemailCntrl = TextEditingController();
  TextEditingController qphoneClientCntrl = TextEditingController();
  TextEditingController qplotCntrl = TextEditingController();
  TextEditingController qpincodeCntrl = TextEditingController();
  TextEditingController qaddressCntrl = TextEditingController();
  TextEditingController qbudgetAmountCntrl = TextEditingController();
  TextEditingController qbuildareaCntrl = TextEditingController();
  TextEditingController qdescriptionCntrl = TextEditingController();
  bool quotes = false;
  Future<void> addQuatationReq({
    required BuildContext context,
    required String amount,
    required String email,
    required String phoneNo,
    required String pinCode,
    required String address,
    required String buildarea,
    required String clientName,
    required File? file,
    required String projectTypeNAme,
    required String description,
    required String date,
    required String ploatArea,
    required List<Map<String, dynamic>> categoryType,
  }) async {
    quotes = true;
    notifyListeners();

    try {
      final responseData = await NetworkHelper().addQuatation(
        context: context,
        amount: amount ?? "",
        clientName: clientName ?? "",
        date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        description: description ?? "",
        address: address ?? "",
        email: email ?? "",
        buildarea: buildarea ?? "",
        file: file,
        phoneNo: phoneNo ?? "",
        pinCode: pinCode ?? "",
        projectTypeNAme: projectTypeNAme ?? "",
        plotArea: ploatArea,
        categoryType: categoryType,
        // ✅ pass File
      );

      log("${responseData["status"]}");

      if (responseData["status"] == true) {
        ToastUtil.show(
          responseData["message"] ?? "Quatation added successfully",
        );
        fetchEstimation(context: context);
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
      quotes = false;
      notifyListeners();
    }
  }

  ItemListModel? itemListModel;
  bool itemLoading = false;
  Future fetchItemLists({
    required BuildContext context,
    String? catid,
    String? endPrice,
  }) async {
    itemLoading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getItemLists(
        context,
        catid,
        endPrice,
      );

      if (response != null) {
        itemListModel = response; // Store fetched subcategories

        log("Fetched items successfully.");
      } else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching : $e");
    } finally {
      itemLoading = false;
      notifyListeners();
    }
  }

  Future fetchItemLists2({
    required BuildContext context,
    String? catid,
    String? endPrice,
    String? startPrice,
    String? brandiid,
  }) async {
    itemLoading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getItemLists2(
        context,
        catid,
        endPrice,
        startPrice,
        brandiid,
      );

      if (response != null) {
        itemListModel = response; // Store fetched subcategories

        log("Fetched items successfully.");
      } else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching : $e");
    } finally {
      itemLoading = false;
      notifyListeners();
    }
  }

  CategroyListModel? categroyListModel;

  Future fetchCategoryLists({required BuildContext context}) async {
    itemLoading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getCategoryyLists(context);

      if (response != null) {
        categroyListModel = response; // Store fetched subcategories

        log("Fetched items successfully.");
      } else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching : $e");
    } finally {
      itemLoading = false;
      notifyListeners();
    }
  }

  String selectedCategoryId = "";
  // ✅ Store selected subcategory IDs & names
  List<String> selectedSubIds = [];
  List<String> selectedSubNames = [];
  void setSelectedCategory(String id) {
    selectedCategoryId = id;
    notifyListeners();
  }

  SubCategoryModel? subCategoryModel;
  bool itemLoadingSub = false;
  Future fetchSubCategoryLists({
    required BuildContext context,
    required String? catId,
  }) async {
    itemLoadingSub = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getSubCategoryyLists(
        context,
        catId,
      );

      if (response != null) {
        subCategoryModel = response; // Store fetched subcategories

        log("Fetched items successfully.");
      } else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching : $e");
    } finally {
      itemLoadingSub = false;
      notifyListeners();
    }
  }

  VariationModelModel? variationModel;
  // bool itemLoadingSub = false;
  Future fetchVariationLists({
    required BuildContext context,
    required String? catId,
    required Map<String, dynamic> attributeMap,
  }) async {
    itemLoadingSub = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getItemVaraition(
        context,
        catId,
        attributeMap,
      );

      if (response != null) {
        variationModel = response; // Store fetched subcategories

        log("Fetched items successfully.");
      } else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching : $e");
    } finally {
      itemLoadingSub = false;
      notifyListeners();
    }
  }

  ItemListDetailsModel? itemListDetailsModel;
  bool itemLoading2 = false;
  Future fetchItemListDetails({
    required BuildContext context,
    String? id,
  }) async {
    itemLoading2 = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getItemListDetails(context, id);

      if (response != null) {
        itemListDetailsModel = response; // Store fetched subcategories
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductViewPage()),
        );
        log("Fetched items successfully.");
      } else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching : $e");
    } finally {
      itemLoading2 = false;
      notifyListeners();
    }
  }

  BrandModel? brandModel;
  bool brand = false;
  Future fetchBrand({
    required BuildContext context,
    // String? id,
  }) async {
    brand = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getBrandList(context);

      if (response != null) {
        brandModel = response; // Store fetched subcategories

        log("Fetched items successfully.");
      } else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching : $e");
    } finally {
      brand = false;
      notifyListeners();
    }
  }
  TextEditingController titleAddressController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pincodeAddressController = TextEditingController();
  TextEditingController nameddressController = TextEditingController();
  TextEditingController phoneddressController = TextEditingController();
  Future<void> addAddress({
    required BuildContext context,
    required String? title,
    required String? address,
    required String? pincode,
    required String? lat,
    required String? lng,
    required String? name,
    required String? location,
    required String? phone,
  }) async {
    memberLoads = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().addAddress(
        context: context,
        title: title ?? "",
       address: address??"",
        phone: phone??"",
        name: name??"",
        lng: lng??"",

          lat: lat??"",
        pincode: pincode??"",
        location:location
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"]);
        // fetchSnagList(id: pid ?? "", context: context);

        if (!context.mounted) return;

        log("Navigating...");

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

}
