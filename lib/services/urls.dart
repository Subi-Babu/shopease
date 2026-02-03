import 'package:youbuilt/utils/constants.dart';

class Urls {
  static String loginUrl = "$kBaseUrl/users/signIn";
  static String signUpUrl = "$kBaseUrl/users/signUp";
  static String countryCodeUrl = "$kBaseUrl/users/countryCodeDropDown";
  static String sendOtpUrl = "$kBaseUrl/users/userSendOtp";
  static String verifyOtpUrl = "$kBaseUrl/users/userVerifyOtp";
  static String resendOtpUrl = "$kBaseUrl/users/userResendOtp";
  static String addProjectUrl = "$kBaseUrl/users/project";
  static String projectListUrl = "$kBaseUrl/users/projectList";
  static String projectViewListUrl = "$kBaseUrl/users/project";
  static String projectMemberUrl = "$kBaseUrl/users/getMembers";
  static String projectInviteUrl = "$kBaseUrl/users/addMember";
  static String snagDropUrl = "$kBaseUrl/users/snagStatusDropDown";
  static String snagAddUrl = "$kBaseUrl/users/addSnagList";
  static String snaglistUrl = "$kBaseUrl/users/getSnagList";
  static String snagUpdateUrl = "$kBaseUrl/users/updateSnagList";
  static String snagdeleteUrl = "$kBaseUrl/users/deleteSnagList";
  static String addExpenseUrl = "$kBaseUrl/users/addExpenses";
  static String addFundUrl = "$kBaseUrl/users/addMoney";
  static String exCategoryUrl = "$kBaseUrl/users/expenseCategoryDropDown";
  static String walletUrl = "$kBaseUrl/users/getMoneyandExpenses";
}
