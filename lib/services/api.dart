import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart' as path;
import 'package:youbuilt/model/countrycode.dart';
import 'package:youbuilt/model/expense_model.dart';
import 'package:youbuilt/model/project_list_model.dart';
import 'package:youbuilt/model/project_members.dart';
import 'package:youbuilt/model/project_view_model.dart';
import 'package:youbuilt/model/sanp_drop_model.dart';
import 'package:youbuilt/model/snaglist_model.dart';
import 'package:youbuilt/model/wallet_model.dart';

import 'package:youbuilt/services/urls.dart';
import 'package:youbuilt/utils/toast_util.dart';

import '../screen/login.dart';
import '../utils/constants.dart';

class NetworkHelper {
  var _dio = Dio();

  ///////////////////////////
  Future<http.Response?> _getRequest({
    required BuildContext context,
    required String url,
    Map<String, String>? header,
  }) async {
    // bool isConnected = await checkNetworkConnectivity();
    //
    // if (!isConnected) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const ConnectivityCheckScreen(),
    //     ),
    //   );
    //   return null;
    // }

    http.Response response;

    try {
      response = await http.get(
        Uri.parse(url),
        headers:
            header ??
            {
              'Content-Type': 'application/json',
              'Authorization': "Bearer ${token ?? ""}",
            },
      );

      debugPrint(
        "url - $url \n header - $header \ntoken---$token response Status - ${response.statusCode} \n response - ${response.body}",
      );
      debugPrint("tokennn ----$token");

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

  Future<http.Response?> _postRequest({
    required BuildContext context,
    required String url,
    required dynamic body,
    Map<String, String>? header,
  }) async {
    // bool isConnected = await checkNetworkConnectivity();
    //
    // if (!isConnected) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const ConnectivityCheckScreen(),
    //     ),
    //   );
    //   return null;
    // }

    http.Response? response;

    try {
      response = await http.post(
        Uri.parse(url),
        headers:
            header ??
            {
              'Content-Type': 'application/json',
              'Authorization': "Bearer ${token ?? ""}",
            },
        body: jsonEncode(body),
      );

      debugPrint(
        "url - $url \n header - $header \n---tokenn00---$token body - $body \n response Status - ${response.statusCode} \n response - ${response.body}",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else if ((response.statusCode == 401 || response.statusCode == 403)) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        ToastUtil.show("${jsonResponse['error'] ?? "Something went wrong!"}");
        Future.delayed(Duration.zero).then(
          (value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          ),
        );
        return null;
      } else {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        ToastUtil.show("${jsonResponse['message'] ?? "Something went wrong!"}");
        return null;
      }
    } on Exception catch (e) {
      log("error message-----$e");
    }
    return null;
  }

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
              'Authorization': "Bearer ${token ?? ""}",
            },
        body: jsonEncode(body),
      );

      debugPrint(
        "PATCH url - $url\n"
        "header - $header\n"
        "token - $token\n"
        "body - $body\n"
        "status - ${response.statusCode}\n"
        "response - ${response.body}",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
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
              'Authorization': "Bearer ${token ?? ""}",
            },
      );

      debugPrint(
        "DELETE url - $url\n"
        "header - $header\n"
        "token - $token\n"
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

  Future<Map<String, dynamic>> login({
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
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> sendOtp({
    required BuildContext context,
    required String? phonenumber,
    required String? code,
  }) async {
    try {
      http.Response? response;
      response = await _postRequest(
        context: context,
        url: Urls.sendOtpUrl,
        body: {"phoneNumber": phonenumber, "code": code},
      );

      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
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
        body: {"phoneNumber": phonenumber, "code": code, "otp": otp},
      );

      if (response == null) {
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> resendOtp({
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
        return {"status": false, "error": "No response from server"};
      }

      return jsonDecode(response.body);
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
    response = await _getRequest(
      context: context,
      url: "${Urls.countryCodeUrl}",
    );
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
    response = await _getRequest(context: context, url: "${Urls.snagDropUrl}");
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
    response = await _getRequest(
      context: context,
      url: "${Urls.exCategoryUrl}",
    );
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
      request.headers.addAll({'Authorization': "Bearer ${token ?? ""}"});

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
        "url - $uri \n header  \n---tokenn00---$token body - $request \n response Status - ${response.statusCode} \n response - ${response.body}",
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
      request.headers['Authorization'] = "Bearer ${token ?? ""}";

      // 🧾 Fields (EXACT as backend expects)
      request.fields.addAll({
        'amount': amount,
        'details': details,
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
}
