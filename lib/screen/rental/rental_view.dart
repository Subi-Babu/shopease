import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/custom_widgets/custom_button.dart';
import 'package:youbuilt/providers/signin/project_provider.dart';
import 'package:youbuilt/screen/projects/widgets/wallet.dart';

import '../../utils/colors.dart';
import '../sign_up.dart';

class RentalPageView extends StatefulWidget {
  const RentalPageView({super.key});

  @override
  State<RentalPageView> createState() => _RentalPageViewState();
}

class _RentalPageViewState extends State<RentalPageView> {
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
          "Rental",
          style: TextStyle(
            color: primaryClr,
            fontFamily: "Manrope",
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: false,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<ProjectProvider>(
          builder: (context, service, _) {
            return CustomButton(
              text: "Confirm Booking",
              onPress: () async {
                HapticFeedback.heavyImpact();
                await service.rentalbook(
                  context: context,
                  name: service.rNameCntrl.text ?? "",
                  phoneNumber: service.rphoneCntrl.text ?? "",

                  rentalId: service.rentalViewModel?.data?.id.toString() ?? "",
                  addressid:
                      service.addressListModel?.data?.first?.id.toString() ??
                      "",
                  code: "91",
                  message: service.rMsgCntrl.text ?? "",
                  date: "",
                  pincode:
                      service.addressListModel?.data?.first?.pinCode
                          .toString() ??
                      "",
                  pId: "",
                );
                service.rNameCntrl.clear();
                service.rphoneCntrl.clear();
                service.rMsgCntrl.clear();
              },
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Consumer<ProjectProvider>(
          builder: (context, service, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 SERVICE IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    service.rentalViewModel?.data?.image ?? "",
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔹 TITLE + RATING
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        service.rentalViewModel?.data?.name ?? "",
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
                  service.rentalViewModel?.data?.description ?? "",
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

                _bulletPoint(
                  "Our verified professionals arrive at your location",
                ),
                _bulletPoint("Area inspection & cleaning plan confirmation"),
                _bulletPoint(
                  "Deep cleaning using professional tools & solutions",
                ),
                _bulletPoint("Final quality check and cleanup"),

                const SizedBox(height: 24),
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
                        "Book Rental",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        hintText: "Full Name",
                        fillColor: Colors.white,
                        controller: service.rNameCntrl,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        hintText: "Phone Number",
                        keyboardType: TextInputType.number,
                        fillColor: Colors.white,
                        controller: service.rphoneCntrl,
                      ),

                      const SizedBox(height: 12),
                      CustomTextField(
                        hintText: "Message",
                        maxLine: 3,
                        fillColor: Colors.white,
                        controller: service.rMsgCntrl,
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
}
