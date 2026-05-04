import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'colors.dart';

/*-----------Url Constants---------------*/
const kBaseUrl = //"https://youbuiltlive-lhph6.ondigitalocean.app/api";
    "https://youbuilt-jrqd6.ondigitalocean.app/api";

/*-----------TextStyle Constants---------------*/
String? tokenfcm;
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
// String? token;
String? userid;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
const accesstokenKey = "accessToken";
const idKey = "Id";
String? accessToken;

String? city = "";
String? state = "";

Future<void> checkForUpdate(BuildContext context) async {
  final newVersion = NewVersionPlus(
    androidId:
        "com.youbuilt.youbuiltcustomer", // replace with your package name
    iOSId: "6760012359", // your App Store ID
  );

  final status = await newVersion.getVersionStatus();

  if (status != null) {
    if (status.canUpdate) {
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        allowDismissal: false,
        dialogTitle: "Update Available",
        dialogText:
            "A newer version (${status.storeVersion}) is available. Please update.",
        updateButtonText: "Update",
        dismissButtonText: "Later",
      );
    }
  }
}
