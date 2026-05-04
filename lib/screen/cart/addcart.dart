import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/custom_widgets/custom_button.dart';
import 'package:youbuilt/providers/signin/project_provider.dart';
import 'package:youbuilt/screen/bottom_nav.dart';
import 'package:youbuilt/screen/cart/payementPage.dart';
import 'package:youbuilt/screen/profile/address.dart';
import '../../model/cart_list_model.dart';
import '../../utils/colors.dart';

class MyCartPage extends StatefulWidget {
  const MyCartPage({super.key});

  @override
  State createState() => _MyCartPageState();
}

class _MyCartPageState extends State {
  // @override
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = context.read<ProjectProvider>();

      reg.selectedProjectId = null;
      reg.check == false;

      await reg.fetchCartList(context: context);
      await reg.fetchAddressList(context: context);
      await reg.fetchAssignProjectList(context: context);

      /// ✅ AUTO SELECT PROJECT FROM CART
      final cartList = reg.cartListModel?.data ?? [];

      if (cartList.isNotEmpty) {
        final cartProjectId = cartList.first.projectId; // 👈 from API

        if (cartProjectId != null) {
          final projectList = reg.assignProjectModel?.projectDropDown ?? [];

          final matchedProject = projectList.firstWhere(
            (e) => e?.value == cartProjectId,
          );

          if (matchedProject != null) {
            reg.setSelectedProject(
              matchedProject.value,
              matchedProject.walletBalance?.toDouble(),
            );
          }
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // backgroundColor: Color(0xffF4F4F4),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // leading: SizedBox(),
        leading: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BottomNavScreen()),
            );
          },
          child: Icon(Icons.arrow_back),
        ),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text(
          "My Cart",
          style: TextStyle(
            color: primaryClr,
            fontFamily: "Manrope",
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: false,
        actions: [
          Consumer<ProjectProvider>(
            builder: (context, project, _) {
              final cartList = project.cartListModel?.data ?? [];
              if (cartList.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SizedBox(
                  height: 35,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: primaryClr, // 👈 your border color
                          width: 1, // 👈 thickness
                        ),
                      ),
                    ),

                    onPressed: () async {
                      await project.deleteallcart(context: context);
                    },
                    child: const Text(
                      "Clear",
                      style: TextStyle(
                        fontFamily: "Manrope",
                        color: primaryClr,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),

      // ✅ FIX: Checkout bar is now fixed at the bottom via bottomNavigationBar
      // bottomNavigationBar: Consumer<ProjectProvider>(
      //   builder: (context, project, _) {
      //     final cartList = project.cartListModel?.data ?? [];
      //     if (cartList.isEmpty) return const SizedBox.shrink();
      //     return Padding(
      //       padding: const EdgeInsets.only(bottom: 90),
      //       child: _bottomCheckout(context),
      //     );
      //   },
      // ),
      bottomNavigationBar: Consumer<ProjectProvider>(
        builder: (context, project, _) {
          final cartList = project.cartListModel?.data ?? [];
          if (cartList.isEmpty) return const SizedBox.shrink();

          final bottomInset = MediaQuery.of(context).viewInsets.bottom;

          return AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.only(
              bottom: bottomInset, // ✅ only keyboard height
            ),
            child: SafeArea(
              top: false,
              bottom: true,
              child: _bottomCheckout(context),
            ),
          );
        },
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, project, _) {
          final cartList = project.cartListModel?.data ?? [];

          /// SHOW ONLY EMPTY SCREEN
          if (cartList.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/emptycart.png",
                      height: 150,
                      width: 150,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "No Products",
                      style: TextStyle(
                        fontFamily: "Manrope",

                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryClr,
                      ),
                    ),
                    Text(
                      "Discover new products and start shopping",
                      style: TextStyle(
                        height: 3,
                        fontFamily: "Manrope",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff737373),
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            );
          }

          /// IF CART HAS DATA → SHOW FULL UI
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(color: Color(0xffF4F4F4), height: 1),
                SizedBox(height: 10),
                _deliverySection(),
                const SizedBox(height: 10),

                ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: cartList.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = cartList[index];
                    return _cartItem(item);
                  },
                ),

                const SizedBox(height: 10),
                _assignProjectDropdown(),
                const SizedBox(height: 10),
                _billDetails(),
                const SizedBox(height: 10),
                _importantNotice(),
                const SizedBox(height: 10), // ✅ No need for 80px gap anymore
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _bottomCheckout(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (context, project, _) {
        final cartList = project.cartListModel?.data ?? [];

        double itemTotal = 0;
        double totalGst = 0;

        for (var item in cartList) {
          final price = (item.calculatorPrice ?? 0).toDouble();
          final qty = (item.qty ?? 1);
          final gst = (item.totalGst ?? 0).toDouble();

          itemTotal += (price * qty);
          totalGst += (gst * qty);
        }

        double grandTotal = itemTotal - totalGst;

        return Container(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
            top: 16,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// GRAND TOTAL
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Grand Total",
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                  Text(
                    "₹ ${itemTotal.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              /// CHECKOUT BUTTON
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: (cartList.isEmpty || project.check == true)
                    ? null // ✅ disables button while loading
                    : () async {
                        final cartItems = cartList
                            .map((e) => {"id": e.id})
                            .toList();
                        await project.checkOut(
                          context: context,
                          grandTotal: grandTotal.toString(),
                          projectId: project.selectedProjectId.toString(),
                          addressId:
                              project.addressListModel?.data?.first?.id
                                  .toString() ??
                              "",
                          totalprice: itemTotal.toString(),
                          calPrice: itemTotal.toString(),
                          cart: cartItems,
                        );
                      },
                child: project.check == true
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Check Out",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _deliverySection() {
    return Consumer<ProjectProvider>(
      builder: (context, project, _) {
        final addressList = project.addressListModel?.data ?? [];

        if (addressList.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Color(0xffF4F4F4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("No address added"),
                SizedBox(
                  width: 90,
                  child: CustomButton(
                    text: "Add",
                    onPress: () {
                      HapticFeedback.heavyImpact();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddressPage()),
                      );
                    },
                    borderSide: const BorderSide(color: Color(0xffFF3B30)),
                    bgColor: Colors.white,
                    textColor: const Color(0xffFF3B30),
                  ),
                ),
              ],
            ),
          );
        }

        final address = addressList.first;

        return Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Color(0xffF4F4F4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Deliver to : ${address.name ?? ""}",
                      style: TextStyle(
                        color: primaryClr,
                        fontFamily: "Manrope",
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${address.address ?? ""}, ${address.addressTitle ?? ""}",
                      style: TextStyle(
                        color: primaryClr,
                        fontFamily: "Manrope",
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 90,
                height: 38,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddressPage()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xffFF3B30)),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    "Change",
                    style: TextStyle(
                      color: Color(0xffFF3B30),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _cartItem(Datum item) {
    final imageUrl = item.item?.itemImages?.isNotEmpty == true
        ? item.item!.itemImages!.first.image
        : null;

    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: Color(0xffF4F4F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 70,
                        width: 70,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  )
                : Container(
                    height: 70,
                    width: 70,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image),
                  ),
          ),
          const SizedBox(width: 12),

          /// DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.item?.name ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "₹${item.calculatorPrice ?? 0}/Pcs",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                item.mrp == 0
                    ? SizedBox()
                    : Row(
                        children: [
                          Text(
                            "MRP : ",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "₹${item.mrp ?? 0}",
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),

          /// QTY + REMOVE
          Consumer<ProjectProvider>(
            builder: (context, project, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /// REMOVE BUTTON
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      project.deleteCart(
                        cartid: item.id.toString(),
                        context: context,
                      );
                    },
                    child: Icon(Icons.close, color: Colors.red, size: 20),
                  ),
                  const SizedBox(height: 10),

                  /// QTY CONTROLS
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          HapticFeedback.heavyImpact();
                          project.decrementQty(item.id!);

                          await project.editQty(
                            context: context,
                            pid: item.id.toString(),
                            qty: item.qty.toString(),
                            price: item.mrp.toString(),
                            calPrice: item.calculatorPrice.toString(),
                          );
                        },
                        child: const Icon(Icons.remove_circle_outline),
                      ),

                      const SizedBox(width: 8),

                      SizedBox(
                        width: 50,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          controller: TextEditingController(
                            text: (item.qty ?? 1).toString(),
                          ),
                          onSubmitted: (value) async {
                            int newQty = int.tryParse(value) ?? 1;

                            // project.updateQty(item.id!, newQty);

                            await project.editQty(
                              context: context,
                              pid: item.id.toString(),
                              qty: newQty.toString(),
                              price: item.mrp.toString(),
                              calPrice: item.calculatorPrice.toString(),
                            );
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 4),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      GestureDetector(
                        onTap: () async {
                          HapticFeedback.heavyImpact();
                          project.incrementQty(item.id!);

                          await project.editQty(
                            context: context,
                            pid: item.id.toString(),
                            qty: item.qty.toString(),
                            price: item.mrp.toString(),
                            calPrice: item.calculatorPrice.toString(),
                          );
                        },
                        child: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),

                  // Row(
                  //   children: [
                  //     GestureDetector(
                  //       onTap: () async {
                  //         HapticFeedback.heavyImpact();
                  //         project.decrementQty(item.id!);
                  //         await project.editQty(
                  //           context: context,
                  //
                  //           pid: item.id.toString() ?? "",
                  //           qty: item.qty.toString() ?? "",
                  //           price: item.mrp.toString() ?? "",
                  //           calPrice: item.calculatorPrice.toString() ?? "",
                  //         );
                  //       },
                  //       child: const Icon(Icons.remove_circle_outline),
                  //     ),
                  //     const SizedBox(width: 8),
                  //     Text("${item.qty ?? 1}"),
                  //     const SizedBox(width: 8),
                  //     GestureDetector(
                  //       onTap: () async {
                  //         HapticFeedback.heavyImpact();
                  //         project.incrementQty(item.id!);
                  //         print("INCREMENT____${item.id}");
                  //         print("INCREMENT____${item.id}");
                  //         print("INCREMENT____${item.qty}");
                  //         print("INCREMENT____${item.mrp}");
                  //         print("INCREMENT____${item.calculatorPrice}");
                  //
                  //         await project.editQty(
                  //           context: context,
                  //
                  //           pid: item.id.toString() ?? "",
                  //           qty: item.qty.toString() ?? "",
                  //           price: item.mrp.toString() ?? "",
                  //           calPrice: item.calculatorPrice.toString() ?? "",
                  //         );
                  //       },
                  //       child: const Icon(Icons.add_circle_outline),
                  //     ),
                  //   ],
                  // ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _assignProjectDropdown() {
    return Consumer<ProjectProvider>(
      builder: (context, project, _) {
        final projectList = project.assignProjectModel?.projectDropDown ?? [];

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Color(0xffF4F4F4), // ✅ Green background
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<int>(
            value: project.selectedProjectId,
            dropdownColor: Colors.white, // ✅ Dropdown menu BG color
            decoration: const InputDecoration(border: InputBorder.none),
            hint: const Text(
              "Assign a project",
              style: TextStyle(color: Colors.black),
            ),
            iconEnabledColor: Colors.black,
            style: const TextStyle(color: Colors.black),
            // icon: ,
            items: projectList.asMap().entries.map((entry) {
              int index = entry.key;
              var item = entry.value;

              return DropdownMenuItem<int>(
                value: item?.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item?.label ?? ""),
                    // if (index != projectList.length - 1)
                    //   const Divider(
                    //     thickness: 1,
                    //     height: 10,
                    //     color: Colors.grey, // ✅ Divider color
                    //   ),
                  ],
                ),
              );
            }).toList(),

            onChanged: (value) {
              final selectedProject = projectList.firstWhere(
                (element) => element?.value == value,
              );

              project.setSelectedProject(
                value,
                selectedProject?.walletBalance?.toDouble(),
              );
            },
          ),
        );
      },
    );
  }
  // Widget _assignProjectDropdown() {
  //   return Consumer<ProjectProvider>(
  //     builder: (context, project, _) {
  //       final projectList = project.assignProjectModel?.projectDropDown ?? [];
  //       bool isOpen = false;
  //
  //       return Container(
  //         margin: const EdgeInsets.symmetric(horizontal: 16),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(12),
  //           border: Border.all(color: Color(0xffE5E7EB)),
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             /// DROPDOWN
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 12),
  //               child: DropdownButtonFormField<int>(
  //                 value: project.selectedProjectId,
  //                 dropdownColor: Colors.white,
  //                 focusColor: Colors.white,
  //                 decoration: const InputDecoration(
  //                   fillColor: Colors.white,
  //                   focusColor: Colors.white,
  //                   border: InputBorder.none,
  //                   contentPadding: EdgeInsets.symmetric(vertical: 4),
  //                 ),
  //                 hint: const Text(
  //                   "Assign a project",
  //                   style: TextStyle(
  //                     fontFamily: "Manrope",
  //                     fontSize: 14,
  //                     color: Colors.grey,
  //                   ),
  //                 ),
  //                 icon: const Icon(
  //                   Icons.keyboard_arrow_down_rounded,
  //                   color: Color(0xff16A34A),
  //                 ),
  //                 // ✅ Green tinted open dropdown
  //                 style: const TextStyle(
  //                   fontFamily: "Manrope",
  //                   fontSize: 14,
  //                   color: Color(0xff111827),
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //                 selectedItemBuilder: (context) {
  //                   return projectList.map<Widget>((item) {
  //                     return Row(
  //                       children: [
  //                         Text(
  //                           item?.label ?? "",
  //                           style: const TextStyle(
  //                             color: Color(0xff16A34A),
  //                             fontWeight: FontWeight.w600,
  //                             fontSize: 14,
  //                           ),
  //                         ),
  //                       ],
  //                     );
  //                   }).toList();
  //                 },
  //                 items: projectList.map<DropdownMenuItem<int>>((item) {
  //                   // final isSelected =
  //                   //     project.selectedProjectId == item?.value;
  //                   return DropdownMenuItem<int>(
  //                     value: item?.value,
  //                     child: Container(
  //                       padding: const EdgeInsets.symmetric(
  //                         vertical: 4,
  //                         horizontal: 8,
  //                       ),
  //                       decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.circular(6),
  //                       ),
  //                       child: Row(
  //                         children: [
  //                           Text(
  //                             item?.label ?? "",
  //                             style: TextStyle(
  //                               color: primaryClr,
  //                               fontWeight: FontWeight.w400,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   );
  //                 }).toList(),
  //                 onChanged: (value) {
  //                   project.setSelectedProject(value);
  //                 },
  //               ),
  //             ),
  //
  //             /// ✅ DIVIDER
  //             // const Divider(height: 1, thickness: 1, color: Color(0xffE5E7EB)),
  //
  //             // /// ✅ Review text below divider
  //             // Padding(
  //             //   padding: const EdgeInsets.symmetric(
  //             //     horizontal: 12,
  //             //     vertical: 10,
  //             //   ),
  //             //   child: Row(
  //             //     children: [
  //             //       const Icon(
  //             //         Icons.info_outline_rounded,
  //             //         size: 14,
  //             //         color: Color(0xff9CA3AF),
  //             //       ),
  //             //       const SizedBox(width: 6),
  //             //       Expanded(
  //             //         child: Text(
  //             //           "Select a project to assign this cart order.",
  //             //           style: TextStyle(
  //             //             fontFamily: "Manrope",
  //             //             fontSize: 12.sp,
  //             //             color: const Color(0xff9CA3AF),
  //             //             fontWeight: FontWeight.w400,
  //             //           ),
  //             //         ),
  //             //       ),
  //             //     ],
  //             //   ),
  //             // ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _billDetails() {
    return Consumer<ProjectProvider>(
      builder: (context, project, _) {
        final cartList = project.cartListModel?.data ?? [];

        double itemTotal = 0;
        double totalGst = 0;

        for (var item in cartList) {
          final price = (item.calculatorPrice ?? 0).toDouble();
          final qty = (item.qty ?? 1);
          final gst = (item.totalGst ?? 0).toDouble();

          itemTotal += (price * qty);
          totalGst += (gst * qty);
        }

        double grandTotal = itemTotal - totalGst;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xffF4F4F4)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bill Details",
                style: TextStyle(
                  color: primaryClr,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                ),
              ),
              Divider(),

              /// Item Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Item Total (${cartList.length} item)",
                    style: TextStyle(color: Color(0xff737373), fontSize: 14.sp),
                  ),
                  Text(
                    "₹ ${grandTotal.toStringAsFixed(2)}",
                    style: TextStyle(color: Color(0xff737373), fontSize: 14.sp),
                  ),
                ],
              ),
              SizedBox(height: 6),

              /// Tax
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tax"),
                  Text(
                    "₹ ${totalGst.toStringAsFixed(2)}",
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
              SizedBox(height: 6),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Color(0xffF4F4F4)),
                padding: EdgeInsets.all(5),
                child: Text(
                  "Delivery fee depends on distance and seller confirmation.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontFamily: "Manrope",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Divider(height: 20),

              /// Grand Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Grand Total",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "₹ ${itemTotal.toStringAsFixed(2)}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _importantNotice() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(0xffF4F4F4),
        border: Border.all(color: Color(0xffD1D5DB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Important Notice",
            style: TextStyle(
              color: Color(0xffA3A3A3),
              fontSize: 16,
              fontFamily: "Manrope",
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "The manufacture's warranty is valid only if the product is installed in accordance with the manufacture's specifications. Youbuilt shall not be held responsible for warranty claims denied by the manufacturer as a result of improper or non-compliant installation.",
            style: TextStyle(
              color: Color(0xffA3A3A3),
              fontSize: 14,
              fontFamily: "Manrope",
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
