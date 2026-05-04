import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youbuilt/custom_widgets/custom_button.dart';
import 'package:youbuilt/screen/profile/address.dart';
import 'package:youbuilt/screen/sign_up.dart';
import 'package:youbuilt/utils/encryptPagehlper.dart';
import 'package:youbuilt/utils/toast_util.dart';

import '../../model/addressListModel.dart';
import '../../providers/signin/project_provider.dart';
import '../../utils/colors.dart';

PageController _pageController = PageController();
int _currentPage = 0;

class ProductViewPage extends StatefulWidget {
  final String? pid;
  final String? projectid;
  ProductViewPage({Key? key, required this.pid, required this.projectid})
    : super(key: key);

  @override
  State<ProductViewPage> createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  Map<int, int> selectedAttributeIndex = {};
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = Provider.of<ProjectProvider>(context, listen: false);
      await reg.fetchAddressList(context: context);
      // Wait until item details loaded
      await Future.delayed(const Duration(milliseconds: 300));

      _initializeDefaultVariation(reg);
      super.initState();
    });
  }

  void _initializeDefaultVariation(ProjectProvider provider) async {
    final data = provider.itemListDetailsModel?.data;
    if (data == null) return;

    final attributeCategories = data.itemAttributeCategories ?? [];
    if (attributeCategories.isEmpty) return;

    Map<String, dynamic> attributeMap = {};
    List<Map<String, dynamic>> attributeCategoryList = [];
    Map<String, dynamic> attributeNameMap = {};

    for (var category in attributeCategories) {
      final catId = category.attributeCategoryId ?? 0;
      final subcats = category.attributeSubcategory ?? [];

      if (subcats.isEmpty) continue;

      /// ✅ Always select first index
      selectedAttributeIndex[catId] = 0;

      final firstSub = subcats.first;

      /// For UI + Add to cart
      attributeNameMap[catId.toString()] = {
        "label": firstSub.label ?? "",
        "value": firstSub.value ?? 0,
      };

      attributeCategoryList.add({
        "label": category.attributeCategory?.name ?? "",
        "value": firstSub.value ?? 0,
      });

      /// For variation API
      attributeMap[catId.toString()] = {
        "label": firstSub.label ?? "",
        "value": firstSub.value ?? 0,
      };
    }

    /// Save globally
    provider.selectedAttributeCategoryList = attributeCategoryList;
    provider.selectedAttributeNameMap = attributeNameMap;

    /// Call APIs
    await provider.fetchVariationLists(
      context: context,
      catId: data.id?.toString(),
      attributeMap: attributeMap,
    );

    await provider.fetchSeller(
      context: context,
      id: data.id?.toString() ?? "",
      attributeMap: attributeMap,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ProjectProvider>(
          builder: (context, item, _) {
            final bool isOutOfStock =
                item.variationModel != null &&
                item.variationModel?.data == null;

            if (isOutOfStock) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomButton(text: "Request", onPress: () async {}),
              ); // ❌ Hide button
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "Add to Cart",
                      textColor: primaryClr,
                      bgColor: Colors.white,
                      borderSide: BorderSide(color: primaryClr),
                      onPress: () async {
                        await item.addtoCart(
                          context: context,
                          projectId: widget.projectid ?? "",
                          calPrice:
                              item.itemListDetailsModel?.data?.yourPrice
                                  .toString() ??
                              "",
                          storeId:
                              item.selectedSellerStoreId?.toString() ??
                              item.itemListDetailsModel?.data?.storeId
                                  .toString() ??
                              "",
                          itemId:
                              item.itemListDetailsModel?.data?.id.toString() ??
                              "",
                          mrp:
                              item.itemListDetailsModel?.data?.mrp.toString() ??
                              "",
                          qty: "1",
                          categoryId: "",
                          attributeCategory: item.selectedAttributeCategoryList,
                          attributeName: item.selectedAttributeNameMap,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: CustomButton(
                      text: "Buy Now",
                      onPress: () async {
                        final addressList = item.addressListModel?.data ?? [];

                        Datum? defaultAddress;

                        if (addressList.isNotEmpty) {
                          defaultAddress = addressList.firstWhere(
                            (element) => element.isDefault == true,
                            orElse: () => addressList.first,
                          );
                        }
                        await item.buyNow(
                          context: context,
                          pid: "",
                          total:
                              item.itemListDetailsModel?.data?.mrp.toString() ??
                              "",
                          grandTotal:
                              item.itemListDetailsModel?.data?.yourPrice
                                  .toString() ??
                              "",
                          addressid: defaultAddress?.id.toString() ?? "",
                          calPrice:
                              item.itemListDetailsModel?.data?.yourPrice
                                  .toString() ??
                              "",
                          storeId:
                              item.selectedSellerStoreId?.toString() ??
                              item.itemListDetailsModel?.data?.storeId
                                  .toString() ??
                              "",
                          itemId:
                              item.itemListDetailsModel?.data?.id.toString() ??
                              "",
                          mrp:
                              item.itemListDetailsModel?.data?.mrp.toString() ??
                              "",
                          qty: "1",
                          categoryId: "",
                          attributeCategory: item.selectedAttributeCategoryList,
                          attributeName: item.selectedAttributeNameMap,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text("Product", style: TextStyle(color: Colors.black)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<ProjectProvider>(
            builder: (context, items, _) {
              final addressList = items.addressListModel?.data ?? [];

              Datum? defaultAddress;

              if (addressList.isNotEmpty) {
                defaultAddress = addressList.firstWhere(
                  (element) => element.isDefault == true,
                  orElse: () => addressList.first,
                );
              }
              final data = items.itemListDetailsModel?.data;
              final attributeCategories = data?.itemAttributeCategories ?? [];

              final variation = items.variationModel?.data;

              // ADD THIS - log all fields to find correct names
              log("Variation data: ${items.variationModel?.toJson()}");

              // final displayPrice = variation?.yourPrice ?? data?.yourPrice;
              // final displayMrp = variation?.mrp ?? data?.mrp;
              final bool isOutOfStock =
                  items.variationModel != null &&
                  items.variationModel?.data == null;

              final displayPrice = variation?.yourPrice ?? data?.yourPrice ?? 0;
              final displayMrp = variation?.mrp ?? data?.mrp ?? 0;

              double discountPercent = 0;

              if (displayMrp != 0) {
                discountPercent =
                    ((displayMrp - displayPrice) * 100) / displayMrp;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// PRODUCT IMAGE
                  /// Replace your current product image Container with this:
                  Container(
                    height: 270.h,
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
                        PageView.builder(
                          itemCount: data?.itemImages?.length ?? 1,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            final imageUrl =
                                data?.itemImages?[index].image ?? "";
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.fill,
                                placeholder: (_, __) => shimmerBox(
                                  height: 270.h,
                                  width: double.infinity,
                                  radius: 14,
                                ),
                                errorWidget: (_, __, ___) =>
                                    const Icon(Icons.error),
                              ),
                            );
                          },
                        ),

                        /// SHARE BUTTON
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () async {
                              final productId =
                                  items
                                      .itemListDetailsModel
                                      ?.data
                                      ?.storeItemId ??
                                  "";

                              final encrypted = CryptoHelper.encryptUrl(
                                productId.toString(),
                              );

                              final url =
                                  "https://www.youbuilt.in/shop/purchase/product/$encrypted";

                              await Share.share(
                                url,
                                subject:
                                    items.itemListDetailsModel?.data?.name ??
                                    "Check this product",
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
                              child: const Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if ((data?.itemImages?.length ?? 0) > 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          data!.itemImages!.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 4,
                            width: _currentPage == index ? 20 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? Colors.black
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  /// TITLE + RATING
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          data?.name ?? "",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Manrope",
                            color: Color(0xffA3A3A3),
                          ),
                        ),
                      ),
                      const Row(
                        children: [
                          Icon(Icons.star, color: Colors.orange, size: 18),
                          SizedBox(width: 4),
                          Text(""),
                        ],
                      ),
                    ],
                  ),

                  Text(
                    data?.description ?? "",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Manrope",
                      color: primaryClr,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// PRICE — updates when variation is selected
                  items.itemLoadingSub
                      ? const SizedBox(
                          height: 30,
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: primaryClr,
                              ),
                            ),
                          ),
                        )
                      : isOutOfStock
                      ? const Text(
                          "Out of Stock",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.red,
                          ),
                        )
                      : Row(
                          children: [
                            Text(
                              "₹ ${displayPrice?.toString() ?? ""}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Manrope",
                                color: primaryClr,
                              ),
                            ),
                            Text(
                              " /${data?.units.toString() ?? ""}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Manrope",
                                color: Color(0xff737373),
                              ),
                            ),
                            SizedBox(width: 5),
                            SizedBox(
                              width: 100.w,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(color: primaryClr),
                                  ),
                                ),
                                onPressed: () {
                                  _showEnquiryDialog(
                                    context,
                                    data?.itemId ?? "",
                                  );
                                },
                                child: Text(
                                  "Enquiry",
                                  style: TextStyle(
                                    fontFamily: "Manrope",
                                    color: primaryClr,
                                  ),
                                ),
                              ),
                            ),

                            // const SizedBox(width: 10),
                          ],
                        ),

                  displayMrp == 0
                      ? SizedBox()
                      : Row(
                          children: [
                            Text(
                              "MRP: ₹${displayMrp?.toString() ?? ""}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Manrope",
                                decoration: TextDecoration.lineThrough,
                                color: Color(0xff737373),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "${discountPercent.toStringAsFixed(2)}% OFF ",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Manrope",
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                  const Text(
                    "(Inclusive of all taxes)",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Manrope",
                      color: Color(0xff737373),
                    ),
                  ),

                  data?.itemAttributeCategories?.isEmpty == true
                      ? const SizedBox()
                      : const Divider(color: Color(0xffF4F4F4), height: 25),

                  /// DYNAMIC ATTRIBUTE CATEGORIES
                  ...attributeCategories.map((attrCategory) {
                    final categoryName =
                        attrCategory.attributeCategory?.name ?? "";
                    log("-----------$categoryName");

                    final categoryId = attrCategory.attributeCategoryId ?? 0;
                    final subcategories =
                        attrCategory.attributeSubcategory ?? [];

                    if (subcategories.isEmpty) return const SizedBox();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select $categoryName",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Manrope",
                            color: primaryClr,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(subcategories.length, (
                            index,
                          ) {
                            final isSelected =
                                (selectedAttributeIndex[categoryId] ?? 0) ==
                                index;
                            final sub = subcategories[index];

                            return GestureDetector(
                              onTap: () async {
                                setState(() {
                                  selectedAttributeIndex[categoryId] = index;
                                });

                                Map<String, dynamic> attributeMap = {};
                                List<Map<String, dynamic>>
                                attributeCategoryList = [];
                                Map<String, dynamic> attributeNameMap = {};

                                for (var category in attributeCategories) {
                                  final catId =
                                      category.attributeCategoryId ?? 0;
                                  final subcats =
                                      category.attributeSubcategory ?? [];
                                  if (subcats.isEmpty) continue;

                                  final selectedIndex = (catId == categoryId)
                                      ? index
                                      : (selectedAttributeIndex[catId] ?? 0);

                                  if (selectedIndex < subcats.length) {
                                    final selectedSub = subcats[selectedIndex];

                                    /// ✅ attributeName map
                                    attributeNameMap[catId.toString()] = {
                                      "label": selectedSub.label ?? "",
                                      "value": selectedSub.value ?? 0,
                                    };

                                    /// ✅ attributecategory list
                                    attributeCategoryList.add({
                                      "label":
                                          category.attributeCategory?.name ??
                                          "",
                                      "value": selectedSub.value ?? 0,
                                    });

                                    /// For variation API
                                    attributeMap[catId.toString()] = {
                                      "label": selectedSub.label ?? "",
                                      "value": selectedSub.value ?? 0,
                                    };
                                  }
                                }

                                /// Save globally
                                items.selectedAttributeCategoryList =
                                    attributeCategoryList;
                                items.selectedAttributeNameMap =
                                    attributeNameMap;

                                log(
                                  "ATTRIBUTE CATEGORY LIST: ${items.selectedAttributeCategoryList}",
                                );
                                log(
                                  "ATTRIBUTE NAME MAP: ${items.selectedAttributeNameMap}",
                                );

                                await Provider.of<ProjectProvider>(
                                  context,
                                  listen: false,
                                ).fetchVariationLists(
                                  context: context,
                                  catId: data?.id?.toString(),
                                  attributeMap: attributeMap,
                                );

                                await Provider.of<ProjectProvider>(
                                  context,
                                  listen: false,
                                ).fetchSeller(
                                  context: context,
                                  id: data?.id?.toString() ?? "",
                                  attributeMap: attributeMap,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.black
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  sub.label ?? "",
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontFamily: "Manrope",
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 15),
                      ],
                    );
                  }).toList(),

                  const Divider(color: Color(0xffF4F4F4), height: 25),

                  /// DELIVERY BOX
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddressPage()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xffF4F4F4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Delivery to : ${defaultAddress?.address ?? ""}, ${defaultAddress?.addressTitle ?? ""},",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// PRODUCT DETAILS
                  const Text(
                    "Product Details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Manrope",
                      color: primaryClr,
                    ),
                  ),

                  const SizedBox(height: 10),

                  _detailRow("Brand", data?.itemBrands?.brands?.name ?? ""),
                  // _detailRow("Price", data?.mrp.toString() ?? ""),
                  // _detailRow("Location",data?.),
                  // _detailRow("Seller", ""),
                  // _detailRow("Packet", ""),
                  _detailRow("Description", data?.description ?? ""),

                  const SizedBox(height: 20),
                  _assignSellerDropdown(),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showEnquiryDialog(BuildContext context, String? id) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final messageController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Add Enquiry",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: "Manrope",
                          fontSize: 18,
                          color: primaryClr,
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Consumer<ProjectProvider>(
                    builder: (context, project, _) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextField(
                            hintText: "Name",
                            fillColor: Colors.white,
                            controller: nameController,
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            hintText: "Phone number",
                            fillColor: Colors.white,
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            hintText: "Message",
                            fillColor: Colors.white,
                            maxLine: 4,
                            controller: messageController,
                            // keyboardType: TextInputType.numberCtrl,
                          ),
                          const SizedBox(height: 10),

                          CustomButton(
                            text: project.expense
                                ? "Please wait..."
                                : "Confirm",
                            onPress: project.expense
                                ? null
                                : () async {
                                    await project.addEnquiry(
                                      context: context,
                                      date: DateTime.now().toString(),
                                      name: nameController.text ?? "",
                                      mobile: phoneController.text ?? "",
                                      message: messageController.text ?? "",
                                      itemId: "$id",
                                      itemType: "Item",
                                    );
                                  },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _assignSellerDropdown() {
    return Consumer<ProjectProvider>(
      builder: (context, project, _) {
        final sellerList = project.sellerModel?.data ?? [];

        if (project.itemLoading) {
          // return const Center(child: CircularProgressIndicator());
        }

        if (sellerList.isEmpty) {
          return const SizedBox();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xffF4F4F4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<int>(
            value: project.selectedSellerStoreId, // ✅ Selected value shown
            decoration: const InputDecoration(border: InputBorder.none),
            hint: const Text("See other Sellers"),
            items: sellerList.map<DropdownMenuItem<int>>((seller) {
              final clusterName =
                  seller.store?.cluster?.name ?? "Unknown Cluster";

              final price = seller.yourPrice ?? 0;

              return DropdownMenuItem<int>(
                value: seller.storeId, // ✅ storeId used as value
                child: Text(
                  "$clusterName - ₹$price",
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;

              final selectedSeller = sellerList.firstWhere(
                (e) => e.storeId == value,
              );

              project.setSelectedSeller(selectedSeller); // ✅ storeId saved
            },
          ),
        );
      },
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: "Manrope",
                color: Color(0xff737373),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: "Manrope",
                color: primaryClr,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showShareBottomSheet(BuildContext context, String url) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Share Product",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                /// WhatsApp
                _shareOption(
                  icon: Icons.message,
                  label: "WhatsApp",
                  onTap: () async {
                    final whatsappUrl =
                        "https://wa.me/?text=${Uri.encodeComponent(url)}";
                    await launchUrl(
                      Uri.parse(whatsappUrl),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),

                /// Chrome
                _shareOption(
                  icon: Icons.language,
                  label: "Open",
                  onTap: () async {
                    await launchUrl(
                      Uri.parse(url),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),

                /// Copy Link
                _shareOption(
                  icon: Icons.copy,
                  label: "Copy",
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: url));
                    Navigator.pop(context);
                    ToastUtil.show("Link Copied");
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(content: Text("Link copied")),
                    // );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}

Widget _shareOption({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(label),
      ],
    ),
  );
}

Widget shimmerBox({double? height, double? width, double radius = 8}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}
