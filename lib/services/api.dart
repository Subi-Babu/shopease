import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' hide log;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart' as path;
import 'package:youbuilt/model/activity_model.dart';
import 'package:youbuilt/model/brandmodel.dart';
import 'package:youbuilt/model/category_list_model.dart';
import 'package:youbuilt/model/countrycode.dart';
import 'package:youbuilt/model/estimaton.dart';
import 'package:youbuilt/model/expense_model.dart';
import 'package:youbuilt/model/item_details.dart';
import 'package:youbuilt/model/item_list_model.dart';
import 'package:youbuilt/model/profile_model.dart';
import 'package:youbuilt/model/project_file_list_model.dart';
import 'package:youbuilt/model/project_list_model.dart';
import 'package:youbuilt/model/project_members.dart';
import 'package:youbuilt/model/project_type_model.dart';
import 'package:youbuilt/model/project_view_model.dart';
import 'package:youbuilt/model/projectfolder_model.dart';
import 'package:youbuilt/model/quatation.dart';
import 'package:youbuilt/model/sanp_drop_model.dart';
import 'package:youbuilt/model/snaglist_model.dart';
import 'package:youbuilt/model/stage_model.dart';
import 'package:youbuilt/model/subcatgeory_model.dart';
import 'package:youbuilt/model/variation_model.dart';
import 'package:youbuilt/model/wallet_model.dart';

import 'package:youbuilt/services/urls.dart';
import 'package:youbuilt/utils/toast_util.dart';

import '../screen/login.dart';
import '../utils/constants.dart';
import 'netwrkscreen.dart';

class NetworkHelper {
  var _dio = Dio();

