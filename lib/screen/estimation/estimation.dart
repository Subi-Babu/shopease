import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/custom_widgets/custom_button.dart';
import 'package:youbuilt/providers/signin/project_provider.dart';
import 'package:youbuilt/screen/estimation/invoice_page.dart';
import 'package:youbuilt/screen/projects/widgets/wallet.dart';
import 'package:youbuilt/screen/sign_up.dart';
import 'package:youbuilt/utils/colors.dart';

import '../../model/category_dropdown.dart';
import '../../model/expense_model.dart';
import '../../model/project_type_model.dart';
import '../../utils/toast_util.dart';

final _formKey = GlobalKey<FormState>();

class EstimationPage extends StatefulWidget {
  const EstimationPage({super.key});

  @override
  State<EstimationPage> createState() => _EstimationPageState();
}

class _EstimationPageState extends State<EstimationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = Provider.of<ProjectProvider>(context, listen: false);
      reg.fetchEstimation(context: context);
      reg.fetchQuatation(context: context);
      reg.fetchProfile(context: context);
      reg.fetchProjectType(context: context);
      reg.fetchCategoryDropdown(context: context);
    });
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          "Quotation & Estimation",
          style: TextStyle(
            color: primaryClr,
            fontFamily: "Manrope",
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          unselectedLabelColor: const Color(0xff737373),
          indicatorColor: const Color(0xffFF3B30),
          labelColor: primaryClr,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          labelStyle: TextStyle(
            fontFamily: "Manrope",
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
          tabs: const [
            Tab(text: "Estimation"),
            Tab(text: "Quotation"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_estimationTab(), _quoteTab()],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomButton(
          text: _tabController.index == 0 ? "Get Estimation" : "Get Quotation",
          onPress: () {
            if (_tabController.index == 0) {
              // Estimation action
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EstimationRequestPage(),
                ),
              );
              // _openEstimationBottomSheet(context);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuotationRequestPage(),
                ),
              );
              // Quotation action
            }
          },
        ),
      ),
    );
  }
}

