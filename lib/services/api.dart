import 'dart:convert';
import 'dart:developer';
import 'dart:io';
// import 'dart:math';math
import 'package:external_path/external_path.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youbuilt/model/activity_model.dart';
import 'package:youbuilt/model/addressListModel.dart';
import 'package:youbuilt/model/approval_model.dart';
import 'package:youbuilt/model/assign_project_model.dart';
import 'package:youbuilt/model/banner_model.dart';
import 'package:youbuilt/model/brandmodel.dart';
import 'package:youbuilt/model/cart_list_model.dart';
import 'package:youbuilt/model/category_dropdown.dart';
import 'package:youbuilt/model/category_list_model.dart';
import 'package:youbuilt/model/countrycode.dart';
import 'package:youbuilt/model/estimaton.dart';
import 'package:youbuilt/model/expense_model.dart';
import 'package:youbuilt/model/invoice_view_model.dart';
import 'package:youbuilt/model/invoice_view_quatation_model.dart';
import 'package:youbuilt/model/item_details.dart';
import 'package:youbuilt/model/item_list_model.dart';
import 'package:youbuilt/model/orderlist_model.dart';
import 'package:youbuilt/model/profile_model.dart';
import 'package:youbuilt/model/project_file_list_model.dart';
import 'package:youbuilt/model/project_list_model.dart';
import 'package:youbuilt/model/project_members.dart';
import 'package:youbuilt/model/project_single_model.dart';
import 'package:youbuilt/model/project_type_model.dart';
import 'package:youbuilt/model/project_view_model.dart';
import 'package:youbuilt/model/projectfolder_model.dart';
import 'package:youbuilt/model/quatation.dart';
import 'package:youbuilt/model/rental.dart';
import 'package:youbuilt/model/rental_book_model.dart';
import 'package:youbuilt/model/rental_cat_model.dart';
import 'package:youbuilt/model/rental_view_model.dart';
import 'package:youbuilt/model/sanp_drop_model.dart';
import 'package:youbuilt/model/search_model.dart';
import 'package:youbuilt/model/seller_model.dart.dart';
import 'package:youbuilt/model/service.dart';
import 'package:youbuilt/model/serviceCatmodel.dart';
import 'package:youbuilt/model/service_booking_model.dart';
import 'package:youbuilt/model/service_detail_model.dart';
import 'package:youbuilt/model/servicemodel.dart';
import 'package:youbuilt/model/serviceviewmodel.dart';
import 'package:youbuilt/model/snaglist_model.dart';
import 'package:youbuilt/model/stage_model.dart';
import 'package:youbuilt/model/subcatgeory_model.dart';
import 'package:youbuilt/model/variation_model.dart';
import 'package:youbuilt/model/wallet_model.dart';

import 'package:youbuilt/services/urls.dart';
import 'package:youbuilt/utils/toast_util.dart';