  ///////////////////////////
  Future<http.Response?> _getRequest({
    required BuildContext context,
    required String url,
    Map<String, String>? header,
  }) async {
    bool isConnected = await checkNetworkConnectivity();

    if (!isConnected) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ConnectivityCheckScreen(),
        ),
      );
      return null;
    }

    http.Response response;

    try {
      response = await http.get(
        Uri.parse(url),
        headers:
            header ??
            {
              'Content-Type': 'application/json',
              'Authorization': "Bearer ${accessToken ?? ""}",
            },
      );

      debugPrint(
        "url - $url \n header - $header \ntoken---$accessToken response Status - ${response.statusCode} \n response - ${response.body}",
      );
      debugPrint("tokennn ----$accessToken");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        var error = jsonDecode(response.body);
        ToastUtil.show(error["message"] ?? "Something went wrong!");
        return null;
      }
    } catch (e) {
      ToastUtil.show("An error occurred: $e");
      return null;
    }
  }

  String _extractError(
    String body, {
    String fallback = "Something went wrong!",
  }) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map) {
        return (decoded['message'] ??
                decoded['error'] ??
                decoded['detail'] ??
                fallback)
            .toString();
      }
    } catch (_) {}
    return fallback;
  }

  Future<http.Response?> _postRequest({
    required BuildContext context,
    required String url,
    required dynamic body,
    Map<String, String>? header,
    bool showErrorToast = true,
  }) async {
    bool isConnected = await checkNetworkConnectivity();

    if (!isConnected) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ConnectivityCheckScreen()),
      );
      return null;
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers:
            header ??
            {
              'Content-Type': 'application/json',
              'Authorization': "Bearer ${accessToken ?? ""}",
            },
        body: jsonEncode(body),
      );

      debugPrint("POST $url | ${response.statusCode} | ${response.body}");

      // ✅ Always return response
      return response;
    } catch (e) {
      if (showErrorToast) {
        ToastUtil.show("An error occurred: $e");
      }
      return null;
    }
  }

  // Future<http.Response?> _postRequest({
  //   required BuildContext context,
  //   required String url,
  //   required dynamic body,
  //   Map<String, String>? header,
  //   bool showErrorToast = true, // ✅ caller controls this
  // }) async {
  //   bool isConnected = await checkNetworkConnectivity();
  //   if (!isConnected) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (_) => const ConnectivityCheckScreen()),
  //     );
  //     return null;
  //   }
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers:
  //           header ??
  //           {
  //             'Content-Type': 'application/json',
  //             'Authorization': "Bearer ${accessToken ?? ""}",
  //           },
  //       body: jsonEncode(body),
  //     );
  //     debugPrint("POST $url | ${response.statusCode} | ${response.body}");
  //
  //     if (response.statusCode == 200 || response.statusCode == 201)
  //       return response;
  //
  //     if (showErrorToast) // ✅ only show if caller wants it
  //       ToastUtil.show(_extractError(response.body));
  //
  //     return null;
  //   } catch (e) {
  //     if (showErrorToast) // ✅ same for network/exception errors
  //       ToastUtil.show("An error occurred: $e");
  //
  //     return null;
  //   }
  // }

  Future<http.Response?> _patchRequest({
    required BuildContext context,
    required String url,
    required dynamic body,
    Map<String, String>? header,
  }) async {
    http.Response? response;

    try {
      response = await http.patch(
        Uri.parse(url),
        headers:
            header ??
            {
              'Content-Type': 'application/json',
              'Authorization': "Bearer ${accessToken ?? ""}",
            },
        body: jsonEncode(body),
      );

      debugPrint(
        "PATCH url - $url\n"
        "header - $header\n"
        "token - $accessToken\n"
        "body - $body\n"
        "status - ${response.statusCode}\n"
        "response - ${response.body}",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else if (response.statusCode == 401 ||
          response.statusCode == 403 ||
          response.statusCode == 404) {
        final jsonResponse = json.decode(response.body);
        ToastUtil.show(jsonResponse['error'] ?? "Session expired");

        return null;
      } else {
        final jsonResponse = json.decode(response.body);
        ToastUtil.show(jsonResponse['message'] ?? "Something went wrong!");
        return null;
      }
    } catch (e) {
      log("PATCH error ---- $e");
      return null;
    }
  }

  Future<http.Response?> _deleteRequest({
    required BuildContext context,
    required String url,
    Map<String, String>? header,
  }) async {
    http.Response? response;

    try {
      response = await http.delete(
        Uri.parse(url),
        headers:
            header ??
            {
              'Content-Type': 'application/json',
              'Authorization': "Bearer ${accessToken ?? ""}",
            },
      );

      debugPrint(
        "DELETE url - $url\n"
        "header - $header\n"
        "token - $accessToken\n"
        "status - ${response.statusCode}\n"
        "response - ${response.body}",
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // 204 = No Content (common for delete)
        return response;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        final jsonResponse = json.decode(response.body);
        ToastUtil.show(jsonResponse['error'] ?? "Session expired");
        return null;
      } else {
        final jsonResponse = json.decode(response.body);
        ToastUtil.show(jsonResponse['message'] ?? "Something went wrong!");
        return null;
      }
    } catch (e) {
      log("DELETE error ---- $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> login({
    required BuildContext context,
    required String phonenumber,
    required String pwd,
  }) async {
    try {
      final response = await _postRequest(
        context: context,
        url: Urls.loginUrl,
        body: {"phoneNumber": phonenumber, "password": pwd},
      );

      if (response == null) {
        return null;
      }

      var responseData = jsonDecode(response.body);

      return {"status": response.statusCode, "data": responseData};
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>?> sendOtp({
    required BuildContext context,
    required String? phonenumber,
    required String? code,
  }) async {
    try {
      final response = await _postRequest(
        context: context,
        showErrorToast: false,
        url: Urls.sendOtpUrl,
        body: {"phoneNumber": phonenumber, "code": code},
      );

      if (response == null) {
        return null;
      }

      var responseData = jsonDecode(response.body);

      return {"status": response.statusCode, "data": responseData};
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>?> verifyOtp({
    required BuildContext context,
    required String? phonenumber,
    required String? code,
    required String? otp,
  }) async {
    try {
      http.Response? response;
      response = await _postRequest(
        context: context,
        url: Urls.verifyOtpUrl,
        showErrorToast: false,
        body: {"phoneNumber": phonenumber, "code": code, "otp": otp},
      );

      if (response == null) {
        return null;
      }

      var responseData = jsonDecode(response.body);

      return {"status": response.statusCode, "data": responseData};
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>?> resendOtp({
    required BuildContext context,
    required String? phonenumber,
    required String? code,
  }) async {
    try {
      http.Response? response;
      response = await _postRequest(
        context: context,
        url: Urls.resendOtpUrl,
        body: {"phoneNumber": phonenumber, "code": code},
      );

      if (response == null) {
        return null;
      }

      var responseData = jsonDecode(response.body);

      return {"status": response.statusCode, "data": responseData};
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future signUp({
    required BuildContext context,
    required String? phonenumber,
    required String? pwd,
    required String? code,
    required String? name,
  }) async {
    http.Response? response;
    response = await _postRequest(
      context: context,
      url: Urls.signUpUrl,
      body: {
        "phoneNumber": phonenumber,
        "name": name,
        "code": code,
        "password": pwd,
      },
    );

    if (response != null) {
      return jsonDecode(response.body); // ✅ IMPORTANT
    }
    return null;
  }

  Future<CountryCodeModel?> getCountyCode(BuildContext context) async {
    http.Response? response;
    response = await _getRequest(context: context, url: Urls.countryCodeUrl);
    if (response != null) {
      log("$response");
      return CountryCodeModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching countrty code");
      return null;
    }
  }

  Future<ProjectListModel?> getProjectList(
    BuildContext context,
    String? status,
  ) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url: "${Urls.projectListUrl}?status=$status",
    );
    if (response != null) {
      log("$response");
      return ProjectListModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching project list");
      return null;
    }
  }

  Future<ProjectListViewModel?> getProjectView(
    BuildContext context,
    String? id,
  ) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url: "${Urls.projectViewListUrl}/$id",
    );
    if (response != null) {
      log("$response");
      return ProjectListViewModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching project list details");
      return null;
    }
  }

  Future<ProjectMembersModel?> getProjectMember(
    BuildContext context,
    String? id,
  ) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url: "${Urls.projectMemberUrl}/$id",
    );
    if (response != null) {
      log("$response");
      return ProjectMembersModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching project member list details");
      return null;
    }
  }

  Future<SnagDropdownModel?> getSnagDropdown(BuildContext context) async {
    http.Response? response;
    response = await _getRequest(context: context, url: Urls.snagDropUrl);
    if (response != null) {
      log("$response");
      return SnagDropdownModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching data");
      return null;
    }
  }

  Future<ExpensesDropModel?> getExpenseDropdown(BuildContext context) async {
    http.Response? response;
    response = await _getRequest(context: context, url: Urls.exCategoryUrl);
    if (response != null) {
      log("$response");
      return ExpensesDropModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching data");
      return null;
    }
  }

  Future<Map<String, dynamic>> addProject({
    required BuildContext context,
    required String? title,
    required String? budget,
    required String? duedate,
    required String? description,
  }) async {
    try {
      http.Response? response;
      response = await _postRequest(
        context: context,
        url: Urls.addProjectUrl,
        body: {
          "name": title,
          "dueDate": duedate,
          "budget": budget,
          "description": description,
        },
      );

      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> inviteMembers({
    required BuildContext context,
    required String? phoneNumber,
    required String? id,
  }) async {
    try {
      http.Response? response;
      response = await _postRequest(
        context: context,
        url: "${Urls.projectInviteUrl}/$id",
        body: {"phoneNumber": phoneNumber},
      );

      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> addSnag({
    required BuildContext context,
    required String? title,
    required String? snagId,
    required String? projectId,
  }) async {
    try {
      http.Response? response;
      response = await _postRequest(
        context: context,
        url: "${Urls.snagAddUrl}/$projectId",
        body: {"details": title, "snagStatusId": snagId},
      );

      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<SnagListModel?> getSnagList(BuildContext context, String? id) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url: "${Urls.snaglistUrl}/$id",
    );
    if (response != null) {
      log("$response");
      return SnagListModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching snag list");
      return null;
    }
  }

  Future<Map<String, dynamic>> snagPercent({
    required BuildContext context,
    required String? completeValue,
    required String? snagId,
  }) async {
    try {
      http.Response? response;
      response = await _patchRequest(
        context: context,
        url: "${Urls.snagUpdateUrl}/$snagId",
        body: {"completePercentage": completeValue, "isComplete": false},
      );

      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> snagComplete({
    required BuildContext context,
    // required String? completeValue,
    required bool? completeValue,
    required String? snagId,
  }) async {
    try {
      http.Response? response;
      response = await _patchRequest(
        context: context,
        url: "${Urls.snagUpdateUrl}/$snagId",
        body: {
          //"completePercentage": completeValue,
          "isComplete": completeValue,
        },
      );

      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> snagStatus({
    required BuildContext context,
    required String? snagstatus,
    required String? snagId,
  }) async {
    try {
      http.Response? response;
      response = await _patchRequest(
        context: context,
        url: "${Urls.snagUpdateUrl}/$snagId",
        body: {
          // "completePercentage": snagstatus,
          "isComplete": false,
          "snagStatusId": snagstatus,
        },
      );

      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> snagDelete({
    required BuildContext context,

    required String? snagId,
  }) async {
    try {
      http.Response? response;
      response = await _deleteRequest(
        context: context,
        url: "${Urls.snagdeleteUrl}/$snagId",
      );

      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> addExpenses({
    required BuildContext context,
    required String amount,
    required String amountDetails,
    required String catId,
    required File? file,
    required String projectId,
  }) async {
    try {
      final uri = Uri.parse("${Urls.addExpenseUrl}/$projectId");
      final request = http.MultipartRequest('POST', uri);

      // 🔐 Headers
      request.headers.addAll({'Authorization': "Bearer ${accessToken ?? ""}"});

      // 🧾 Fields
      request.fields['amount'] = amount;
      request.fields['expenseDetails'] = amountDetails;
      request.fields['expenseCategoryId'] = catId;

      // 📎 Optional file
      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath('file', file.path));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      debugPrint(
        "url - $uri \n header  \n---tokenn00---$accessToken body - $request \n response Status - ${response.statusCode} \n response - ${response.body}",
      );
      debugPrint("FIELDS:");
      request.fields.forEach((k, v) => debugPrint("$k : $v"));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {"status": false, "error": response.body};
      }
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> addFund({
    required BuildContext context,
    required String amount,
    required String details,
    required File? file,
    required String projectId,
  }) async {
    try {
      final uri = Uri.parse("${Urls.addFundUrl}/$projectId");
      final request = http.MultipartRequest('POST', uri);

      // 🔐 Header
      request.headers['Authorization'] = "Bearer ${accessToken ?? ""}";
      print("URLLLL____$uri");
      // 🧾 Fields (EXACT as backend expects)
      request.fields.addAll({'amount': amount, 'details': details});

      // 📎 File
      if (file != null && await file.exists()) {
        final fileName = path.basename(file.path);
        final ext = fileName.split('.').last.toLowerCase();

        MediaType mediaType;
        if (ext == 'png') {
          mediaType = MediaType('image', 'png');
        } else if (ext == 'jpg' || ext == 'jpeg') {
          mediaType = MediaType('image', 'jpeg');
        } else if (ext == 'pdf') {
          mediaType = MediaType('application', 'pdf');
        } else {
          mediaType = MediaType('application', 'octet-stream');
        }

        request.files.add(
          await http.MultipartFile.fromPath(
            'file', // ✅ EXACT key
            file.path,
            filename: fileName,
            contentType: mediaType,
          ),
        );
      }

      // 🧪 Debug
      debugPrint("URL: $uri");
      debugPrint("HEADERS: ${request.headers}");
      request.fields.forEach((k, v) => debugPrint("FIELD $k: $v"));
      for (final f in request.files) {
        debugPrint(
          "FILE field=${f.field}, filename=${f.filename}, type=${f.contentType}",
        );
      }

      // 🚀 Send
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("RESPONSE: ${response.body}");

      final decoded = jsonDecode(response.body);

      return decoded is Map<String, dynamic>
          ? decoded
          : {"status": false, "error": response.body};
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<WalletModel?> getWalletList(BuildContext context, String? id) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url: "${Urls.walletUrl}/$id",
    );
    if (response != null) {
      log("$response");
      return WalletModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching wallet list");
      return null;
    }
  }

  Future<StageCategoryModel?> getStageCategoryList(
    BuildContext context,
    String? pid,
  ) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url: "${Urls.stageCategoryUrl}?projectId=$pid",
    );
    if (response != null) {
      log("$response");
      return StageCategoryModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching wallet list");
      return null;
    }
  }

  Future<ActivityModel?> getActivityList(
    BuildContext context,
    String? pid,
    String? keyword,
  ) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url: "${Urls.activityUrl}/$pid?keyword=$keyword",
    );
    if (response != null) {
      log("$response");
      return ActivityModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching wallet list");
      return null;
    }
  }

  Future<ProjectFolderModel?> getProjectFolderList(
    BuildContext context,
    String? pid,
  ) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url: "${Urls.projectFolderListUrl}?projectId=$pid",
    );
    if (response != null) {
      log("$response");
      return ProjectFolderModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching folder list");
      return null;
    }
  }

  Future<ProfileModel?> getProfile(BuildContext context) async {
    http.Response? response;
    response = await _getRequest(context: context, url: Urls.profileUrl);
    if (response != null) {
      log("$response");
      return ProfileModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching profile details");
      return null;
    }
  }

  Future<EstimationModel?> getEstimation(BuildContext context) async {
    http.Response? response;
    response = await _getRequest(context: context, url: Urls.estimationUrl);
    if (response != null) {
      log("$response");
      return EstimationModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<QuatationModel?> getQuatation(BuildContext context) async {
    http.Response? response;
    response = await _getRequest(context: context, url: Urls.quotesUrl);
    if (response != null) {
      log("$response");
      return QuatationModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<ProjectTypeModel?> getproTypeDrop(BuildContext context) async {
    http.Response? response;
    response = await _getRequest(context: context, url: Urls.projectTypeUrl);
    if (response != null) {
      log("$response");
      return ProjectTypeModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<ProjectFileListModel?> getProjectFileLists(
    BuildContext context,
    String? pid,
    String? pfolderid,
    // String? pid,
  ) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url:
          "${Urls.projectFileListUrl}?projectId=$pid&keyword=&projectFolderId=$pfolderid",
    );
    if (response != null) {
      log("$response");
      return ProjectFileListModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<ItemListModel?> getItemLists(
    BuildContext context,
    String? catId,
    String? endPrice,
    // String? pid,
  ) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url: "${Urls.itemUrl}?categoryId=$catId",
    );
    if (response != null) {
      log("$response");
      return ItemListModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<ItemListModel?> getItemLists2(
    BuildContext context,
    String? catId,
    String? endPrice,
    String? startPrice,
    String? brandiid,
    // String? pid,
  ) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url:
          "${Urls.itemUrl}?categoryId=$catId&brandId=$brandiid&startPrice=$startPrice&endPrice=$endPrice&sortby=",
    );
    if (response != null) {
      log("$response");
      return ItemListModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<CategroyListModel?> getCategoryyLists(BuildContext context) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url: "${Urls.categoryListUrl}",
    );
    if (response != null) {
      log("$response");
      return CategroyListModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<SubCategoryModel?> getSubCategoryyLists(
    BuildContext context,
    String? catId,
  ) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url: "${Urls.subCatUrl}?categoryId=$catId",
    );
    if (response != null) {
      log("$response");
      return SubCategoryModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<VariationModelModel?> getItemVaraition(
    BuildContext context,
    String? itemid,
    Map<String, dynamic> attributeMap,
  ) async {
    http.Response? response;
    String attributeJson = jsonEncode(attributeMap);
    response = await _getRequest(
      context: context,
      url:
          "${Urls.itemVaraiationUrl}/$itemid?attributeName=${Uri.encodeComponent(attributeJson)}",
    );
    if (response != null) {
      log("$response");
      return VariationModelModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<ItemListDetailsModel?> getItemListDetails(
    BuildContext context,
    String? id,

    // String? pid,
  ) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url: "${Urls.itemDetailsUrl}/$id",
    );
    if (response != null) {
      log("$response");
      return ItemListDetailsModel.fromJson(jsonDecode(response.body));
    } else {
      // ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<Map<String, dynamic>> addFolder({
    required BuildContext context,
    required String? title,
    required String? projectId,
  }) async {
    try {
      http.Response? response;
      response = await _postRequest(
        context: context,
        url: Urls.projectFolderUrl,
        body: {"name": title, "projectId": projectId},
      );

      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> addFile({
    required BuildContext context,
    required String name,
    required String projectFolderId,
    required File? file,
    required String projectId,
  }) async {
    try {
      final uri = Uri.parse("${Urls.projectFileUploadUrl}");
      final request = http.MultipartRequest('POST', uri);

      // 🔐 Header
      request.headers['Authorization'] = "Bearer ${accessToken ?? ""}";
      print("URLLLL____$uri");
      // 🧾 Fields (EXACT as backend expects)
      request.fields.addAll({
        'name': name,
        'projectId': projectId,
        'projectFolderId': projectFolderId,
      });

      // 📎 File
      if (file != null && await file.exists()) {
        final fileName = path.basename(file.path);
        final ext = fileName.split('.').last.toLowerCase();

        MediaType mediaType;
        if (ext == 'png') {
          mediaType = MediaType('image', 'png');
        } else if (ext == 'jpg' || ext == 'jpeg') {
          mediaType = MediaType('image', 'jpeg');
        } else if (ext == 'pdf') {
          mediaType = MediaType('application', 'pdf');
        } else {
          mediaType = MediaType('application', 'octet-stream');
        }

        request.files.add(
          await http.MultipartFile.fromPath(
            'file', // ✅ EXACT key
            file.path,
            filename: fileName,
            contentType: mediaType,
          ),
        );
      }

      // 🧪 Debug
      debugPrint("URL: $uri");
      debugPrint("HEADERS: ${request.headers}");
      request.fields.forEach((k, v) => debugPrint("FIELD $k: $v"));
      for (final f in request.files) {
        debugPrint(
          "FILE field=${f.field}, filename=${f.filename}, type=${f.contentType}",
        );
      }

      // 🚀 Send
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("RESPONSE: ${response.body}");

      final decoded = jsonDecode(response.body);

      return decoded is Map<String, dynamic>
          ? decoded
          : {"status": false, "error": response.body};
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> addQuatation({
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
    required String plotArea,
    required List<Map<String, dynamic>> categoryType,
  }) async {
    try {
      final uri = Uri.parse("${Urls.quoteRequestUrl}");
      final request = http.MultipartRequest('POST', uri);

      // 🔐 Headers
      request.headers.addAll({'Authorization': "Bearer ${accessToken ?? ""}"});

      // 🧾 Fields
      request.fields['email'] = email;
      request.fields['name'] = clientName;

      request.fields['code'] = "+91";
      request.fields['projectType'] = projectTypeNAme;

      request.fields['phoneNumber'] = phoneNo;

      request.fields['date'] = date;
      request.fields['budget'] = amount;

      request.fields['pinCode'] = pinCode;
      request.fields['message'] = description;
      request.fields['plotArea'] = plotArea;

      request.fields['builtUpArea'] = buildarea;
      request.fields['builtUpArea'] = buildarea;
      request.fields['categoryType'] = jsonEncode(categoryType);

      // 📎 Optional file
      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath('file', file.path));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      debugPrint(
        "url - $uri \n header  \n---tokenn00---$accessToken body - $request \n response Status - ${response.statusCode} \n response - ${response.body}",
      );
      debugPrint("FIELDS:");
      request.fields.forEach((k, v) => debugPrint("$k : $v"));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {"status": false, "error": response.body};
      }
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> addEstimation({
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
    try {
      final uri = Uri.parse("${Urls.estimationnRequestUrl}");
      final request = http.MultipartRequest('POST', uri);

      // 🔐 Headers
      request.headers.addAll({'Authorization': "Bearer ${accessToken ?? ""}"});

      // 🧾 Fields
      request.fields['email'] = email;
      request.fields['name'] = clientName;
      request.fields['code'] = "+91";
      request.fields['projectType'] = projectTypeNAme;
      request.fields['phoneNumber'] = phoneNo;
      request.fields['date'] = date;
      request.fields['budget'] = amount;
      request.fields['pinCode'] = pinCode;
      request.fields['message'] = description;
      request.fields['builtUpArea'] = buildarea;

      // 📎 Optional file
      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath('file', file.path));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      debugPrint(
        "url - $uri \n header  \n---tokenn00---$accessToken body - $request \n response Status - ${response.statusCode} \n response - ${response.body}",
      );
      debugPrint("FIELDS:");
      request.fields.forEach((k, v) => debugPrint("$k : $v"));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {"status": false, "error": response.body};
      }
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<BrandModel?> getBrandList(BuildContext context) async {
    http.Response? response;
    response = await _getRequest(context: context, url: "${Urls.brandUrl}");
    if (response != null) {
      log("$response");
      return BrandModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<Map<String, dynamic>> addAddress({
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
    try {
      http.Response? response;
      response = await _postRequest(
        context: context,
        url: "${Urls.addAddressUrl}",
        body: {
          "address": address,
          "addressTitle": title,

          "location": jsonEncode({
            "lat": double.parse(lat ?? "0"),
            "lng": double.parse(lng ?? "0"),
          }),
          "name": name,
          "phoneNumber": phone,
          "pinCode": pincode,
        },
      );

      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }
}