// void _openEstimationBottomSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.white,
//     builder: (context) {
//       return Container(
//         padding: EdgeInsets.only(
//           left: 16,
//           right: 16,
//           top: 12,
//           bottom: MediaQuery.of(context).viewInsets.bottom + 16,
//         ),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: SingleChildScrollView(
//           child: Consumer<ProjectProvider>(
//             builder: (context, project, _) {
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Container(
//                       width: 40,
//                       height: 4,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade300,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: Icon(Icons.arrow_back),
//                       ),
//                       SizedBox(width: 5),
//                       const Text(
//                         "Estimation Request",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontFamily: "Manrope",
//                           fontSize: 18,
//                           color: primaryClr,
//                         ),
//                       ),
//                       // primaryClrSpacer(),
//                       // InkWell(
//                       //   onTap: () => Navigator.pop(context),
//                       //   child: const Icon(Icons.close, color: Colors.grey),
//                       // ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Content
//                   Consumer<ProjectProvider>(
//                     builder: (context, project, _) {
//                       return Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           CustomTextField(
//                             hintText: "Client Full Name",
//                             fillColor: Colors.white,
//                             controller: project.nameClientCntrl,
//                           ),
//                           const SizedBox(height: 10),
//                           CustomTextField(
//                             hintText: "Email",
//                             fillColor: Colors.white,
//                             controller: project.emailCntrl,
//                           ),
//                           const SizedBox(height: 10),
//
//                           CustomTextField(
//                             hintText: "Phone Number",
//                             fillColor: Colors.white,
//                             keyboardType: TextInputType.number,
//                             controller: project.phoneClientCntrl,
//                           ),
//                           const SizedBox(height: 10),
//                           CustomTextField(
//                             hintText: "Pin Code",
//                             fillColor: Colors.white,
//                             controller: project.pincodeCntrl,
//                           ),
//                           const SizedBox(height: 10),
//                           CustomTextField(
//                             hintText: "Address",
//                             fillColor: Colors.white,
//                             controller: project.addressCntrl,
//                           ),
//                           const SizedBox(height: 10),
//                           Container(
//                             height: 48,
//                             width: double.infinity,
//                             padding: const EdgeInsets.symmetric(horizontal: 8),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(6),
//                               color: Colors.white,
//                               border: Border.all(color: Colors.grey.shade300),
//                             ),
//                             child: DropdownButtonHideUnderline(
//                               child: DropdownButton<ProjectTypeDropDown>(
//                                 value: project.selectedProjectType,
//                                 style: TextStyle(
//                                   color: primaryClr,
//                                   fontSize: 18,
//                                   fontFamily: "Manrope",
//
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                                 hint: const Text(
//                                   "Project Type",
//
//                                   style: TextStyle(
//                                     color: Color(0xFFCACACA),
//                                     fontSize: 14,
//                                     fontFamily: "Manrope",
//
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 icon: const Icon(
//                                   Icons.keyboard_arrow_down,
//                                   size: 20,
//                                 ),
//                                 isExpanded: true,
//                                 items:
//                                     project
//                                         .projectTypeModel
//                                         ?.projectTypeDropDown
//                                         ?.map((e) {
//                                           return DropdownMenuItem<
//                                             ProjectTypeDropDown
//                                           >(
//                                             value: e,
//                                             child: Text(
//                                               e.label ?? "",
//                                               style: const TextStyle(
//                                                 fontSize: 14,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                           );
//                                         })
//                                         .toList() ??
//                                     [],
//                                 onChanged: (value) {
//                                   if (value != null) {
//                                     project.setProjectType(value);
//                                   }
//                                 },
//                               ),
//                             ),
//                           ),
//                           // CustomTextField(
//                           //   hintText: "Project Type",
//                           //   fillColor: Colors.white,
//                           //   // controller: project.detailsFundCtrl,
//                           // ),
//                           const SizedBox(height: 10),
//                           CustomTextField(
//                             hintText: "Built-up Area (sqm)",
//                             fillColor: Colors.white,
//                             controller: project.buildareaCntrl,
//                           ),
//                           const SizedBox(height: 10),
//                           // CustomTextField(
//                           //   hintText: "Plot Area (sqm)",
//                           //   fillColor: Colors.white,
//                           //   // controller: project.detailsFundCtrl,
//                           // ),
//                           // const SizedBox(height: 10),
//                           CustomTextField(
//                             hintText: "Budget Amount",
//                             fillColor: Colors.white,
//                             controller: project.budgetAmountCntrl,
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             "Upload Documents / Drawings",
//                             style: TextStyle(
//                               fontFamily: "Manrope",
//                               fontWeight: FontWeight.w500,
//                               fontSize: 14,
//                               height: 2,
//                               color: Color(0xff737373),
//                             ),
//                           ),
//
//                           uploadFileBox(
//                             title: project.estimationFile == null
//                                 ? "Upload file"
//                                 : project.estimationFile!.path.split('/').last,
//                             onTap: () {
//                               project.pickEstimationFileSection();
//                             },
//                           ),
//                           const SizedBox(height: 10),
//
//                           CustomTextField(
//                             hintText: "Description",
//                             fillColor: Colors.white,
//                             maxLine: 4,
//                             controller: project.descriptionCntrl,
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 10),
//
//                   CustomButton(
//                     text: "Request",
//                     onPress: project.expense
//                         ? null
//                         : () {
//                             if (project.selectedProjectType == null) {
//                               ToastUtil.show("Select project type");
//                               return;
//                             }
//                             project.addEstimationReq(
//                               context: context,
//                               date: DateFormat(
//                                 'dd-MM-yyyy',
//                               ).format(DateTime.now()),
//                               description: project.descriptionCntrl.text,
//                               amount: project.budgetAmountCntrl.text,
//                               address: project.addressCntrl.text,
//                               buildarea: project.buildareaCntrl.text,
//                               clientName: project.nameClientCntrl.text,
//                               email: project.emailCntrl.text,
//                               phoneNo: project.phoneClientCntrl.text,
//                               pinCode: project.pincodeCntrl.text,
//                               projectTypeNAme: project.projectTypeName
//                                   .toString(),
//                               file:
//                                   (project.estimationFile != null &&
//                                       project.estimationFile!.path.isNotEmpty)
//                                   ? project.estimationFile
//                                   : null,
//                             );
//                             project.descriptionCntrl.clear();
//                             project.phoneClientCntrl.clear();
//                             project.nameClientCntrl.clear();
//                             project.emailCntrl.clear();
//                             project.addressCntrl.clear();
//                             project.pincodeCntrl.clear();
//                             project.descriptionCntrl.clear();
//                             project.buildareaCntrl.clear();
//                             project.budgetAmountCntrl.clear();
//                             project.estimationFile = null;
//                             project.projectTypeName = null;
//                             project.selectedProjectType = null;
//                           },
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       );
//     },
//   );
// }

// void _openQuatationBottomSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.white,
//     builder: (context) {
//       return Container(
//         padding: EdgeInsets.only(
//           left: 12,
//           right: 12,
//           top: 12,
//           bottom: MediaQuery.of(context).viewInsets.bottom + 16,
//         ),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Container(
//                     width: 40,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Icon(Icons.arrow_back),
//                     ),
//                     SizedBox(width: 5),
//                     const Text(
//                       "Quotation Request",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontFamily: "Manrope",
//                         fontSize: 18,
//                         color: primaryClr,
//                       ),
//                     ),
//                     // SizedBoxpacer(),
//                     // InkWell(
//                     //   onTap: () => Navigator.pop(context),
//                     //   child: const Icon(Icons.close, color: Colors.grey),
//                     // ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//
//                 // Content
//                 Consumer<ProjectProvider>(
//                   builder: (context, project, _) {
//                     return Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomTextField(
//                           hintText: "Client Full Name",
//                           fillColor: Colors.white,
//                           controller: project.qnameClientCntrl,
//                           validator: (value) {
//                             if (value == null || value.trim().isEmpty) {
//                               return "Client name is required";
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 10),
//                         CustomTextField(
//                           hintText: "Email",
//                           fillColor: Colors.white,
//                           controller: project.qemailCntrl,
//                         ),
//                         const SizedBox(height: 10),
//
//                         CustomTextField(
//                           hintText: "Phone Number",
//                           fillColor: Colors.white,
//                           keyboardType: TextInputType.number,
//                           controller: project.qphoneClientCntrl,
//                           validator: (value) {
//                             if (value == null || value.trim().isEmpty) {
//                               return "phone number is required";
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 10),
//                         CustomTextField(
//                           hintText: "Pin Code",
//                           fillColor: Colors.white,
//                           keyboardType: TextInputType.number,
//                           validator: (value) {
//                             if (value == null || value.trim().isEmpty) {
//                               return "pincode is required";
//                             }
//                             return null;
//                           },
//
//                           controller: project.qpincodeCntrl,
//                         ),
//                         const SizedBox(height: 10),
//                         CustomTextField(
//                           hintText: "Address",
//                           fillColor: Colors.white,
//                           controller: project.qaddressCntrl,
//                         ),
//                         const SizedBox(height: 10),
//                         Container(
//                           height: 48,
//                           width: double.infinity,
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(6),
//                             color: Colors.white,
//                             border: Border.all(color: Colors.grey.shade300),
//                           ),
//                           child: DropdownButtonHideUnderline(
//                             child: DropdownButton<ProjectTypeDropDown>(
//                               value: project.selectedqProjectType,
//                               hint: const Text(
//                                 "Project Type",
//                                 style: TextStyle(
//                                   color: Color(0xFFCACACA),
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               icon: const Icon(
//                                 Icons.keyboard_arrow_down,
//                                 size: 20,
//                               ),
//                               isExpanded: true,
//                               items:
//                                   project.projectTypeModel?.projectTypeDropDown
//                                       ?.map((e) {
//                                         return DropdownMenuItem<
//                                           ProjectTypeDropDown
//                                         >(
//                                           value: e,
//                                           child: Text(
//                                             e.label ?? "",
//                                             style: const TextStyle(
//                                               fontSize: 14,
//                                               color: Colors.black,
//                                             ),
//                                           ),
//                                         );
//                                       })
//                                       .toList() ??
//                                   [],
//
//                               onChanged: (value) {
//                                 if (value != null) {
//                                   project.setQuoteProjectType(value);
//                                 }
//                               },
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         CustomTextField(
//                           hintText: "Built-up Area (sqm)",
//                           fillColor: Colors.white,
//                           controller: project.qbuildareaCntrl,
//                           validator: (value) {
//                             if (value == null || value.trim().isEmpty) {
//                               return "built-up area is required";
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 10),
//                         CustomTextField(
//                           hintText: "Plot Area (sqm)",
//                           fillColor: Colors.white,
//                           controller: project.qplotCntrl,
//                           validator: (value) {
//                             if (value == null || value.trim().isEmpty) {
//                               return "plot area is required";
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 10),
//                         CustomTextField(
//                           hintText: "Budget Amount",
//                           fillColor: Colors.white,
//                           controller: project.qbudgetAmountCntrl,
//                           validator: (value) {
//                             if (value == null || value.trim().isEmpty) {
//                               return "budget amount is required";
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 10),
//
//                         // Text(
//                         //   "Upload Documents / Drawings",
//                         //   style: TextStyle(
//                         //     fontFamily: "Manrope",
//                         //     fontWeight: FontWeight.w500,
//                         //     fontSize: 14,
//                         //     height: 2,
//                         //     color: Color(0xff737373),
//                         //   ),
//                         // ),
//                         //
//                         // uploadFileBox(
//                         //   title: project.fundFile == null
//                         //       ? "Upload file"
//                         //       : project.fundFile!.path.split('/').last,
//                         //   onTap: () {
//                         //     // project.pickFundFile();
//                         //   },
//                         // ),
//                         // const SizedBox(height: 10),
//                         CustomTextField(
//                           hintText: "Description",
//                           fillColor: Colors.white,
//                           maxLine: 4,
//                           controller: project.qdescriptionCntrl,
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 10),
//
//                 CustomButton(
//                   text: "Next",
//                   borderSide: BorderSide(color: primaryClr),
//                   bgColor: Colors.white,
//                   textColor: primaryClr,
//                   onPress: () {
//                     if (_formKey.currentState!.validate()) {
//                       // Navigator.pop(context); // close first sheet
//                       Future.delayed(Duration(milliseconds: 200), () {
//                         _openQuatationBottomSheet2(
//                           context,
//                         ); // open second sheet
//                       });
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
//
// void _openQuatationBottomSheet2(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.white,
//     builder: (context) {
//       return Container(
//         padding: EdgeInsets.only(
//           left: 12,
//           right: 12,
//           top: 12,
//           bottom: MediaQuery.of(context).viewInsets.bottom + 16,
//         ),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Container(
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Icon(Icons.arrow_back),
//                   ),
//                   SizedBox(width: 5),
//                   const Text(
//                     "Quotation Request",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontFamily: "Manrope",
//                       fontSize: 18,
//                       color: primaryClr,
//                     ),
//                   ),
//                   // Spacer(),
//                   // InkWell(
//                   //   onTap: () => Navigator.pop(context),
//                   //   child: const Icon(Icons.close, color: Colors.grey),
//                   // ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//
//               // Content
//               Consumer<ProjectProvider>(
//                 builder: (context, project, _) {
//                   return Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // _dragHandle(),
//                       // _header(context),
//                       ListView(
//                         shrinkWrap: true, // Add this
//                         physics: NeverScrollableScrollPhysics(), // Add this
//                         // padding: const EdgeInsets.all(16),
//                         // controller: ScrollController(),
//                         padding: const EdgeInsets.all(10),
//                         children: [
//                           // _dropdownField(),
//                           Container(
//                             padding: EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10),
//                               border: Border.all(color: Color(0xffDFDFDF)),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   height: 48,
//                                   width: double.infinity,
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 8,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(6),
//                                     color: Colors.white,
//                                     border: Border.all(
//                                       color: Colors.grey.shade300,
//                                     ),
//                                   ),
//                                   child: DropdownButtonHideUnderline(
//                                     child: DropdownButton<CategoryDropDown>(
//                                       value: project.selectedCategory,
//                                       hint: const Text(
//                                         "Category Type",
//                                         style: TextStyle(
//                                           color: Color(0xFFCACACA),
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                       icon: const Icon(
//                                         Icons.keyboard_arrow_down,
//                                         size: 20,
//                                       ),
//                                       isExpanded: true,
//                                       items:
//                                           project
//                                               .categoryDropDown
//                                               ?.categoryDropDown
//                                               ?.map((e) {
//                                                 return DropdownMenuItem<
//                                                   CategoryDropDown
//                                                 >(
//                                                   value: e,
//                                                   child: Text(
//                                                     e.label ?? "",
//                                                     style: const TextStyle(
//                                                       fontSize: 14,
//                                                       color: Colors.black,
//                                                     ),
//                                                   ),
//                                                 );
//                                               })
//                                               .toList() ??
//                                           [],
//                                       onChanged: (value) {
//                                         if (value != null) {
//                                           project.setSelectedCategoryQuotes(
//                                             value,
//                                           );
//                                         }
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 10),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: CustomTextField(
//                                         hintText: "Enter Count",
//                                         fillColor: Colors.white,
//                                         keyboardType: TextInputType.number,
//                                         controller: project.numberCtrl,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 12),
//                                     SizedBox(
//                                       height: 45,
//                                       child: OutlinedButton.icon(
//                                         onPressed: () {
//                                           project.addCategoryItem();
//                                         },
//                                         icon: const Icon(Icons.add),
//                                         label: const Text(
//                                           "Add",
//                                           style: TextStyle(color: primaryClr),
//                                         ),
//                                         style: OutlinedButton.styleFrom(
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(
//                                               8,
//                                             ),
//                                           ),
//                                           side: const BorderSide(
//                                             color: Colors.black,
//                                           ), // optional
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: const Color(0xffF4F4F4),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: project.addedCategoryItems.isEmpty
//                                 ? const Text(
//                                     "No items added",
//                                     style: TextStyle(color: Colors.grey),
//                                   )
//                                 : Column(
//                                     children: List.generate(
//                                       project.addedCategoryItems.length,
//                                       (index) {
//                                         final item =
//                                             project.addedCategoryItems[index];
//                                         return Container(
//                                           margin: const EdgeInsets.only(
//                                             bottom: 8,
//                                           ),
//                                           padding: const EdgeInsets.symmetric(
//                                             horizontal: 12,
//                                             vertical: 10,
//                                           ),
//                                           decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             borderRadius: BorderRadius.circular(
//                                               8,
//                                             ),
//                                           ),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Text(
//                                                 item.category.label ?? "",
//                                                 style: const TextStyle(
//                                                   fontWeight: FontWeight.w600,
//                                                 ),
//                                               ),
//                                               Row(
//                                                 children: [
//                                                   Text(
//                                                     "x${item.count}",
//                                                     style: const TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.w500,
//                                                     ),
//                                                   ),
//                                                   const SizedBox(width: 12),
//                                                   GestureDetector(
//                                                     onTap: () {
//                                                       project
//                                                           .removeCategoryItem(
//                                                             index,
//                                                           );
//                                                     },
//                                                     child: const Icon(
//                                                       Icons.delete,
//                                                       color: Colors.red,
//                                                       size: 20,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                           ),
//
//                           const SizedBox(height: 10),
//                           Text(
//                             "Upload Govt Papers (IF available)",
//                             style: TextStyle(
//                               fontFamily: "Manrope",
//                               fontWeight: FontWeight.w500,
//                               fontSize: 14,
//                               height: 2,
//                               color: Color(0xff737373),
//                             ),
//                           ),
//
//                           uploadFileBox(
//                             title: project.govtPaper == null
//                                 ? "Upload file"
//                                 : project.govtPaper!.path.split('/').last,
//                             onTap: () {
//                               project.pickGovtFile();
//                             },
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             "Upload BOQ (IF available)",
//                             style: TextStyle(
//                               fontFamily: "Manrope",
//                               fontWeight: FontWeight.w500,
//                               fontSize: 14,
//                               height: 2,
//                               color: Color(0xff737373),
//                             ),
//                           ),
//
//                           uploadFileBox(
//                             title: project.boqFile == null
//                                 ? "Upload file"
//                                 : project.boqFile!.path.split('/').last,
//                             onTap: () {
//                               project.pickBOQFile();
//                             },
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             "Upload Drawings",
//                             style: TextStyle(
//                               fontFamily: "Manrope",
//                               fontWeight: FontWeight.w500,
//                               fontSize: 14,
//                               height: 2,
//                               color: Color(0xff737373),
//                             ),
//                           ),
//
//                           uploadFileBox(
//                             title: project.drwaings == null
//                                 ? "Upload file"
//                                 : project.drwaings!.path.split('/').last,
//                             onTap: () {
//                               project.pickDrawingsFile();
//                             },
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             "Upload Site Plan",
//                             style: TextStyle(
//                               fontFamily: "Manrope",
//                               fontWeight: FontWeight.w500,
//                               fontSize: 14,
//                               height: 2,
//                               color: Color(0xff737373),
//                             ),
//                           ),
//
//                           uploadFileBox(
//                             title: project.sitePlan == null
//                                 ? "Upload file"
//                                 : project.sitePlan!.path.split('/').last,
//                             onTap: () {
//                               project.pickSitePlanFile();
//                             },
//                           ),
//                           const SizedBox(height: 10),
//                         ],
//                       ),
//                     ],
//                   );
//                 },
//               ),
//               const SizedBox(height: 10),
//
//               Row(
//                 children: [
//                   Expanded(
//                     child: CustomButton(
//                       text: "Previous",
//                       borderSide: BorderSide(color: primaryClr),
//                       bgColor: Colors.white,
//                       textColor: primaryClr,
//                       onPress: () {
//                         Future.delayed(Duration(milliseconds: 200), () {
//                           _openQuatationBottomSheet(
//                             context,
//                           ); // reopen first sheet
//                         });
//                       },
//                     ),
//                   ),
//                   SizedBox(width: 5),
//                   Expanded(
//                     child: Consumer<ProjectProvider>(
//                       builder: (context, project, _) {
//                         return CustomButton(
//                           text: "Request",
//                           onPress: () async {
//                             await project.addQuatationReq(
//                               context: context,
//                               amount: project.qbudgetAmountCntrl.text ?? "",
//                               email: project.qemailCntrl.text ?? "",
//                               phoneNo: project.qphoneClientCntrl.text ?? "",
//                               pinCode: project.qpincodeCntrl.text ?? "",
//                               address: project.qaddressCntrl.text ?? "",
//                               buildarea: project.qbuildareaCntrl.text ?? "",
//                               clientName: project.qnameClientCntrl.text ?? "",
//                               file: project.drwaings,
//                               sitePlan: project.sitePlan,
//                               boq: project.boqFile,
//                               govtaper: project.govtPaper,
//                               projectTypeNAme: project.qprojectTypeName
//                                   .toString(),
//                               description: project.qdescriptionCntrl.text ?? "",
//                               date: DateFormat(
//                                 'dd-MM-yyyy',
//                               ).format(DateTime.now()),
//                               ploatArea: project.qplotCntrl.text,
//
//                               categoryType: project.getCategoryTypeForApi(),
//                             );
//                             project.clearQuotationForm();
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

Widget _estimationTab() {
  return Consumer<ProjectProvider>(
    builder: (context, project, _) {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount:
            (project?.estimationModel?.data?.length ?? 0) + 1, // +1 for header
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          // First item is the header text
          if (index == 0) {
            return const Text(
              "Get a professional cost estimation based on your project type, area, scope, and budget – quick, transparent, and reliable.",
              style: TextStyle(
                fontSize: 15,
                fontFamily: "Manrope",
                fontWeight: FontWeight.w600,
                color: Color(0xff737373),
              ),
            );
          }

          final item = project?.estimationModel?.data?[index - 1];
          return EstimationCard(
            title: item?.estimationId ?? "",
            // subtitle: "",
            subtitle: item?.projectType ?? "",
            date:
                "${item?.date?.day ?? ""}/${item?.date?.month ?? ""}/${item?.date?.year ?? ""}",
            showActions: true,
            status: item?.status?.replaceAll("_", " "),
            onPress: () {
              log("message");
              Provider.of<ProjectProvider>(
                context,
                listen: false,
              ).downloadPdf(context: context, id: item?.id ?? 0);
            },
            onPressView: () {
              log("message");
              Provider.of<ProjectProvider>(
                context,
                listen: false,
              ).fetchViewEstimation(
                context: context,
                id: item?.id.toString() ?? "",
              );
            },
          );
        },
      );
    },
  );
}

