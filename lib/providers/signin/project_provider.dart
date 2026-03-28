import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_filex/open_filex.dart';
import 'package:youbuilt/model/activity_model.dart';
import 'package:youbuilt/model/addressListModel.dart' hide Datum;
import 'package:youbuilt/model/approval_model.dart';
import 'package:youbuilt/model/assign_project_model.dart';
import 'package:youbuilt/model/brandmodel.dart';
import 'package:youbuilt/model/category_dropdown.dart';
import 'package:youbuilt/model/category_list_model.dart';
import 'package:youbuilt/model/countrycode.dart';
import 'package:youbuilt/model/estimaton.dart' hide Datum;
import 'package:youbuilt/model/expense_model.dart';
import 'package:youbuilt/model/invoice_view_model.dart';
import 'package:youbuilt/model/item_list_model.dart';
import 'package:youbuilt/model/oder_details.dart';
import 'package:youbuilt/model/orderlist_model.dart';
import 'package:youbuilt/model/profile_model.dart';
import 'package:youbuilt/model/project_file_list_model.dart';
import 'package:youbuilt/model/project_list_model.dart';
import 'package:youbuilt/model/project_members.dart';
import 'package:youbuilt/model/project_single_model.dart';
import 'package:youbuilt/model/project_view_model.dart';
import 'package:youbuilt/model/projectfolder_model.dart';
import 'package:youbuilt/model/quatation.dart' hide Datum;
import 'package:youbuilt/model/rental.dart' hide Datum;
import 'package:youbuilt/model/rental_cat_model.dart' as rent;
import 'package:youbuilt/model/rental_view_model.dart';
import 'package:youbuilt/model/sanp_drop_model.dart';
import 'package:youbuilt/model/search_model.dart';
import 'package:youbuilt/model/seller_model.dart.dart' as seller;
import 'package:youbuilt/model/serviceCatmodel.dart';
import 'package:youbuilt/model/service_booking_model.dart' hide Datum;
import 'package:youbuilt/model/service_detail_model.dart';
import 'package:youbuilt/model/service_id_model.dart';
import 'package:youbuilt/model/servicemodel.dart';
import 'package:youbuilt/model/serviceviewmodel.dart';
import 'package:youbuilt/model/snaglist_model.dart';
import 'package:youbuilt/model/stage_model.dart' hide Datum;
import 'package:youbuilt/model/subcatgeory_model.dart';
import 'package:youbuilt/model/variation_model.dart';
import 'package:youbuilt/model/wallet_model.dart' as wallet;
import 'package:youbuilt/screen/bottom_nav.dart';
import 'package:youbuilt/screen/cart/cart_success.dart';
import 'package:youbuilt/screen/cart/payementPage.dart';
import 'package:youbuilt/screen/cart/view_cart.dart';
import 'package:youbuilt/screen/otp.dart';
import 'package:youbuilt/screen/profile/order_detail_page.dart';
import 'package:youbuilt/screen/rental/rental_view.dart';
import 'package:youbuilt/screen/service/service_view.dart';
import 'package:youbuilt/utils/constants.dart';
import '../../model/cart_list_model.dart' as cart;
import '../../model/invoice_view_quatation_model.dart';
import '../../model/item_details.dart';
import '../../model/project_type_model.dart';
// import '../../screen/cart/payementPage.dart';
import '../../model/service.dart';
import '../../screen/estimation/invoice_page.dart';
import '../../screen/estimation/invoice_page_quotation.dart';
import '../../screen/profile/service_book_details.dart';
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

  bool addToCartLoading = false;

  // void setAddToCartLoading(bool value) {
  //   addToCartLoading = value;
  //   notifyListeners();
  // }
  bool? memberLoads = false;
  TextEditingController phController = TextEditingController();
  Future<void> inviteMembers({
    required BuildContext context,
    String? phone,
    String? id,
  }) async {
    addToCartLoading = true;
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
      addToCartLoading = false;
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

        if (!context.mounted) return;

        log("Navigating to LoginSuccessfulScreen...");
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
        fetchSnagList(context: context, id: pid ?? "", pge: "1", limit: "10");
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

  Future<void> deleteCart({
    required BuildContext context,
    required String cartid,
  }) async {
    memberLoads = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().cartDelete(
        context: context,
        cartId: cartid ?? "",
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"]);
        fetchCartList(context: context);
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
    required String pge,
    required String limit,
  }) async {
    loading1 = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getSnagList(
        context,
        id: id,
        page: pge,
        limit: limit,
      );

      if (response != null) {
        /// ✅ FIRST PAGE → replace list
        if (pge == "1") {
          snagListModel = response;
        }
        /// ✅ NEXT PAGES → append items
        else {
          snagListModel?.projectSnagList?.addAll(
            response.projectSnagList ?? [],
          );
        }

        /// ✅ Recalculate pending count
        final pendingCount =
            snagListModel?.projectSnagList
                ?.where((e) => e.isComplete == false)
                .length ??
            0;

        /// ✅ Maintain percentage list
        if (selectedPercentages.length < pendingCount) {
          selectedPercentages.addAll(
            List.generate(
              pendingCount - selectedPercentages.length,
              (index) => "0%",
            ),
          );
        }

        log("Fetched snag list page $pge successfully.");
      } else {
        log("Failed to fetch snag list.");
      }
    } catch (e) {
      log("Error fetching snag list: $e");
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
    required String date,
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
        date: date,
        amountDetails: amountDetails,
        file: file, // ✅ pass File
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        ToastUtil.show(
          responseData["message"] ?? "Expenses added successfully",
        );
        // fetchWallet(context: context, id: projectId,limit: "",page: );
        fetchWallet(context: context, id: projectId, page: "1", limit: "10");

        if (!context.mounted) return;
        // Navigator.pop(context);
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

  void addLocalCartItem(String itemId) {
    cartListModel ??= cart.CartListModel();
    cartListModel!.data ??= [];

    cartListModel!.data!.add(cart.Datum(itemId: int.tryParse(itemId), qty: 1));

    notifyListeners();
  }

  TextEditingController amountFundCtrl = TextEditingController();
  TextEditingController detailsFundCtrl = TextEditingController();
  TextEditingController numberCtrl = TextEditingController();

  Future<void> addFund({
    required BuildContext context,
    required String fund,
    required String date,
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
        date: date,
        // catId: catId,
        details: fundDetails,
        file: file, // ✅ pass File
      );

      log("${responseData["status"]}");

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"] ?? "Fund added successfully");
        fetchWallet(context: context, id: projectId, page: "1", limit: "10");
        if (!context.mounted) return;
        // Navigator.pop(context);
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
    _fundDate = null; // ✅ reset the backing field
    _expenseDate = null;
    formattedFundDate == "";
    formattedExpenseDate == "";
    notifyListeners();
  }

  List<AddedCategoryItem> addedCategoryItems = [];

  void addCategoryItem() {
    if (selectedCategory == null || numberCtrl.text.isEmpty) return;

    addedCategoryItems.add(
      AddedCategoryItem(category: selectedCategory!, count: numberCtrl.text),
    );

    numberCtrl.clear();
    selectedCategory = null;

    notifyListeners();
  }

  List<Map<String, dynamic>> getCategoryTypeForApi() {
    return addedCategoryItems.map((item) {
      return {
        "type": item.category.label ?? "",
        "count": int.parse(item.count.toString()), // ensure int
      };
    }).toList();
  }

  void removeCategoryItem(int index) {
    addedCategoryItems.removeAt(index);
    notifyListeners();
  }

  int? selectedExpenseCategoryId;

  wallet.WalletModel? walletModel;
  // Add these fields to ProjectProvider
  bool hasReachedMax = false;
  // our existing fetchWallet - resets list on fresh load
  Future fetchWallet({
    required BuildContext context,
    required String id,
    required String page,
    required String limit,
  }) async {
    load = true;
    hasReachedMax = false; // 👈 reset
    notifyListeners();

    try {
      final response = await NetworkHelper().getWalletList(
        context,
        id,
        page,
        limit,
      );
      if (response != null) {
        walletModel = response;
        // If returned items < limit, no more pages exist
        if ((response.data?.length ?? 0) < int.parse(limit)) {
          hasReachedMax = true;
        }
        log("Fetched wallet successfully.");
      }
    } catch (e) {
      log("Error fetching wallet: $e");
    } finally {
      load = false;
      notifyListeners();
    }
  }

  // New method - appends to existing list
  Future fetchMoreWallet({
    required BuildContext context,
    required String id,
    required String page,
    required String limit,
  }) async {
    try {
      final response = await NetworkHelper().getWalletList(
        context,
        id,
        page,
        limit,
      );
      if (response != null && response.data != null) {
        if (response.data!.isEmpty) {
          hasReachedMax = true; // 👈 no more data
        } else {
          // Append new transactions to existing list
          walletModel?.data?.addAll(response.data!);
          if (response.data!.length < int.parse(limit)) {
            hasReachedMax = true;
          }
        }
        notifyListeners();
      }
    } catch (e) {
      log("Error fetching more wallet: $e");
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
        date: DateFormat('MM-dd-yyyy').format(DateTime.now()),
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
    required File? sitePlan,
    required File? boq,
    required File? govtaper,
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
        date: DateFormat('MM-dd-yyyy').format(DateTime.now()),
        description: description ?? "",
        address: address ?? "",
        email: email ?? "",
        buildarea: buildarea ?? "",
        file: file,
        siteplan: sitePlan,
        boq: boq,
        govtaper: govtaper,
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

  void clearQuotationForm() {
    qbudgetAmountCntrl.clear();
    qemailCntrl.clear();
    qphoneClientCntrl.clear();
    qpincodeCntrl.clear();
    qaddressCntrl.clear();
    qbuildareaCntrl.clear();
    qnameClientCntrl.clear();
    qdescriptionCntrl.clear();
    qplotCntrl.clear();

    drwaings = null;
    sitePlan = null;
    boqFile = null;
    govtPaper = null;

    qprojectTypeName = null;
    // selectedCategoryType = null;

    notifyListeners();
  }

  ItemListModel? itemListModel;
  bool itemLoading = false;
  Future fetchItemLists({
    required BuildContext context,
    String? catid,
    String? endPrice,
    required String? keywrd,
  }) async {
    itemLoading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getItemLists(
        context,
        catid,
        endPrice,
        keywrd,
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

  String? selectedSort;
  void setSelectedSort(String value) {
    selectedSort = value;
    notifyListeners();
  }

  Future fetchItemLists2({
    required BuildContext context,
    String? catid,
    String? endPrice,
    String? startPrice,
    String? brandiid,
    required String? sort,
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
        sort,
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

  CategoryQoutesListModel? categoryDropDown;

  Future fetchCategoryDropdown({required BuildContext context}) async {
    itemLoading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getCategoryQuotes(context);

      if (response != null) {
        categoryDropDown = response; // Store fetched subcategories

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

  String selectedCategoryId1 = "";
  String selectedCategoryIdRental = "";
  String selectedCategoryId = "";
  // ✅ Store selected subcategory IDs & names
  List<String> selectedSubIds = [];
  List<String> selectedSubNames = [];
  void setSelectedCategory(String id) {
    selectedCategoryId = id;
    notifyListeners();
  }

  CategoryDropDown? selectedCategory;
  // CategoryQoutesListModel? categoryDropDown;
  void setSelectedCategoryQuotes(CategoryDropDown value) {
    selectedCategory = value;
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
  Future<void> fetchVariationLists({
    required BuildContext context,
    required String? catId,
    required Map<String, dynamic> attributeMap,
  }) async {
    itemLoadingSub = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getItemVariation(
        context,
        catId,
        attributeMap,
      );
      log("-----------------------${attributeMap}");
      if (response != null) {
        variationModel = response;

        log("Fetched variation successfully.");
      } else {
        log("Failed to fetch variation.");
      }
    } catch (e) {
      log("Error fetching variation: $e");
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
    String? projectid,
  }) async {
    itemLoading2 = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getItemListDetails(context, id);

      if (response != null) {
        itemListDetailsModel = response; // Store fetched subcategories
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductViewPage(pid: id ?? "", projectid: projectid ?? ""),
          ),
        );
        // fetchSeller(context: context, id: id ?? "", atttributeMap: "");
        //
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

  AddressListModel? addressListModel;
  Future fetchAddressList({
    required BuildContext context,
    // String? id,
  }) async {
    brand = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getAddressList(context);

      if (response != null) {
        addressListModel = response; // Store fetched subcategories

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
    required String? phone,
  }) async {
    memberLoads = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().addAddress(
        context: context,
        title: title,
        address: address,
        phone: phone,
        name: name,
        lng: lng,
        lat: lat,
        pincode: pincode,
      );
      print("object$title,$lat,$lng");
      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"] ?? "Address added");
        fetchAddressList(context: context);
        if (!context.mounted) return;

        Navigator.pop(context);
      } else {
        ToastUtil.show(
          responseData["message"] ??
              responseData["error"] ??
              "Please try again.",
        );
      }
    } catch (e) {
      ToastUtil.show("An error occurred. Please try again.");
    } finally {
      memberLoads = false; // ✅ FIXED
      notifyListeners();
    }
  }

  Map<int, int> selectedAttributeIndex = {};
  List<Map<String, dynamic>> selectedAttributeCategoryList = [];
  Map<String, dynamic> selectedAttributeNameMap = {};
  Map<String, bool> cartLoadingMap = {};
  Future<void> addtoCart({
    required BuildContext context,
    required String projectId,
    required String storeId,
    required String itemId,
    required String mrp,
    required String calPrice,
    required String qty,
    required String categoryId,
    required List<Map<String, dynamic>> attributeCategory,
    required Map<String, dynamic> attributeName,
  }) async {
    cartLoadingMap[itemId] = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().addToCart(
        context: context,
        projectId: projectId,
        attributeCategory: attributeCategory,
        attributeName: attributeName,
        categoryId: categoryId,
        itemId: itemId,
        mrp: mrp,
        qty: qty,
        calPrice: calPrice,
        storeId: storeId,
      );

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"] ?? "Cart added");
        fetchProjectList(context: context, status: "");
        fetchCartList(context: context);
        if (!context.mounted) return;

        // Navigator.pop(context);
      } else {
        ToastUtil.show(
          responseData["message"] ??
              responseData["error"] ??
              "Please try again.",
        );
      }
    } catch (e) {
      ToastUtil.show("An error occurred. Please try again.");
    } finally {
      cartLoadingMap[itemId] = false;
      notifyListeners();
    }
  }

  Future<void> buyNow({
    required BuildContext context,
    required String addressid,
    required String pid,
    required String total,
    required String grandTotal,
    required String storeId,
    required String itemId,
    required String mrp,
    required String qty,
    required String categoryId,
    required String calPrice,
    required List<Map<String, dynamic>> attributeCategory,
    required Map<String, dynamic> attributeName,
  }) async {
    cartLoadingMap[itemId] = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().buyNow(
        context: context,
        addressid: addressid,
        total: total,
        grandTotal: grandTotal,
        attributeCategory: attributeCategory,
        attributeName: attributeName,
        categoryId: categoryId,
        itemId: itemId,
        mrp: mrp,
        qty: qty,
        calPrice: calPrice,
        storeId: storeId,
      );

      if (responseData["status"] == true) {
        ToastUtil.show(
          responseData["message"] ?? "Buy now created successfully",
        );
        fetchProjectList(context: context, status: "");
        // fetchCartList(context: context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentMethodPage(
              total: grandTotal ?? "",
              orderId: responseData["OrderId"].toString(),
              pid: pid ?? "",
            ),
          ),
        );
        if (!context.mounted) return;

        // Navigator.pop(context);
      } else {
        ToastUtil.show(
          responseData["message"] ??
              responseData["error"] ??
              "Please try again.",
        );
      }
    } catch (e) {
      ToastUtil.show("An error occurred. Please try again.");
    } finally {
      cartLoadingMap[itemId] = false;
      notifyListeners();
    }
  }

  Future<void> checkOut({
    required BuildContext context,
    required String projectId,
    required String addressId,
    required String totalprice,
    required String grandTotal,
    required String calPrice,
    required List<Map<String, dynamic>> cart,
  }) async {
    memberLoads = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().checkOut(
        context: context,
        projectId: projectId,
        addressId: addressId,
        calPrice: calPrice,
        totalprice: totalprice,
        grandprice: grandTotal,
        cart: cart,
      );

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"] ?? "");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentMethodPage(
              total: totalprice ?? "",
              orderId: responseData["OrderId"].toString(),
              pid: projectId ?? "",
            ),
          ),
        );
      } else {
        ToastUtil.show(
          responseData["message"] ??
              responseData["error"] ??
              "Please try again.",
        );
      }
    } catch (e) {
      ToastUtil.show("An error occurred. Please try again.");
    } finally {
      memberLoads = false; // ✅ FIXED
      notifyListeners();
    }
  }

  File? govtPaper;
  Future<void> pickGovtFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      govtPaper = File(result.files.single.path!);
      notifyListeners();
    }
  }

  File? boqFile;
  Future<void> pickBOQFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      boqFile = File(result.files.single.path!);
      notifyListeners();
    }
  }

  File? sitePlan;
  Future<void> pickSitePlanFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      sitePlan = File(result.files.single.path!);
      notifyListeners();
    }
  }

  File? drwaings;
  Future<void> pickDrawingsFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      drwaings = File(result.files.single.path!);
      notifyListeners();
    }
  }

  Future<void> editProfile({
    required BuildContext context,
    required String number,
    required String name,
    required File? file,
    required String gender,
    required String email,
  }) async {
    expense = true;
    notifyListeners();

    try {
      final responseData = await NetworkHelper().addProfile(
        context: context,
        name: name,
        email: email,
        gender: gender,
        number: number,
        file: file,
      );

      if (responseData["status"] == true) {
        ToastUtil.show(
          responseData["message"] ?? "Profile updated successfully",
        );
        fetchProfile(context: context);
      } else {
        ToastUtil.show(
          responseData["message"] ??
              responseData["error"] ??
              "Please try again.",
        );
      }
    } catch (e) {
      ToastUtil.show("An error occurred. Please try again.");
    } finally {
      expense = false;
      notifyListeners();
    }
  }

  cart.CartListModel? cartListModel;

  Future fetchCartList({required BuildContext context}) async {
    itemLoading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getCartList(context);

      if (response != null) {
        cartListModel = response; // Store fetched subcategories

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

  AssignProjectModel? assignProjectModel;

  Future fetchAssignProjectList({required BuildContext context}) async {
    itemLoading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getAssignProject(context);

      if (response != null) {
        assignProjectModel = response; // Store fetched subcategories

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

  ServiceModel? serviceModel;

  Future fetchServiceList({
    required BuildContext context,
    required String? id,
    required String? keywrd,
  }) async {
    itemLoading = true;
    selectedCategoryId1 = id!;
    notifyListeners();

    try {
      final response = await NetworkHelper().getServiceList(
        context,
        id,
        keywrd,
      );

      if (response != null) {
        serviceModel = response; // Store fetched subcategories

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

  RentalModel? rentalModel;

  Future fetchRentalList({
    required BuildContext context,
    required String? id,
    required String? keywrd,
  }) async {
    itemLoading = true;
    selectedCategoryIdRental = id!;
    notifyListeners();

    try {
      final response = await NetworkHelper().getRentalList(context, id, keywrd);

      if (response != null) {
        rentalModel = response; // Store fetched subcategories

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

  ServiceViewModel? serviceViewModel;

  Future fetchServiceView({
    required BuildContext context,
    required String? id,
  }) async {
    itemLoading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getServiceView(context, id);

      if (response != null) {
        serviceViewModel = response; // Store fetched subcategories
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductViewSectionPage()),
        );
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

  RentalViewModel? rentalViewModel;

  Future fetchRentalView({
    required BuildContext context,
    required String? id,
  }) async {
    itemLoading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getRentalView(context, id);

      if (response != null) {
        rentalViewModel = response; // Store fetched subcategories
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RentalPageView()),
        );
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

  OrderListModel? orderListModel;

  Future fetchOrderList({
    required BuildContext context,
    required String? keyword,
  }) async {
    itemLoading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getOrderList(context, keyword);

      if (response != null) {
        orderListModel = response; // Store fetched subcategories

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

  OrderViewModel? orderViewModel;

  Future fetchOrderView({
    required BuildContext context,
    required String? id,
  }) async {
    itemLoading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getOrderView(context, id);

      if (response != null) {
        orderViewModel = response; // Store fetched subcategories
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsPage(oid: id ?? ""),
          ),
        );
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

  ServiceBookingModel? serviceBookingModel;

  Future fetchServiceBooking({
    required BuildContext context,
    // required String? id,
  }) async {
    itemLoading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getServiceBookingList(context);

      if (response != null) {
        serviceBookingModel = response; // Store fetched subcategories

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

  SearchModel? searchModel;
  bool search = false;
  Future fetchSearch({
    required BuildContext context,
    required String? keyword,
  }) async {
    search = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getSearchList(context, keyword);

      if (response != null) {
        searchModel = response; // Store fetched subcategories

        log("Fetched items successfully.");
      } else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching : $e");
    } finally {
      search = false;
      notifyListeners();
    }
  }

  seller.SellerModel? sellerModel;
  int? selectedSellerStoreId;
  int? selectedSellerPrice;
  String? selectedSellerCluster;

  void setSelectedSeller(seller.Datum seller) {
    selectedSellerStoreId = seller.storeId;
    selectedSellerPrice = seller.yourPrice;
    selectedSellerCluster = seller.store?.cluster?.name;
    notifyListeners();
  }

  Future fetchSeller({
    required BuildContext context,
    required String? id,
    required Map<String, dynamic> attributeMap,
  }) async {
    itemLoading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getSellerList(
        context,
        id,
        attributeMap,
      );

      if (response != null) {
        sellerModel = response; // Store fetched subcategories

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

  int? selectedProjectId;
  double? selectedProjectBalance; // ADD THIS
  void setSelectedProject(int? value, double? balance) {
    selectedProjectId = value;
    selectedProjectBalance = balance;
    notifyListeners();
  }

  void incrementQty(int cartId) {
    final index = cartListModel?.data?.indexWhere((e) => e.id == cartId);
    if (index != null && index != -1) {
      cartListModel!.data![index].qty =
          (cartListModel!.data![index].qty ?? 1) + 1;
      notifyListeners();
    }
  }

  void decrementQty(int cartId) {
    final index = cartListModel?.data?.indexWhere((e) => e.id == cartId);
    if (index != null && index != -1) {
      if ((cartListModel!.data![index].qty ?? 1) > 1) {
        cartListModel!.data![index].qty =
            (cartListModel!.data![index].qty ?? 1) - 1;
        notifyListeners();
      }
    }
  }

  Future<void> placeOrdeer({
    required BuildContext context,
    required String? pid,
    required String? orderId,
    required String? adddressId,
    required String? methodPay,
  }) async {
    memberLoads = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().placeOrder(
        context: context,
        addressId: adddressId ?? "",
        pid: pid ?? "",
        orderId: orderId ?? "",
        pMethod: methodPay ?? "",
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"]);

        if (!context.mounted) return;
        fetchCartList(
          context: context,
        ); // log("Navigating to LoginSuccessfulScreen...");
        //
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OrderSuccessPage()),
        );
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

  // ServiceDetailsModelNew? s;

  Future fetchServiceDetails({
    required BuildContext context,
    required String? id,
  }) async {
    itemLoading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getProjectServiceDEtails(
        context,
        id,
      );

      if (response != null) {
        serviceDetailsModel = response;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceBookDetails(id: id ?? ""),
          ),
        ); // Store fetched subcategories
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

  TextEditingController bNameCntrl = TextEditingController();
  TextEditingController bphoneCntrl = TextEditingController();
  TextEditingController bMsgCntrl = TextEditingController();
  Future<void> bookNow({
    required BuildContext context,
    required String name,
    required String phoneNumber,
    required File? file,
    required String serviceId,
    required String addressid,
    required String code,
    required String message,
    required String date,
  }) async {
    expense = true;
    notifyListeners();

    try {
      final responseData = await NetworkHelper().bookingSection(
        context: context,
        date: DateFormat('MM-dd-yyyy').format(DateTime.now()),
        code: "91",
        name: name ?? "",
        addressid: addressid ?? "",
        message: message ?? "",
        phoneNumber: phoneNumber ?? "",
        serviceId: serviceId ?? "",
        file: file, // ✅ pass File
      );

      log("${responseData["status"]}");

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"] ?? "Booking added successfully");

        if (!context.mounted) return;
        Navigator.pop(context);
        bNameCntrl.clear();
        bphoneCntrl.clear();
        bMsgCntrl.clear();
        bookFile = null;
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

  File? bookFile;
  Future<void> pickBookFileSection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      bookFile = File(result.files.single.path!);
      notifyListeners();
    }
  }

  Future<void> updateAddress({
    required BuildContext context,
    required String adddresId,
  }) async {
    memberLoads = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().updateAddress(
        context: context,
        addressId: adddresId ?? "",
      );

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"] ?? "Updated Successfully");
        fetchAddressList(context: context);
      } else {
        ToastUtil.show(
          responseData["message"] ??
              responseData["error"] ??
              "Please try again.",
        );
      }
    } catch (e) {
      ToastUtil.show("An error occurred. Please try again.");
    } finally {
      memberLoads = false; // ✅ FIXED
      notifyListeners();
    }
  }

  ServiceCategryListModel? serviceCategryListModel;

  Future fetchServiceCategry({required BuildContext context}) async {
    itemLoading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getServiceCatgryList(context);

      if (response != null) {
        serviceCategryListModel = response; // Store fetched subcategories

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

  rent.RentalCategoryModel? rentalCategoryModel;

  Future fetchRentalCategry({required BuildContext context}) async {
    itemLoading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getRentalCatgryList(context);

      if (response != null) {
        rentalCategoryModel = response; // Store fetched subcategories

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

  Future<void> deleteExpense({
    required BuildContext context,
    required String eid,

    // String? snagId,
  }) async {
    memberLoads = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().expenseDelete(
        context: context,
        eid: eid ?? "",
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"]);
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

  Future<void> deleteAddress({
    required BuildContext context,
    required String eid,

    // String? snagId,
  }) async {
    memberLoads = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().addressDelete(
        context: context,
        eid: eid ?? "",
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"]);
        fetchAddressList(context: context);
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

  Future<void> deleteProject({
    required BuildContext context,
    required String pid,

    // String? snagId,
  }) async {
    memberLoads = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().projectDelete(
        context: context,
        pid: pid ?? "",
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"]);
        fetchProjectList(context: context, status: "");
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
      memberLoads = false;
      notifyListeners();
    }
  }

  Future<void> editQty({
    required BuildContext context,
    required String? pid,
    required String? qty,
    required String? price,
    required String? calPrice,
  }) async {
    memberLoads = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().editQty(
        context: context,
        calPrice: calPrice ?? "",
        pid: pid ?? "",
        qty: qty ?? "",
        price: price ?? "",
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"]);

        if (!context.mounted) return;
        fetchCartList(
          context: context,
        ); // log("Navigating to LoginSuccessfulScreen...");
        //

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

  Future<void> editAddress({
    required BuildContext context,
    required String? title,
    required String? addressId,
    required String? address,
    required String? pincode,
    required String? lat,
    required String? lng,
    required String? name,
    required String? phone,
  }) async {
    memberLoads = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().editAddress(
        context: context,
        title: title,
        address: address,
        addressId: addressId,
        phone: phone,
        name: name,
        lng: lng,
        lat: lat,
        pincode: pincode,
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"]);

        if (!context.mounted) return;
        fetchAddressList(
          context: context,
        ); // log("Navigating to LoginSuccessfulScreen...");
        //

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

  Future<void> editProject({
    required BuildContext context,
    required String? name,
    required String? pid,
    required String? dueDate,
    required String? budget,
    required String? description,
  }) async {
    loading = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().editProjecct(
        context: context,
        pid: pid ?? "",
        name: name ?? "",
        budget: budget ?? "",
        dueDate: dueDate ?? "",
        description: description ?? "",
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"]);

        if (!context.mounted) return;
        fetchProjectList(
          context: context,
          status: "",
        ); // log("Navigating to LoginSuccessfulScreen...");
        //

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

  // Future<void> editFund({
  //   required String id,
  //   required String amount,
  //   required String details,
  //   required String date,
  //   File? file,
  // }) async {
  //   memberLoads = true;
  //   notifyListeners();
  //
  //   try {
  //     var responseData = await NetworkHelper().editFund(
  //       id: id,
  //       amount: amount,
  //       date: date,
  //       details: details,
  //       file: file,
  //     );
  //
  //     log("LOG MESSAGE222222:");
  //
  //     if (responseData["status"] == true) {
  //       ToastUtil.show(responseData["message"]);
  //
  //       if (!context.mounted) return;
  //       fetchCartList(
  //         context: context,
  //       ); // log("Navigating to LoginSuccessfulScreen...");
  //       //
  //
  //       // fetchProjectMember(context: context, id: );
  //     } else {
  //       String errorMessage =
  //           responseData["message"] ??
  //           responseData["error"] ??
  //           "Please try again.";
  //       log("Sign$errorMessage");
  //
  //       if (!context.mounted) return;
  //       ToastUtil.show("An error occurred. Please try again.");
  //     }
  //   } catch (e, stack) {
  //     log("❌ exception: $e\n$stack");
  //     log("Error: $e");
  //     // ToastUtil.show("An error occurred. Please try again.");
  //     ToastUtil.show("An error occurred. Please try again.");
  //   } finally {
  //     loading = false;
  //     notifyListeners();
  //   }
  // }

  DateTime? _fundDate;

  DateTime? get fundDate => _fundDate;

  String get formattedFundDate {
    if (_fundDate == null) return "";
    return DateFormat('MM-dd-yyyy').format(_fundDate!);
  }

  String get apiFundDate {
    if (_fundDate == null) return "";
    return DateFormat('dd-MM-yyyy').format(_fundDate!);
  }

  Future<void> pickFundDate(BuildContext context) async {
    final DateTime? pickedFDate = await showDatePicker(
      context: context,
      initialDate: _fundDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedFDate != null) {
      _fundDate = pickedFDate;
      print("-----$formattedFundDate--------${fundDate}");
      notifyListeners();
    }
  }

  DateTime? _expenseDate;

  DateTime? get expenseDate => _expenseDate;

  String get formattedExpenseDate {
    if (_expenseDate == null) return "";
    return DateFormat('MM-dd-yyyy').format(_expenseDate!);
  }

  String get apiDate {
    if (_expenseDate == null) return "";
    return DateFormat('dd-MM-yyyy').format(_expenseDate!);
  }

  Future<void> pickExpanseDate(BuildContext context) async {
    final DateTime? pickedEDate = await showDatePicker(
      context: context,
      initialDate: _expenseDate ?? DateTime.now(),
      firstDate: DateTime(2000),

      lastDate: DateTime(2100),
    );

    if (pickedEDate != null) {
      _expenseDate = pickedEDate;
      print("-----$formattedExpenseDate--------${expenseDate}");
      notifyListeners();
    }
  }

  void setExpenseDate(DateTime date) {
    _expenseDate = date;
    notifyListeners();
  }

  // final PdfService _pdfService = PdfService();

  bool isLoading = false;

  Future<void> downloadPdf({
    required BuildContext context,
    required int id,
  }) async {
    isLoading = true;
    notifyListeners();

    final path = await NetworkHelper().downloadEstimationPdf(id);

    isLoading = false;
    notifyListeners();

    if (path != null) {
      await OpenFilex.open(path);
    }
  }
  // bool isLoading = false;

  Future<void> downloadSnagPdf({
    required BuildContext context,
    required int id,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final path = await NetworkHelper().downloadSnagReport(id);

      isLoading = false;
      notifyListeners();

      if (path != null) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text("Report downloaded successfully")),
        ToastUtil.show("Report downloaded successfully");
        // );
      } else {
        ToastUtil.show("Failed to download report");

        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text("Failed to download report")),
        // );
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
    }
  }

  Future<void> downloadWalletPdf({
    required BuildContext context,
    required int id,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final path = await NetworkHelper().downloadWalletReport(id);

      isLoading = false;
      notifyListeners();

      if (path != null) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text("Report downloaded successfully")),
        ToastUtil.show("Report downloaded successfully");
        // );
      } else {
        ToastUtil.show("Failed to download report");

        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text("Failed to download report")),
        // );
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
    }
  }

  Future<void> downloadOverviewPdf({
    required BuildContext context,
    required int id,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final path = await NetworkHelper().downloadOverviewReport(id);

      isLoading = false;
      notifyListeners();

      if (path != null) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text("Report downloaded successfully")),
        ToastUtil.show("Report downloaded successfully");
        // );
      } else {
        ToastUtil.show("Failed to download report");

        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text("Failed to download report")),
        // );
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
    }
  }

  Future<void> downloadQuotesPdf({
    required BuildContext context,
    required int id,
  }) async {
    isLoading = true;
    notifyListeners();

    final path = await NetworkHelper().downloadQuotesPdf(id);

    isLoading = false;
    notifyListeners();

    if (path != null) {
      await OpenFilex.open(path);
    }
  }

  Future<void> downloadInvoicePdf({
    required BuildContext context,
    required int Orderid,
    required int storeId,
  }) async {
    isLoading = true;
    notifyListeners();

    final path = await NetworkHelper().downloadInvoicePdf(Orderid, storeId);

    isLoading = false;
    notifyListeners();

    if (path != null) {
      await OpenFilex.open(path);
    }
  }

  TextEditingController titlePCntrl = TextEditingController();
  TextEditingController budgetPCntrl = TextEditingController();
  TextEditingController dueDatePCntrl = TextEditingController();
  TextEditingController desPCntrl = TextEditingController();

  String? formatteProjectDate;

  ProjectWithIdModel? projectWithIdModel;

  Future fetchSingleProject({required BuildContext context, String? id}) async {
    itemLoading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getProjectSingle(context, id);

      if (response != null) {
        projectWithIdModel = response; // Store fetched subcategories

        titlePCntrl.text = response?.data?.name ?? "";
        budgetPCntrl.text = response?.data?.budget.toString() ?? "";

        dueDatePCntrl.text = DateFormat(
          'dd MMM yyyy',
        ).format(DateTime.parse(response?.data?.dueDate.toString() ?? ""));

        desPCntrl.text = response.data?.description ?? "";

        notifyListeners();
      }
      // }   log("Fetched items successfully.");
      else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching : $e");
    } finally {
      itemLoading = false;
      notifyListeners();
    }
  }

  InvoiceModel? invoiceModel;

  Future fetchViewEstimation({
    required BuildContext context,
    String? id,
  }) async {
    itemLoading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getEstimationInvoice(context, id);

      if (response != null) {
        invoiceModel = response; // Store fetched subcategories
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ServiceInvoicePage(id: id)),
        );
        notifyListeners();
      }
      // }   log("Fetched items successfully.");
      else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching : $e");
    } finally {
      itemLoading = false;
      notifyListeners();
    }
  }

  InvoiceQyotaionModel? invoiceQyotaionModel;
  ServiceDetailsModelNew? serviceDetailsModel;
  Future fetchQuotationView({required BuildContext context, String? id}) async {
    itemLoading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getQuotationInvoice(context, id);

      if (response != null) {
        invoiceQyotaionModel = response; // Store fetched subcategories
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InvoicePageQuotation()),
        );
        notifyListeners();
      }
      // }   log("Fetched items successfully.");
      else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching : $e");
    } finally {
      itemLoading = false;
      notifyListeners();
    }
  }

  Future fetchServiceBookView({
    required BuildContext context,
    String? id,
  }) async {
    itemLoading = true;
    notifyListeners();

    try {
      final response = await NetworkHelper().getServiiceBookDetails(
        context,
        id,
      );

      if (response != null) {
        serviceDetailsModel = response; // Store fetched subcategories

        notifyListeners();
      }
      // }   log("Fetched items successfully.");
      else {
        log("Failed to fetch.");
      }
    } catch (e) {
      log("Error fetching : $e");
    } finally {
      itemLoading = false;
      notifyListeners();
    }
  }

  Future<void> estimationStatuss({
    required BuildContext context,
    String? status,
    String? id,
  }) async {
    addToCartLoading = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().estimationStatus(
        context: context,
        statuss: status ?? "",
        id: id ?? "",
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"]);

        if (!context.mounted) return;

        log("Navigating to ...");

        Navigator.pop(context);
        fetchEstimation(context: context);
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
      addToCartLoading = false;
      notifyListeners();
    }
  }

  Future<void> serviceStatus({
    required BuildContext context,
    String? status,
    String? id,
  }) async {
    addToCartLoading = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().serviceStatus(
        context: context,
        statuss: status ?? "",
        id: id ?? "",
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"]);

        if (!context.mounted) return;

        log("Navigating to ...");

        Navigator.pop(context);
        fetchServiceBookView(context: context, id: id);
        // fetchEstimation(context: context);/
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
      addToCartLoading = false;
      notifyListeners();
    }
  }

  Future<void> quotationStatuss({
    required BuildContext context,
    String? status,
    String? id,
  }) async {
    addToCartLoading = true;
    notifyListeners();

    try {
      var responseData = await NetworkHelper().quotationStatus(
        context: context,
        statuss: status ?? "",
        id: id ?? "",
      );

      log("LOG MESSAGE222222:");

      if (responseData["status"] == true) {
        ToastUtil.show(responseData["message"]);

        if (!context.mounted) return;

        log("Navigating to ...");

        Navigator.pop(context);
        fetchQuatation(context: context);
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
      addToCartLoading = false;
      notifyListeners();
    }
  }

  ApprovalOederModel? approvalOederModel;
  // bool loading1 = false;
  int currentPage = 1;
  bool hasMore = true;
  bool isPaginationLoading = false;
  List<Datum> approvalList = []; // your list

  Future fetchApprovalList({
    required BuildContext context,
    required String id,
    required String page,
    required String limit,
  }) async {
    if (page == "1") {
      loading1 = true;
    } else {
      isPaginationLoading = true;
    }

    notifyListeners();

    try {
      final response = await NetworkHelper().getApprovals(
        context: context,
        id: id,
        page: page,
        limit: limit,
      );

      if (response != null) {
        if (page == "1") {
          approvalList = response.data ?? [];
        } else {
          approvalList.addAll(response.data ?? []);
        }

        // check if more data available
        hasMore = (response.data?.length ?? 0) == int.parse(limit);
        currentPage = int.parse(page);
      }
    } catch (e) {
      log("Error fetching approval list: $e");
    } finally {
      loading1 = false;
      isPaginationLoading = false;
      notifyListeners();
    }
  }
}

class AddedCategoryItem {
  final CategoryDropDown category;
  final String count;

  AddedCategoryItem({required this.category, required this.count});
}
