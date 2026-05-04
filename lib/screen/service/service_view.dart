import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youbuilt/custom_widgets/custom_button.dart';
import 'package:youbuilt/providers/signin/project_provider.dart';
import 'package:youbuilt/screen/cart/view_cart.dart';
import 'package:youbuilt/screen/projects/widgets/wallet.dart';
import 'package:youbuilt/utils/encryptPagehlper.dart';

import '../../utils/colors.dart';
import '../sign_up.dart';

class ProductViewSectionPage extends StatefulWidget {
  const ProductViewSectionPage({super.key});

  @override
  State<ProductViewSectionPage> createState() => _ProductViewSectionPageState();
}

class _ProductViewSectionPageState extends State<ProductViewSectionPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = context.read<ProjectProvider>();

      await reg.fetchAddressList(context: context);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,

        title: Text(
          "Service",
          style: TextStyle(
            color: primaryClr,
            fontFamily: "Manrope",
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: false,
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(16),
      //   child: Consumer<ProjectProvider>(
      //     builder: (context, service, _) {
      //       return CustomButton(
      //         text: "Confirm Booking",
      //         onPress: () async{
      //           HapticFeedback.heavyImpact();
      //        await   service.bookNow(
      //             context: context,
      //             name: service.bNameCntrl.text ?? "",
      //             phoneNumber: service.bphoneCntrl.text ?? "",
      //             file: service.bookFile,
      //             serviceId:
      //                 service.serviceViewModel?.data?.id.toString() ?? "",
      //             addressid:
      //                 service.addressListModel?.data?.first?.id.toString() ??
      //                 "",
      //             code: "91",
      //             message: service.bMsgCntrl.text ?? "",
      //             date: "",
      //           );
      //         },
      //       );
      //     },
      //   ),
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Consumer<ProjectProvider>(
          builder: (context, service, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 SERVICE IMAGE
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(14),
                //   child: Image.network(
                //     service.serviceViewModel?.data?.image ?? "",
                //     height: 200,
                //     width: double.infinity,
                //     fit: BoxFit.cover,
                //   ),
                // ),
                Container(
                  height: 200.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Stack(
                    children: [
                      /// IMAGE SLIDER
                      // items.itemLoadingSub
                      //     ? const Center(child: CircularProgressIndicator())
                      //     :
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: CachedNetworkImage(
                          imageUrl: service.serviceViewModel?.data?.image ?? "",
                          fit: BoxFit.fill,
                          height: 180.h,
                          width: double.infinity,
                          placeholder: (_, __) => shimmerBox(
                            height: 200.h,
                            width: double.infinity,
                            radius: 14,
                          ),
                          errorWidget: (_, __, ___) => const Icon(Icons.error),
                        ),
                      ),

                      /// SHARE BUTTON
                      Positioned(
                        top: 10,
                        right: 15,
                        child: GestureDetector(
                          onTap: () async {
                            final productId =
                                service.serviceViewModel?.data?.id ?? "";

                            final encrypted = CryptoHelper.encryptUrl(
                              productId.toString(),
                            );

                            final url =
                                "https://www.youbuilt.in/shop/service/bookig/$encrypted";
                            // "https://www.youbuilt.in/shop/service/bookig/U2FsdGVkX19KVDIbFsFztZsyQ64DTCypvL1IFzMSnx4"
                            await Share.share(
                              url,
                              subject:
                                  service.serviceViewModel?.data?.name ??
                                  "Check this service",
                            );
                          },
                          // onTap: () async {
                          //
                          //   final productId =
                          //       items
                          //           ?.itemListDetailsModel
                          //           ?.data
                          //           ?.storeItemId ??
                          //       "";
                          //   print("-----$productId");
                          //   final encrypted = CryptoHelper.encryptUrl(
                          //     productId.toString(),
                          //   );
                          //
                          //   // ✅ Decrypt and print to verify
                          //   final decoded = Uri.decodeComponent(encrypted);
                          //   print("=== CRYPTO DEBUG ===");
                          //   print("Encrypted (URL encoded): $encrypted");
                          //   print("Encrypted (base64): $decoded");
                          //   print(
                          //     "Decrypted: ${CryptoHelper.decryptUrl(decoded)}",
                          //   );
                          //   print("====================");
                          //
                          //   final url =
                          //       "https://www.youbuilt.biz/shop/purchase/product/$encrypted";
                          //
                          //   if (await canLaunchUrl(Uri.parse(url))) {
                          //     await launchUrl(
                          //       Uri.parse(url),
                          //       mode: LaunchMode.externalApplication,
                          //     );
                          //   }
                          // },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.share, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(httpseight: 16),

                /// 🔹 TITLE + RATING
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        service.serviceViewModel?.data?.name ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: primaryClr,
                          fontFamily: "Manrope",
                        ),
                      ),
                    ),
                    Icon(Icons.star, color: Colors.orange, size: 18),
                    SizedBox(width: 4),
                    Text("0.0"),
                  ],
                ),

                const SizedBox(height: 10),

                /// 🔹 DESCRIPTION
                Text(
                  service.serviceViewModel?.data?.description ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: primaryClr,
                    fontFamily: "Manrope",
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔹 WORK PROCESS
                const Text(
                  "Work Process",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: primaryClr,
                    fontFamily: "Manrope",
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Book your service visit effortlessly. Our expert team will connect with you, assess your site, and present a tailored, competitive quote. Once approved, we handle every detail with precision and care—delivering a seamless experience and handing over the project to you with complete satisfaction.",
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: primaryClr,
                    fontFamily: "Manrope",
                  ),
                ),

                // _bulletPoint(
                //   "Our verified professionals arrive at your location",
                // ),
                // _bulletPoint("Area inspection & cleaning plan confirmation"),
                // _bulletPoint(
                //   "Deep cleaning using professional tools & solutions",
                // ),
                // _bulletPoint("Final quality check and cleanup"),
                const SizedBox(height: 15),
                Divider(color: Color(0xffF4F4F4), thickness: 2),

                /// 🔹 BOOK SERVICE FORM
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffD1D5DB)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Book Your Service",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        hintText: "Full Name",
                        fillColor: Colors.white,
                        controller: service.bNameCntrl,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        hintText: "Phone Number",
                        keyboardType: TextInputType.number,
                        fillColor: Colors.white,
                        controller: service.bphoneCntrl,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Upload Image (If any)",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: "Manrope",
                              fontSize: 14,
                              color: Color(0xff737373),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      uploadFileBox(
                        title: service.bookFile == null
                            ? "Upload file"
                            : service.bookFile!.path.split('/').last,
                        onTap: () {
                          service.pickBookFileSection();
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        hintText: "Message",
                        maxLine: 3,
                        fillColor: Colors.white,
                        controller: service.bMsgCntrl,
                      ),
                      const SizedBox(height: 12),

                      Consumer<ProjectProvider>(
                        builder: (context, service, _) {
                          return CustomButton(
                            text: "Confirm Booking",
                            onPress: () async {
                              HapticFeedback.heavyImpact();
                              await service.bookNow(
                                context: context,
                                name: service.bNameCntrl.text ?? "",
                                phoneNumber: service.bphoneCntrl.text ?? "",
                                file: service.bookFile,
                                serviceId:
                                    service.serviceViewModel?.data?.id
                                        .toString() ??
                                    "",
                                addressid:
                                    service.addressListModel?.data?.first?.id
                                        .toString() ??
                                    "",
                                code: "91",
                                message: service.bMsgCntrl.text ?? "",
                                date: "",
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "• ",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: primaryClr,
              fontFamily: "Manrope",
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: primaryClr,
                fontFamily: "Manrope",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xffF4F4F4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