// Widget _estimationTab() {
//   return Padding(
//     padding: const EdgeInsets.all(16),
//     child: Consumer<ProjectProvider>(
//       builder: (context, project, _) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Get a professional cost estimation based on your project type, area, scope, and budget – quick, transparent, and reliable.",
//               style: TextStyle(
//                 fontSize: 15,
//                 fontFamily: "Manrope",
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xff737373),
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             /// Separated ListView
//             Expanded(
//               child: ListView.separated(
//                 itemCount: project?.estimationModel?.data?.length ?? 0,
//                 separatorBuilder: (context, index) =>
//                     const SizedBox(height: 12),
//                 itemBuilder: (context, index) {
//                   final item = project?.estimationModel?.data?[index];
//
//                   return EstimationCard(
//                     title: item?.name ?? "",
//                     subtitle:
//                         "${item?.location ?? ""} . ${item?.builtUpArea ?? ""}sq.ft",
//                     date:
//                         "${item?.date?.day ?? ""}/${item?.date?.month ?? ""}/${item?.date?.year ?? ""}",
//                     // status: item.status,
//                     showActions: true,
//                     onPress: () {
//                       log("message1");
//
//                       Provider.of<ProjectProvider>(
//                         context,
//                         listen: false,
//                       ).downloadPdf(context: context, id: item?.id ?? 0);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     ),
//   );
// }
Widget _quoteTab() {
  return Consumer<ProjectProvider>(
    builder: (context, project, _) {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount:
            (project?.quatationModel?.data?.length ?? 0) + 1, // +1 for header
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          // First item is the header text
          if (index == 0) {
            return const Text(
              "Get a professional cost estimation based on your project type, area, scope, and budget – quick, transparent, and reliable.",
              style: TextStyle(
                fontSize: 15,
                fontFamily: "Manrope",
                fontWeight: FontWeight.w600,
                color: Color(0xff737373),
              ),
            );
          }

          final item = project?.quatationModel?.data?[index - 1];
          return EstimationCard(
            title: item?.quatationId ?? "",
            subtitle: item?.projectType ?? "",
            // "${item?.location ?? ""} . ${item?.builtUpArea ?? ""}sq.ft",
            date:
                "${item?.date?.day ?? ""}/${item?.date?.month ?? ""}/${item?.date?.year ?? ""}",
            showActions: true,
            status: item?.status?.replaceAll("_", " "),
            onPress: () {
              Provider.of<ProjectProvider>(
                context,
                listen: false,
              ).downloadQuotesPdf(context: context, id: item?.id ?? 0);
            },
            onPressView: () {
              log("message");
              Provider.of<ProjectProvider>(
                context,
                listen: false,
              ).fetchQuotationView(
                context: context,
                id: item?.id.toString() ?? "",
              );
              // Provider.of<ProjectProvider>(
              //   context,
              //   listen: false,
              // ).downloadQuotesPdf(context: context, id: item?.id ?? 0);
            },
          );
        },
      );
    },
  );
}
// Widget _quoteTab() {
//   return Padding(
//     padding: const EdgeInsets.all(16),
//     child: Consumer<ProjectProvider>(
//       builder: (context, project, _) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Get a professional cost estimation based on your project type, area, scope, and budget – quick, transparent, and reliable.",
//               style: TextStyle(
//                 fontSize: 15,
//                 fontFamily: "Manrope",
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xff737373),
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             /// Separated ListView
//             Expanded(
//               child: ListView.separated(
//                 shrinkWrap: true,
//                 itemCount: project?.quatationModel?.data?.length ?? 0,
//                 separatorBuilder: (context, index) =>
//                     const SizedBox(height: 12),
//                 itemBuilder: (context, index) {
//                   final item = project?.quatationModel?.data?[index];
//
//                   return EstimationCard(
//                     title: item?.name ?? "",
//                     subtitle:
//                         "${item?.location ?? ""} . ${item?.builtUpArea ?? ""}sq.ft",
//                     date:
//                         "${item?.date?.day ?? ""}/${item?.date?.month ?? ""}/${item?.date?.year ?? ""}",
//                     // status: item.status,
//                     showActions: true,
//                     onPress: () {
//                       log("message2");
//                       Provider.of<ProjectProvider>(
//                         context,
//                         listen: false,
//                       ).downloadQuotesPdf(context: context, id: item?.id ?? 0);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     ),
//   );
// }

class EstimationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final String? status;
  final bool showActions;
  final void Function()? onPress;
  final void Function()? onPressView;

  const EstimationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    this.status,
    this.showActions = false,
    required this.onPress,
    required this.onPressView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Manrope",
                  color: primaryClr,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff737373),
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subtitle,
                maxLines: 3,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff737373),
                  fontWeight: FontWeight.w500,
                  fontFamily: "Manrope",
                ),
              ),
              if (status != "null")
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      status ?? "",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xffFF3B30),
                        fontWeight: FontWeight.w600,
                        fontFamily: "Manrope",
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          /// Status or Actions
          // if (status != "null")
          //   Align(
          //     alignment: Alignment.centerRight,
          //     child: Container(
          //       padding: const EdgeInsets.symmetric(
          //         horizontal: 10,
          //         vertical: 4,
          //       ),
          //       decoration: BoxDecoration(
          //         border: Border.all(color: Colors.red),
          //         borderRadius: BorderRadius.circular(6),
          //       ),
          //       child: Text(
          //         status ?? "",
          //         style: const TextStyle(
          //           fontSize: 12,
          //           color: Color(0xffFF3B30),
          //           fontWeight: FontWeight.w600,
          //           fontFamily: "Manrope",
          //         ),
          //       ),
          //     ),
          //   ),
          // SizedBox(height: 5),
          if (showActions &&
              status != "New_Enquiry" &&
              status != "New Enquiry" &&
              status != "pending")
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(width: 30),
                Flexible(
                  child: SizedBox(
                    height: 38,
                    child: CustomButton(
                      text: "View",
                      onPress: onPressView,
                      bgColor: Colors.white,
                      textColor: primaryClr,
                      borderSide: BorderSide(color: primaryClr),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: SizedBox(
                    height: 38,
                    child: CustomButton(text: "Download", onPress: onPress),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class EstimationRequestPage extends StatefulWidget {
  const EstimationRequestPage({super.key});

  @override
  State<EstimationRequestPage> createState() => _EstimationRequestPageState();
}

class _EstimationRequestPageState extends State<EstimationRequestPage> {
  @override
  void initState() {
    super.initState();

    final project = Provider.of<ProjectProvider>(context, listen: false);
    project.fetchAddressList(context: context);

    project.fetchProfile(context: context).then((_) {
      final profile = project.profileModel?.data;
      final addressList = project.addressListModel?.data;

      if (profile != null) {
        project.nameClientCntrl.text = profile.name ?? '';
        project.emailCntrl.text = profile.email ?? '';
        project.phoneClientCntrl.text = profile.phoneNumber ?? '';
      }

      if (addressList != null && addressList.isNotEmpty) {
        // 🔍 Find default address
        final defaultAddress = addressList.firstWhere(
          (addr) => addr.isDefault == true,
          orElse: () => addressList.first, // fallback if no default
        );

        project.pincodeCntrl.text = defaultAddress.pinCode?.toString() ?? '';
        project.addressCntrl.text = defaultAddress.address ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: Color(0xffF4F4F4),
      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text(
          "Estimation Request",
          style: TextStyle(
            color: primaryClr,
            fontFamily: "Manrope",
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Consumer<ProjectProvider>(
            builder: (context, project, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    hintText: "Client Full Name",
                    controller: project.nameClientCntrl,
                  ),
                  const SizedBox(height: 10),

                  CustomTextField(
                    hintText: "Email",
                    controller: project.emailCntrl,
                  ),
                  const SizedBox(height: 10),

                  CustomTextField(
                    hintText: "Phone Number",
                    keyboardType: TextInputType.number,
                    controller: project.phoneClientCntrl,
                  ),
                  const SizedBox(height: 10),

                  CustomTextField(
                    hintText: "Pin Code",
                    controller: project.pincodeCntrl,
                  ),
                  const SizedBox(height: 10),

                  CustomTextField(
                    hintText: "Address",
                    controller: project.addressCntrl,
                  ),
                  const SizedBox(height: 10),

                  /// Dropdown
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<ProjectTypeDropDown>(
                        value: project.selectedProjectType,
                        isExpanded: true,

                        style: TextStyle(
                          color: primaryClr,
                          fontSize: 14.sp,
                          fontFamily: "Manrope",
                          fontWeight: FontWeight.w600,
                          // height: 0.12,
                        ),
                        hint: const Text(
                          "Project Type",
                          style: TextStyle(
                            color: Color(0xFFCACACA),
                            fontSize: 14,
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.w600,
                            // height: 0.12,
                          ),
                        ),
                        items:
                            project.projectTypeModel?.projectTypeDropDown?.map((
                              e,
                            ) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e.label ?? ""),
                              );
                            }).toList() ??
                            [],
                        onChanged: (value) {
                          if (value != null) {
                            project.setProjectType(value);
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  CustomTextField(
                    hintText: "Built-up Area (sqm)",
                    controller: project.buildareaCntrl,
                  ),
                  const SizedBox(height: 10),

                  CustomTextField(
                    hintText: "Budget Amount",
                    controller: project.budgetAmountCntrl,
                  ),
                  const SizedBox(height: 10),

                  const Text("Upload Documents / Drawings"),
                  uploadFileBox(
                    title: project.estimationFile == null
                        ? "Upload file"
                        : project.estimationFile!.path.split('/').last,
                    onTap: () {
                      project.pickEstimationFileSection();
                    },
                  ),

                  const SizedBox(height: 10),

                  CustomTextField(
                    hintText: "Description",
                    maxLine: 4,
                    controller: project.descriptionCntrl,
                  ),

                  const SizedBox(height: 20),

                  CustomButton(
                    text: "Request",
                    onPress: project.expense
                        ? null
                        : () {
                            if (project.selectedProjectType == null) {
                              ToastUtil.show("Select project type");
                              return;
                            }

                            project.addEstimationReq(
                              context: context,
                              date: DateFormat(
                                'MM-dd-yyyy',
                              ).format(DateTime.now()),
                              description: project.descriptionCntrl.text,
                              amount: project.budgetAmountCntrl.text,
                              address: project.addressCntrl.text,
                              buildarea: project.buildareaCntrl.text,
                              clientName: project.nameClientCntrl.text,
                              email: project.emailCntrl.text,
                              phoneNo: project.phoneClientCntrl.text,
                              pinCode: project.pincodeCntrl.text,
                              projectTypeNAme: project.projectTypeName
                                  .toString(),
                              file:
                                  (project.estimationFile != null &&
                                      project.estimationFile!.path.isNotEmpty)
                                  ? project.estimationFile
                                  : null,
                            );

                            /// Clear fields
                            project.descriptionCntrl.clear();
                            project.phoneClientCntrl.clear();
                            project.nameClientCntrl.clear();
                            project.emailCntrl.clear();
                            project.addressCntrl.clear();
                            project.pincodeCntrl.clear();
                            project.descriptionCntrl.clear();
                            project.buildareaCntrl.clear();
                            project.budgetAmountCntrl.clear();
                            project.estimationFile = null;
                            project.projectTypeName = null;
                            project.selectedProjectType = null;

                            Navigator.pop(context);
                          },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class QuotationRequestPage extends StatefulWidget {
  const QuotationRequestPage({super.key});

  @override
  State<QuotationRequestPage> createState() => _QuotationRequestPageState();
}

class _QuotationRequestPageState extends State<QuotationRequestPage> {
  final _formKey = GlobalKey<FormState>();

  int currentStep = 0; // 0 = step1, 1 = step2

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text(
          "Quotation Request",
          style: TextStyle(
            color: primaryClr,
            fontFamily: "Manrope",
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: currentStep == 0 ? _buildStepOne() : _buildStepTwo(),
      ),
    );
  }

  Widget _buildStepOne() {
    return Consumer<ProjectProvider>(
      builder: (context, project, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  hintText: "Client Full Name",
                  controller: project.qnameClientCntrl,
                  validator: (v) => v == null || v.isEmpty ? "Required" : null,
                ),

                const SizedBox(height: 10),

                CustomTextField(
                  hintText: "Email",
                  controller: project.qemailCntrl,
                ),

                const SizedBox(height: 10),

                CustomTextField(
                  hintText: "Phone Number",
                  controller: project.qphoneClientCntrl,
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.isEmpty ? "Required" : null,
                ),

                const SizedBox(height: 10),
                CustomTextField(
                  hintText: "Pin Code",
                  // fillColor: Colors.white,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "pincode is required";
                    }
                    return null;
                  },

                  controller: project.qpincodeCntrl,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: "Address",
                  // fillColor: Colors.white,
                  controller: project.qaddressCntrl,
                ),
                const SizedBox(height: 10),
                Container(
                  height: 48,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color(0xFFF5F5F5),

                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<ProjectTypeDropDown>(
                      value: project.selectedqProjectType,

                      style: TextStyle(
                        color: primaryClr,
                        fontSize: 14.sp,
                        fontFamily: "Manrope",
                        fontWeight: FontWeight.w600,
                        // height: 0.12,
                      ),
                      hint: const Text(
                        "Project Type",
                        style: TextStyle(
                          color: Color(0xFFCACACA),
                          fontSize: 14,
                          fontFamily: "Manrope",
                          fontWeight: FontWeight.w600,
                          // height: 0.12,
                        ),
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                      isExpanded: true,
                      items:
                          project.projectTypeModel?.projectTypeDropDown?.map((
                            e,
                          ) {
                            return DropdownMenuItem<ProjectTypeDropDown>(
                              value: e,
                              child: Text(
                                e.label ?? "",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }).toList() ??
                          [],

                      onChanged: (value) {
                        if (value != null) {
                          project.setQuoteProjectType(value);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: "Built-up Area (sqm)",
                  // fillColor: Colors.white,
                  controller: project.qbuildareaCntrl,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "built-up area is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: "Plot Area (sqm)",
                  // fillColor: Colors.white,
                  controller: project.qplotCntrl,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "plot area is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: "Budget Amount",
                  // fillColor: Colors.white,
                  controller: project.qbudgetAmountCntrl,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "budget amount is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Text(
                //   "Upload Documents / Drawings",
                //   style: TextStyle(
                //     fontFamily: "Manrope",
                //     fontWeight: FontWeight.w500,
                //     fontSize: 14,
                //     height: 2,
                //     color: Color(0xff737373),
                //   ),
                // ),
                //
                // uploadFileBox(
                //   title: project.fundFile == null
                //       ? "Upload file"
                //       : project.fundFile!.path.split('/').last,
                //   onTap: () {
                //     // project.pickFundFile();
                //   },
                // ),
                // const SizedBox(height: 10),
                CustomTextField(
                  hintText: "Description",
                  // fillColor: Colors.white,
                  maxLine: 4,
                  controller: project.qdescriptionCntrl,
                ),

                // 👉 keep all your existing fields same...
                const SizedBox(height: 10),

                CustomButton(
                  text: "Next",
                  onPress: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() => currentStep = 1);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepTwo() {
    return Consumer<ProjectProvider>(
      builder: (context, project, _) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// CATEGORY + COUNT ADD
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xffDFDFDF)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// DROPDOWN
                    Container(
                      height: 48,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<CategoryDropDown>(
                          value: project.selectedCategory,
                          hint: const Text(
                            "Category Type",
                            style: TextStyle(
                              color: Color(0xFFCACACA),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                          isExpanded: true,
                          items:
                              project.categoryDropDown?.categoryDropDown?.map((
                                e,
                              ) {
                                return DropdownMenuItem<CategoryDropDown>(
                                  value: e,
                                  child: Text(
                                    e.label ?? "",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              }).toList() ??
                              [],
                          onChanged: (value) {
                            if (value != null) {
                              project.setSelectedCategoryQuotes(value);
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// COUNT + ADD BUTTON
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            hintText: "Enter Count",
                            keyboardType: TextInputType.number,
                            controller: project.numberCtrl,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          height: 45,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              project.addCategoryItem();
                            },
                            icon: const Icon(Icons.add),
                            label: const Text(
                              "Add",
                              style: TextStyle(color: primaryClr),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// ADDED ITEMS LIST
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xffF4F4F4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: project.addedCategoryItems.isEmpty
                    ? const Text(
                        "No items added",
                        style: TextStyle(color: Colors.grey),
                      )
                    : Column(
                        children: List.generate(
                          project.addedCategoryItems.length,
                          (index) {
                            final item = project.addedCategoryItems[index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.category.label ?? "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "x${item.count}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      GestureDetector(
                                        onTap: () {
                                          project.removeCategoryItem(index);
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ),

              const SizedBox(height: 10),

              /// FILE UPLOADS
              _fileTitle("Upload Govt Papers (IF available)"),
              uploadFileBox(
                title: project.govtPaper == null
                    ? "Upload file"
                    : project.govtPaper!.path.split('/').last,
                onTap: () => project.pickGovtFile(),
              ),

              const SizedBox(height: 10),

              _fileTitle("Upload BOQ (IF available)"),
              uploadFileBox(
                title: project.boqFile == null
                    ? "Upload file"
                    : project.boqFile!.path.split('/').last,
                onTap: () => project.pickBOQFile(),
              ),

              const SizedBox(height: 10),

              _fileTitle("Upload Drawings"),
              uploadFileBox(
                title: project.drwaings == null
                    ? "Upload file"
                    : project.drwaings!.path.split('/').last,
                onTap: () => project.pickDrawingsFile(),
              ),

              const SizedBox(height: 10),

              _fileTitle("Upload Site Plan"),
              uploadFileBox(
                title: project.sitePlan == null
                    ? "Upload file"
                    : project.sitePlan!.path.split('/').last,
                onTap: () => project.pickSitePlanFile(),
              ),

              const SizedBox(height: 20),

              /// BUTTONS
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "Previous",
                      onPress: () {
                        setState(() => currentStep = 0);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      text: "Request",
                      onPress: () async {
                        await project.addQuatationReq(
                          context: context,
                          amount: project.qbudgetAmountCntrl.text,
                          email: project.qemailCntrl.text,
                          phoneNo: project.qphoneClientCntrl.text,
                          pinCode: project.qpincodeCntrl.text,
                          address: project.qaddressCntrl.text,
                          buildarea: project.qbuildareaCntrl.text,
                          clientName: project.qnameClientCntrl.text,
                          file: project.drwaings,
                          sitePlan: project.sitePlan,
                          boq: project.boqFile,
                          govtaper: project.govtPaper,
                          projectTypeNAme: project.qprojectTypeName.toString(),
                          description: project.qdescriptionCntrl.text,
                          date: DateFormat('MM-dd-yyyy').format(DateTime.now()),
                          ploatArea: project.qplotCntrl.text,
                          categoryType: project.getCategoryTypeForApi(),
                        );

                        project.clearQuotationForm();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _fileTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
      fontFamily: "Manrope",
      fontWeight: FontWeight.w500,
      fontSize: 14,
      height: 2,
      color: Color(0xff737373),
    ),
  );
}