import '../model/oder_details.dart';
import '../model/service_id_model.dart';
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
      log("$accessToken");
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
    required String code,
  }) async {
    try {
      final response = await _postRequest(
        context: context,
        url: Urls.loginUrl,
        body: {"phoneNumber": phonenumber, "password": pwd, "code": code},
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

  Future<Map<String, dynamic>?> sendForgotOtp({
    required BuildContext context,
    required String? phonenumber,
    required String? code,
  }) async {
    try {
      log("Forgot OTP API called");
      log("Phone Number: $phonenumber");
      log("Code: $code");

      final response = await _postRequest(
        context: context,
        showErrorToast: false,
        url: Urls.fSendOtpUrl,
        body: {"phoneNumber": phonenumber, "code": "+${code}"},
      );

      log("API Response Raw: ${response?.body}");
      log("Status Code: ${response?.statusCode}");

      if (response == null) {
        log("Response is null");
        return null;
      }

      var responseData = jsonDecode(response.body);

      log("Decoded Response: $responseData");

      return {"status": response.statusCode, "data": responseData};
    } catch (e) {
      log("Error in sendForgotOtp: $e");
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

  Future<Map<String, dynamic>?> forgotVerifyOtp({
    required BuildContext context,
    required String? phonenumber,
    required String? code,
    required String? otp,
  }) async {
    try {
      http.Response? response;
      response = await _postRequest(
        context: context,
        url: Urls.fverifyUrl,
        showErrorToast: false,
        body: {"phoneNumber": phonenumber, "code": "+${code}", "otp": otp},
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

  Future<Map<String, dynamic>?> forgotpwdUpdate({
    required BuildContext context,
    required String? phonenumber,
    required String? code,
    required String? pwd,
  }) async {
    try {
      log("📤 Forgot Password Update API Called");
      log("URL: ${Urls.fUpdateOtpUrl}");

      final body = {
        "phoneNumber": phonenumber,
        "code": "${code ?? ""}",
        "password": pwd,
      };

      log("Request Body: $body");

      http.Response? response = await _postRequest(
        context: context,
        url: Urls.fUpdateOtpUrl,
        showErrorToast: false,
        body: body,
      );

      if (response == null) {
        log("❌ Response is NULL");
        return null;
      }

      log("📥 Status Code: ${response.statusCode}");
      log("📥 Response Body: ${response.body}");

      var responseData = jsonDecode(response.body);

      log("📦 Decoded Response: $responseData");

      return {"status": response.statusCode, "data": responseData};
    } catch (e, stackTrace) {
      log("❌ forgotpwdUpdate Exception: $e");
      log("StackTrace: $stackTrace");

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

  Future<SnagListModel?> getSnagList(
    BuildContext context, {
    required String? page,
    required String? limit,
    required String? id,
  }) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url: "${Urls.snaglistUrl}/$id?page=$page&limit=$limit",
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

  Future<Map<String, dynamic>> cartDelete({
    required BuildContext context,

    required String? cartId,
  }) async {
    try {
      http.Response? response;
      response = await _deleteRequest(
        context: context,
        url: "${Urls.cartDeleteUrl}/$cartId",
      );

      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  // Future<Map<String, dynamic>> addExpenses({
  //   required BuildContext context,
  //   required String amount,
  //   required String amountDetails,
  //   required String catId,
  //   required File? file,
  //   required String projectId,
  // }) async {
  //   try {
  //     final uri = Uri.parse("${Urls.addExpenseUrl}/$projectId");
  //     final request = http.MultipartRequest('POST', uri);
  //
  //     // 🔐 Headers
  //     request.headers.addAll({'Authorization': "Bearer ${accessToken ?? ""}"});
  //
  //     // 🧾 Fields
  //     request.fields['amount'] = amount;
  //     request.fields['expenseDetails'] = amountDetails;
  //     request.fields['expenseCategoryId'] = catId;
  //
  //     // 📎 Optional file
  //     if (file != null) {
  //       request.files.add(
  //         await http.MultipartFile.fromPath(
  //           'file', // ✅ match backend
  //           file.path,
  //         ),
  //       );
  //     }
  //
  //     final streamedResponse = await request.send();
  //     final response = await http.Response.fromStream(streamedResponse);
  //     debugPrint(
  //       "url - $uri \n header  \n---tokenn00---$accessToken body - $request \n response Status - ${response.statusCode} \n response - ${response.body}",
  //     );
  //     debugPrint("FIELDS:");
  //     request.fields.forEach((k, v) => debugPrint("$k : $v"));
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return jsonDecode(response.body);
  //     } else {
  //       return {"status": false, "error": response.body};
  //     }
  //   } catch (e) {
  //     return {"status": false, "error": e.toString()};
  //   }
  // }

  Future<Map<String, dynamic>> addFund({
    required BuildContext context,
    required String amount,
    required String details,
    required String date,
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

  Future<Map<String, dynamic>> addExpenses({
    required BuildContext context,
    required String amount,
    required String amountDetails,
    required String catId,
    required String date,
    required File? file,
    required String projectId,
  }) async {
    try {
      final uri = Uri.parse("${Urls.addExpenseUrl}/$projectId");
      final request = http.MultipartRequest('POST', uri);

      // 🔐 Header
      request.headers['Authorization'] = "Bearer ${accessToken ?? ""}";
      print("URLLLL____$uri");
      // 🧾 Fields (EXACT as backend expects)
      request.fields['amount'] = amount;
      request.fields['expenseDetails'] = amountDetails;
      request.fields['expenseCategoryId'] = catId;

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

  Future<WalletModel?> getWalletList(
    BuildContext context,
    String? id,
    String? page,
    String? limit,
  ) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url: "${Urls.walletUrl}/$id?page=$page&limit=$limit",
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
    String? keyword,
  ) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url: "${Urls.itemUrl}?SortBy=&categoryId=$catId&keyword=$keyword",
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
    String? sort,
    // String? pid,
  ) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url:
          "${Urls.itemUrl}?categoryId=$catId&brandId=$brandiid&startPrice=$startPrice&endPrice=$endPrice&sortby=$sort",
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

  Future<CategoryQoutesListModel?> getCategoryQuotes(
    BuildContext context,
  ) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url: "${Urls.catDropdownUrl}",
    );
    if (response != null) {
      log("$response");
      return CategoryQoutesListModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<CartListModel?> getCartList(BuildContext context) async {
    http.Response? response;
    response = await _getRequest(context: context, url: "${Urls.cartlistUrl}");
    if (response != null) {
      log("$response");
      return CartListModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<AssignProjectModel?> getAssignProject(BuildContext context) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url: "${Urls.projectAssignlistUrl}",
    );
    if (response != null) {
      log("$response");
      return AssignProjectModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<ServiceModel?> getServiceList(
    BuildContext context,
    String? id,
    String? keywrd,
  ) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url: "${Urls.serviceUrl}?serviceCategoryId=$id&keyword=$keywrd",
    );
    if (response != null) {
      log("$response");
      return ServiceModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<RentalModel?> getRentalList(
    BuildContext context,
    String? id,
    String? keywrd,
  ) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url: "${Urls.rentalUrl}?rentalCategoryId=$id&keyword=$keywrd",
    );
    if (response != null) {
      log("$response");
      return RentalModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<ServiceCategryListModel?> getServiceCatgryList(
    BuildContext context,
  ) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url: "${Urls.serviceCatUrl}",
    );
    if (response != null) {
      log("$response");
      return ServiceCategryListModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<RentalCategoryModel?> getRentalCatgryList(BuildContext context) async {
    http.Response? response;
    response = await _getRequest(context: context, url: "${Urls.rentalCatUrl}");
    if (response != null) {
      log("$response");
      return RentalCategoryModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<ServiceViewModel?> getServiceView(
    BuildContext context,
    String? id,
  ) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url: "${Urls.serviceViewUrl}/$id",
    );
    if (response != null) {
      log("$response");
      return ServiceViewModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<RentalViewModel?> getRentalView(
    BuildContext context,
    String? id,
  ) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url: "${Urls.rentalViewUrl}/$id",
    );
    if (response != null) {
      log("$response");
      return RentalViewModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<SellerModel?> getSellerList(
    BuildContext context,
    String? id,
    Map attributeMap,
  ) async {
    final uri = Uri.parse(
      "${Urls.sellerUrl}/$id",
    ).replace(queryParameters: {'attributeName': jsonEncode(attributeMap)});

    http.Response? response = await _getRequest(
      context: context,
      url: uri.toString(),
    );

    if (response != null) {
      log("URL: $uri");
      log("Response: ${response.body}");
      return SellerModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<OrderListModel?> getOrderList(
    BuildContext context,
    String? keyword,
  ) async {
    http.Response? response = await _getRequest(
      context: context,
      url: "${Urls.orderUrl}?keyword=$keyword",
    );

    if (response != null) {
      log("Response: ${response.body}");
      return OrderListModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<OrderViewModel?> getOrderView(BuildContext context, String? id) async {
    // final uri = Uri.parse(
    //   "${Urls.sellerUrl}/$id",
    // ).replace(queryParameters: {'attributeName': jsonEncode(attributeMap)});

    http.Response? response = await _getRequest(
      context: context,
      url: "${Urls.orderDetailUrl}/$id",
    );

    if (response != null) {
      // log("URL: $uri");
      log("Response: ${response.body}");
      return OrderViewModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<ServiceBookingModel?> getServiceBookingList(
    BuildContext context,
    // String? id,
  ) async {
    http.Response? response = await _getRequest(
      context: context,
      url: "${Urls.serviceBookingUrl}",
    );

    if (response != null) {
      log("Response: ${response.body}");
      return ServiceBookingModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<SearchModel?> getSearchList(
    BuildContext context,
    String? keyword,
  ) async {
    http.Response? response = await _getRequest(
      context: context,
      url: "${Urls.searchHomeUrl}?keyword=$keyword",
    );

    if (response != null) {
      log("Response: ${response.body}");
      return SearchModel.fromJson(jsonDecode(response.body));
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

  Future<VariationModelModel?> getItemVariation(
    BuildContext context,
    String? itemId,
    Map attributeMap,
  ) async {
    final uri = Uri.parse(
      "${Urls.itemVaraiationUrl}/$itemId",
    ).replace(queryParameters: {'attributeName': jsonEncode(attributeMap)});
    print("object=========1=================>>>>>>>>>>>>>>>>$attributeMap");
    final response = await _getRequest(context: context, url: uri.toString());
    print("object=========3=================>>>>>>>>>>>>>>>>$attributeMap");

    if (response != null) {
      log("Response: ${response.body}");
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
    required File? siteplan,
    required File? boq,
    required File? govtaper,
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
      request.fields['categoryType'] = jsonEncode(categoryType);
      // request.fields['categoryType'] = jsonEncode(categoryType);
      if (file != null) {
        request.files.add(await getMultipartFile(file, 'drawings'));
      }

      if (siteplan != null) {
        request.files.add(await getMultipartFile(siteplan, 'sitePlan'));
      }

      if (govtaper != null) {
        request.files.add(await getMultipartFile(govtaper, 'govPapers'));
      }

      if (boq != null) {
        request.files.add(await getMultipartFile(boq, 'boq'));
      }
      // 📎 Optional file
      // if (file != null) {
      //   request.files.add(await http.MultipartFile.fromPath('file', file.path));
      // }
      // if (siteplan != null) {
      //   request.files.add(
      //     await http.MultipartFile.fromPath('file', siteplan.path),
      //   );
      // }
      // if (govtaper != null) {
      //   request.files.add(
      //     await http.MultipartFile.fromPath('file', govtaper.path),
      //   );
      // }
      // if (boq != null) {
      //   request.files.add(await http.MultipartFile.fromPath('file', boq.path));
      // }

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
      request.fields['location'] = address;
      request.fields['projectType'] = projectTypeNAme;
      request.fields['phoneNumber'] = phoneNo;
      request.fields['date'] = date;
      request.fields['budget'] = amount;
      request.fields['pinCode'] = pinCode;
      request.fields['message'] = description;
      request.fields['builtUpArea'] = buildarea;

      // 📎 Optional file
      if (file != null) {
        final mimeType =
            lookupMimeType(file.path) ?? 'application/octet-stream';
        final mimeParts = mimeType.split('/');

        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            file.path,
            filename: file.path.split('/').last,
            contentType: MediaType(mimeParts[0], mimeParts[1]),
          ),
        );
      }
      print("FIELDS: ${request.fields}");
      print("FILES: ${request.files.length}");
      debugPrint("FILE PATH: ${file?.path}");
      debugPrint("FILE EXISTS: ${await File(file!.path).exists()}");
      debugPrint("FILE SIZE: ${await File(file.path).length()}");
      // final response = await request.send();
      // final respStr = await response.stream.bytesToString();

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("STATUS: ${response.statusCode}");
      // print("BODY: $respStr");
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

  Future<AddressListModel?> getAddressList(BuildContext context) async {
    http.Response? response;
    response = await _getRequest(
      context: context,
      url: "${Urls.addressListUrl}",
    );
    if (response != null) {
      log("$response");
      return AddressListModel.fromJson(jsonDecode(response.body));
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
    required String? phone,
  }) async {
    try {
      http.Response? response = await _postRequest(
        context: context,
        url: Urls.addAddressUrl,
        body: {
          "address": address ?? "",
          "addressTitle": title ?? "",
          "pinCode": pincode ?? "",
          "location": jsonEncode({
            "lat": double.tryParse(lat ?? "") ?? 0.0,
            "lng": double.tryParse(lng ?? "") ?? 0.0,
          }),
          "name": name ?? "",
          "phoneNumber": phone ?? "",
          "code": "91",
        },
      );
      log("---------------------$address,$lat");
      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> addToCart({
    required BuildContext context,
    required String projectId,
    required String storeId,
    required String itemId,
    required String mrp,
    required String qty,
    required String categoryId,
    required String calPrice,
    required List<Map<String, dynamic>> attributeCategory,
    required Map<String, dynamic> attributeName,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        "projectId": projectId,
        "cart": [
          {
            "storeId": storeId,
            "itemId": itemId,
            "mrp": mrp,
            "qty": qty,
            "calculatorPrice": calPrice,
            "categoryId": categoryId,
            "attributecategory": attributeCategory,
            "attributeName": attributeName,
          },
        ],
      };

      /// ✅ PRINT BODY
      print("Add To Cart Request Body:");
      print(jsonEncode(requestBody));

      http.Response? response = await _postRequest(
        context: context,
        url: Urls.cartUrl,
        body: requestBody,
      );

      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      print("Add To Cart Error: $e");
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> buyNow({
    required BuildContext context,
    required String addressid,
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
    try {
      final Map<String, dynamic> requestBody = {
        "grandTotal": grandTotal,
        "addressId": addressid,
        "totalPrice": total,
        "totalcalculatorPrice": calPrice,

        "cart": [
          {
            "storeId": storeId,
            "itemId": itemId,
            "mrp": mrp,
            "qty": qty,
            "calculatorPrice": calPrice,
            "categoryId": categoryId,
            "attributecategory": attributeCategory,
            "attributeName": attributeName,
          },
        ],
      };

      /// ✅ PRINT BODY
      print("Add To Cart Request Body:");
      print(jsonEncode(requestBody));

      http.Response? response = await _postRequest(
        context: context,
        url: Urls.buynowUrl,
        body: requestBody,
      );

      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      print("Add To Cart Error: $e");
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> checkOut({
    required BuildContext context,
    required String projectId,
    required String addressId,
    required String totalprice,
    required String grandprice,
    required String calPrice,
    required List<Map<String, dynamic>> cart,
  }) async {
    try {
      final body = {
        "projectId": projectId,
        "userAddressId": addressId,
        "totalPrice": totalprice,
        "grandTotal": grandprice,
        "totalcalculatorPrice": calPrice,
        "cart": cart,
      };

      // ✅ LOG REQUEST BODY
      debugPrint("========== CHECKOUT REQUEST ==========");
      debugPrint("URL: ${Urls.checkOutUrl}");
      debugPrint("BODY: ${jsonEncode(body)}");
      debugPrint("======================================");

      http.Response? response = await _postRequest(
        context: context,
        url: Urls.checkOutUrl,
        body: body,
      );

      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      // ✅ LOG RESPONSE
      debugPrint("========== CHECKOUT RESPONSE ==========");
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");
      debugPrint("======================================");

      return jsonDecode(response.body);
    } catch (e) {
      debugPrint("CHECKOUT ERROR: $e");
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> addProfile({
    required BuildContext context,
    required String number,
    required String name,
    required File? file,
    required String gender,
    required String email,
    required String gst,
  }) async {
    try {
      final uri = Uri.parse("${Urls.profileEditUrl}");
      final request = http.MultipartRequest('POST', uri);

      // 🔐 Header
      request.headers['Authorization'] = "Bearer ${accessToken ?? ""}";
      print("URLLLL____$uri");
      // 🧾 Fields (EXACT as backend expects)
      request.fields.addAll({
        'phoneNumber': number,
        'code': "+91",
        "name": name,
        "email": email,
        "gender": gender,
        "gst": gst,
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

  Future<Map<String, dynamic>> placeOrder({
    required BuildContext context,
    required String? pid,
    required String? addressId,
    required String? orderId,
    required String? pMethod,
  }) async {
    try {
      http.Response? response;

      // Create body map
      Map<String, dynamic> body = {
        "userAddressId": addressId,
        "paymentMethod": pMethod,
      };

      // Add projectId only if pid is not null
      if (pid != null && pid.isNotEmpty) {
        body["projectId"] = pid;
      }

      response = await _patchRequest(
        context: context,
        url: "${Urls.payementUrl}/$orderId",
        body: body,
      );

      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }
  // Future<Map<String, dynamic>> placeOrder({
  //   required BuildContext context,
  //   required String? pid,
  //   required String? addressId,
  //   required String? orderId,
  //   required String? pMethod,
  // }) async {
  //   try {
  //     http.Response? response;
  //     response = await _patchRequest(
  //       context: context,
  //       url: "${Urls.payementUrl}/$orderId",
  //       body: {
  //         // "projectId": pid,
  //         "userAddressId": addressId,
  //         "paymentMethod": pMethod,
  //       },
  //     );
  //
  //     if (response == null) {
  //       return {"status": false, "error": "No response from server"};
  //     }
  //
  //     return jsonDecode(response.body);
  //   } catch (e) {
  //     return {"status": false, "error": e.toString()};
  //   }
  // }

  Future<Map<String, dynamic>> bookingSection({
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
    try {
      final uri = Uri.parse("${Urls.bookingUrl}");
      final request = http.MultipartRequest('POST', uri);

      // 🔐 Header
      request.headers['Authorization'] = "Bearer ${accessToken ?? ""}";
      print("URLLLL____$uri");
      // 🧾 Fields (EXACT as backend expects)
      request.fields.addAll({
        'serviceId': serviceId,
        'userAddressId': addressid,
        'name': name,
        'code': code,
        'phoneNumber': phoneNumber,
        'message': message,
        'date': date,
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

  Future<Map<String, dynamic>> rentalBooking({
    required BuildContext context,
    required String name,
    required String phoneNumber,
    required String rentalId,
    required String pId,
    required String addressid,
    required String code,
    required String pincode,
    required String message,
    required String date,
  }) async {
    try {
      // Build the request body
      final body = {
        'rentalServiceId': rentalId,
        // 'projectId': pId,
        'userAddressId': addressid,
        'name': name,
        'code': "+${code}",
        'phoneNumber': phoneNumber,
        'message': message,
        'pinCode': pincode,
        'date': date,
      };

      // ✅ Print the body for debugging
      print("Rental Booking Body: $body");

      // Send the request
      http.Response? response = await _postRequest(
        context: context,
        url: "${Urls.bookingRentalUrl}",
        body: body,
      );

      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      print("Rental Booking Error: $e");
      return {"status": false, "error": e.toString()};
    }
  }

  Future<ProjectWithIdModel?> getProjectSingle(
    BuildContext context,
    String? id,
  ) async {
    http.Response? response = await _getRequest(
      context: context,
      url: "${Urls.projectIngleUrl}/$id",
    );

    if (response != null) {
      // log("URL: $uri");
      log("Response: ${response.body}");
      return ProjectWithIdModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<Map<String, dynamic>> updateAddress({
    required BuildContext context,
    required String addressId,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {};

      /// ✅ PRINT BODY

      http.Response? response = await _postRequest(
        context: context,
        url: "${Urls.defaultAddressUrl}/$addressId",
        body: requestBody,
      );

      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      print("Add To  Error: $e");
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> expenseDelete({
    required BuildContext context,

    required String? eid,
  }) async {
    try {
      http.Response? response;
      response = await _deleteRequest(
        context: context,
        url: "${Urls.walletDelete}/$eid",
      );

      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> addressDelete({
    required BuildContext context,

    required String? eid,
  }) async {
    try {
      http.Response? response;
      response = await _deleteRequest(
        context: context,
        url: "${Urls.addressDelete}/$eid",
      );

      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> projectDelete({
    required BuildContext context,

    required String? pid,
  }) async {
    try {
      http.Response? response;
      response = await _deleteRequest(
        context: context,
        url: "${Urls.projectDeleteUrl}/$pid",
      );

      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> editQty({
    required BuildContext context,
    required String? pid,
    required String? qty,
    required String? price,
    required String? calPrice,
  }) async {
    try {
      http.Response? response;
      response = await _patchRequest(
        context: context,
        url: "${Urls.qtyEdit}/$pid",
        body: {"calculatorPrice": calPrice, "mrp": price, "qty": qty},
      );

      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> editProjecct({
    required BuildContext context,
    required String? name,
    required String? pid,
    required String? dueDate,
    required String? budget,
    required String? description,
  }) async {
    try {
      http.Response? response;
      response = await _patchRequest(
        context: context,
        url: "${Urls.projectIngleUrl}/$pid",
        body: {
          "name": name,
          "dueDate": dueDate,
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

  Future<http.StreamedResponse?> editFund({
    required String id,
    required String amount,
    required String details,
    // required String catId,
    required String date,
    File? file,
  }) async {
    try {
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse("${Urls.fundEdit}/$id"),
      );

      request.headers['Authorization'] = "Bearer $accessToken";

      /// fields
      request.fields['amount'] = amount;
      request.fields['details'] = details;
      // request.fields['expenseCategoryId'] = catId;
      request.fields['date'] = date;

      /// file
      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath('file', file.path));
      }

      var response = await request.send();

      final respStr = await response.stream.bytesToString();

      debugPrint("Status : ${response.statusCode}");
      debugPrint("Response : $respStr");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        final jsonResponse = jsonDecode(respStr);
        ToastUtil.show(jsonResponse['message'] ?? "Something went wrong");
        return null;
      }
    } catch (e) {
      log("Edit Expense Error: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>> editAddress({
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
    try {
      http.Response? response;
      response = await _patchRequest(
        context: context,
        url: "${Urls.addressDelete}/$addressId",
        body: {
          "address": address ?? "",
          "addressTitle": title ?? "",
          "pinCode": pincode ?? "",
          "location": jsonEncode({
            "lat": double.tryParse(lat ?? "") ?? 0.0,
            "lng": double.tryParse(lng ?? "") ?? 0.0,
          }),
          "name": name ?? "",
          "phoneNumber": phone ?? "",
          "code": "91",
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

  Future<String?> downloadEstimationPdf(int id) async {
    try {
      final url = Uri.parse("${Urls.downloadUrl}/$id");
      print("$url");
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File("${dir.path}/estimation_$id.pdf");

        await file.writeAsBytes(response.bodyBytes);

        return file.path;
      } else {
        return null;
      }
    } catch (e) {
      print("PDF Error: $e");
      return null;
    }
  }

  // import 'dart:io';
  // import 'package:external_path/external_path.dart';
  // import 'package:permission_handler/permission_handler.dart';

  Future<String?> downloadSnagReport(int id) async {
    try {
      final url = Uri.parse("${Urls.downloadSnagUrl}?projectId=$id");

      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Directory? dir;

        if (Platform.isAndroid) {
          dir = Directory('/storage/emulated/0/Download'); // public Downloads
        } else {
          dir = await getApplicationDocumentsDirectory();
        }

        final file = File("${dir.path}/youbuilt_snag_report_$id.pdf");

        await file.writeAsBytes(response.bodyBytes);

        print("Downloaded: ${file.path}");
        return file.path;
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
  // Future<String?> downloadSnagReport(int id) async {
  //   try {
  //     final url = Uri.parse("${Urls.downloadSnagUrl}?projectId=$id");
  //
  //     final response = await http.get(
  //       url,
  //       headers: {"Authorization": "Bearer $accessToken"},
  //     );
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final dir = await getApplicationDocumentsDirectory();
  //       final file = File("${dir.path}/snag_report_$id.pdf");
  //
  //       await file.writeAsBytes(response.bodyBytes);
  //
  //       print("Report downloaded to: ${file.path}");
  //       return file.path; // return path
  //     } else {
  //       print("Failed to download report");
  //       return null;
  //     }
  //   } catch (e) {
  //     print("PDF Error: $e");
  //     return null;
  //   }
  // }

  // Future<String?> downloadWalletReport(int id) async {
  //   try {
  //     final url = Uri.parse("${Urls.downloadWalletUrl}?projectId=$id");
  //
  //     final response = await http.get(
  //       url,
  //       headers: {"Authorization": "Bearer $accessToken"},
  //     );
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final dir = await getApplicationDocumentsDirectory();
  //       final file = File("${dir.path}/wallet_report_$id.pdf");
  //
  //       await file.writeAsBytes(response.bodyBytes);
  //
  //       print("Report downloaded to: ${file.path}");
  //       return file.path; // return path
  //     } else {
  //       print("Failed to download report");
  //       return null;
  //     }
  //   } catch (e) {
  //     print("PDF Error: $e");
  //     return null;
  //   }
  // }
  // Future<String?> downloadWalletReport(int id) async {
  //   try {
  //     final url = Uri.parse("${Urls.downloadWalletUrl}?projectId=$id");
  //
  //     final response = await http.get(
  //       url,
  //       headers: {"Authorization": "Bearer $accessToken"},
  //     );
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       // ✅ ADD PERMISSION HERE
  //       if (Platform.isAndroid) {
  //         if (!await Permission.manageExternalStorage.isGranted) {
  //           final status = await Permission.manageExternalStorage.request();
  //
  //           if (!status.isGranted) {
  //             print("Storage permission denied");
  //             return null;
  //           }
  //         }
  //       }
  //
  //       // ✅ Get Downloads folder
  //       final path = await ExternalPath.getExternalStoragePublicDirectory(
  //         ExternalPath.DIRECTORY_DOWNLOAD,
  //       );
  //
  //       final file = File("$path/youbuilt_wallet_report_$id.pdf");
  //
  //       await file.writeAsBytes(response.bodyBytes);
  //
  //       print("Downloaded: ${file.path}");
  //       return file.path;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //     return null;
  //   }
  // }null
  Future<String?> downloadWalletReport(int id) async {
    try {
      final url = Uri.parse("${Urls.downloadWalletUrl}?projectId=$id");

      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Directory? dir;

        if (Platform.isAndroid) {
          dir = Directory('/storage/emulated/0/Download'); // public Downloads
        } else {
          dir = await getApplicationDocumentsDirectory();
        }

        final file = File("${dir.path}/youbuilt_wallet_report_$id.pdf");

        await file.writeAsBytes(response.bodyBytes);

        print("Downloaded: ${file.path}");
        return file.path;
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  // Future<String?> downloadOverviewReport(int id) async {
  //   try {
  //     final url = Uri.parse("${Urls.downloadOverviewUrl}/$id");
  //
  //     final response = await http.get(
  //       url,
  //       headers: {"Authorization": "Bearer $accessToken"},
  //     );
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       // ✅ ADD PERMISSION HERE
  //       if (Platform.isAndroid) {
  //         if (!await Permission.manageExternalStorage.isGranted) {
  //           final status = await Permission.manageExternalStorage.request();
  //
  //           if (!status.isGranted) {
  //             print("Storage permission denied");
  //             return null;
  //           }
  //         }
  //       }
  //
  //       // ✅ Get Downloads folder
  //       final path = await ExternalPath.getExternalStoragePublicDirectory(
  //         ExternalPath.DIRECTORY_DOWNLOAD,
  //       );
  //
  //       final file = File("$path/youbuilt_overview_report_$id.pdf");
  //
  //       await file.writeAsBytes(response.bodyBytes);
  //
  //       print("Downloaded: ${file.path}");
  //       return file.path;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //     return null;
  //   }
  // }
  Future<String?> downloadOverviewReport(int id) async {
    try {
      final url = Uri.parse("${Urls.downloadOverviewUrl}/$id");
      // Uri.parse("${Urls.downloadOverviewUrl}/$id");
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Directory? dir;

        if (Platform.isAndroid) {
          dir = Directory('/storage/emulated/0/Download'); // public Downloads
        } else {
          dir = await getApplicationDocumentsDirectory();
        }

        final file = File("${dir.path}/youbuilt_overview_report_$id.pdf");

        await file.writeAsBytes(response.bodyBytes);

        print("Downloaded: ${file.path}");
        return file.path;
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<ServiceDetailsModelNew?> getProjectServiceDEtails(
    BuildContext context,
    String? id,
  ) async {
    http.Response? response = await _getRequest(
      context: context,
      url: "${Urls.projectServiceUrl}/$id",
    );

    if (response != null) {
      // log("URL: $uri");
      log("Response: ${response.body}");
      return ServiceDetailsModelNew.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<ApprovalOederModel?> getApprovals({
    required BuildContext context,
    required String? page,
    required String? limit,
    String? id,
  }) async {
    http.Response? response = await _getRequest(
      context: context,
      url: "${Urls.approvalsUrl}/$id?page=$page&limit=$limit",
    );

    if (response != null) {
      // log("URL: $uri");
      log("Response: ${response.body}");
      return ApprovalOederModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<BannerModel?> getBanner({
    required BuildContext context,
    // required String? page,
    // required String? limit,
    // String? id,id
  }) async {
    http.Response? response = await _getRequest(
      context: context,
      url: "${Urls.bannersUrl}",
    );

    if (response != null) {
      // log("URL: $uri");
      log("Response: ${response.body}");
      return BannerModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<RentalBookListModel?> getRentalBookList({
    required BuildContext context,
    // required String? page,
    // required String? limit,
    // String? id,id
  }) async {
    http.Response? response = await _getRequest(
      context: context,
      url: "${Urls.rentalLidtUrl}",
    );

    if (response != null) {
      // log("URL: $uri");
      log("Response: ${response.body}");
      return RentalBookListModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<InvoiceModel?> getEstimationInvoice(
    BuildContext context,
    String? id,
  ) async {
    http.Response? response = await _getRequest(
      context: context,
      url: "${Urls.viewEstimationUrl}/$id",
    );

    if (response != null) {
      // log("URL: $uri");
      log("Response: ${response.body}");
      return InvoiceModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<InvoiceQyotaionModel?> getQuotationInvoice(
    BuildContext context,
    String? id,
  ) async {
    http.Response? response = await _getRequest(
      context: context,
      url: "${Urls.viewQuotesUrl}/$id",
    );

    if (response != null) {
      // log("URL: $uri");
      log("Response: ${response.body}");
      return InvoiceQyotaionModel.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<ServiceDetailsModelNew?> getServiiceBookDetails(
    BuildContext context,
    String? id,
  ) async {
    http.Response? response = await _getRequest(
      context: context,
      url: "${Urls.serviceDetailUrl}/$id",
    );

    if (response != null) {
      // log("URL: $uri");
      log("Response: ${response.body}");
      return ServiceDetailsModelNew.fromJson(jsonDecode(response.body));
    } else {
      ToastUtil.show("Error in fetching details");
      return null;
    }
  }

  Future<Map<String, dynamic>> estimationStatus({
    required BuildContext context,
    required String? statuss,
    required String? id,
  }) async {
    try {
      http.Response? response;
      response = await _postRequest(
        context: context,
        url: "${Urls.statusEstimationUrl}/$id",
        body: {"status": statuss},
      );

      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> quotationStatus({
    required BuildContext context,
    required String? statuss,
    required String? id,
  }) async {
    try {
      http.Response? response;
      response = await _postRequest(
        context: context,
        url: "${Urls.statusQuotesUrl}/$id",
        body: {"quatationStatus": statuss},
      );

      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<String?> downloadQuotesPdf(int id) async {
    try {
      final url = Uri.parse("${Urls.downloadQotesUrl}/$id");

      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File("${dir.path}/quotation_$id.pdf");

        await file.writeAsBytes(response.bodyBytes);

        return file.path;
      } else {
        return null;
      }
    } catch (e) {
      print("PDF Error: $e");
      return null;
    }
  }

  // Future<String?> downloadInvoicePdf(int orderId, int storeid) async {
  //   try {
  //     final url = Uri.parse("${Urls.downloadInvoiceUrl}/$orderId/$storeid");
  //     print("$url");
  //     final response = await http.get(
  //       url,
  //       headers: {"Authorization": "Bearer $accessToken"},
  //     );
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final dir = await getApplicationDocumentsDirectory();
  //       final file = File("${dir.path}/youbuilt_quotation_$orderId].pdf");
  //
  //       await file.writeAsBytes(response.bodyBytes);
  //
  //       return file.path;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     print("PDF Error: $e");
  //     return null;
  //   }
  // }null
  Future<String?> downloadInvoicePdf(int orderId, int storeid) async {
    try {
      final url = Uri.parse("${Urls.downloadInvoiceUrl}/$orderId/$storeid");

      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Directory? dir;

        if (Platform.isAndroid) {
          dir = Directory('/storage/emulated/0/Download'); // public Downloads
        } else {
          dir = await getApplicationDocumentsDirectory();
        }

        final file = File("${dir.path}/youbuilt_order_invoice_$storeid.pdf");

        await file.writeAsBytes(response.bodyBytes);

        print("Downloaded: ${file.path}");
        return file.path;
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>> serviceStatus({
    required BuildContext context,
    required String? statuss,
    required String? id,
  }) async {
    try {
      http.Response? response;
      response = await _postRequest(
        context: context,
        url: "${Urls.statusServiceUrl}/$id",
        body: {"status": statuss},
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

Future<http.MultipartFile> getMultipartFile(File file, String fieldName) async {
  final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
  final mimeParts = mimeType.split('/');

  return await http.MultipartFile.fromPath(
    fieldName,
    file.path,
    contentType: MediaType(mimeParts[0], mimeParts[1]),
  );
}
