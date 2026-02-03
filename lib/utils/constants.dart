import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

/*-----------Url Constants---------------*/
const kBaseUrl = "https://youbuilt-jrqd6.ondigitalocean.app/api";

/*-----------TextStyle Constants---------------*/
const f16B = TextStyle(
  color: primaryClr,
  fontSize: 16,
  fontWeight: FontWeight.bold,
  overflow: TextOverflow.ellipsis,
);

/*-----------Widget Constants---------------*/
const kSpacer = SizedBox(height: 10);
const kLoading = Center(child: CircularProgressIndicator(color: primaryClr));

/*-----------String Constants---------------*/
// const String kKeyAccessToken = "access_token";
const String kKeyLocationDb = "location_db";
String? token;
String? userid;

const accesstokenKey = "accessToken";
const idKey = "Id";
// const accesstokenKey ="accessToken";
String? accessToken;
