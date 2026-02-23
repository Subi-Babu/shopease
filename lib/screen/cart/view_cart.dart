import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/custom_widgets/custom_button.dart';
import 'package:youbuilt/screen/profile/address.dart';

import '../../providers/signin/project_provider.dart';
import '../../utils/colors.dart';

class ProductViewPage extends StatefulWidget {
  const ProductViewPage({Key? key}) : super(key: key);

  @override
  State<ProductViewPage> createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  Map<int, int> selectedAttributeIndex = {};

  /// Build attribute map from all currently selected attribute categories
  Map<String, dynamic> _buildAttributeMap({
    required List attributeCategories,
    int? overrideCategoryId,
    int? overrideIndex,
  }) {
    Map<String, dynamic> attributeMap = {};

    for (var attrCat in attributeCategories) {
      final catId = attrCat.id ?? 0;
      final catName = attrCat.attributeCategory?.name ?? "";
      final subcats = attrCat.attributeSubcategory ?? [];

      if (subcats.isEmpty) continue;

      // Use overridden index for the tapped category (setState hasn't updated yet)
      final idx = (catId == overrideCategoryId)
          ? (overrideIndex ?? 0)
          : (selectedAttributeIndex[catId] ?? 0);

      if (idx < subcats.length) {
        attributeMap[catName] = subcats[idx].label ?? "";
      }
    }

    return attributeMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          text: "Add to Cart",
          onPress: () {
            AddressPage();
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
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<ProjectProvider>(
            builder: (context, items, _) {
              final data = items.itemListDetailsModel?.data;
              final attributeCategories = data?.itemAttributeCategories ?? [];

              final variation = items.variationModel?.data;

              // ADD THIS - log all fields to find correct names
              log("Variation data: ${items.variationModel?.toJson()}");

              final displayPrice = variation?.yourPrice ?? data?.yourPrice;
              final displayMrp = variation?.mrp ?? data?.mrp;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// PRODUCT IMAGE
                  Container(
                    height: 260,
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: items.itemLoadingSub
                        ? const Center(child: CircularProgressIndicator())
                        : CachedNetworkImage(
                            imageUrl: (data?.itemImages?.isNotEmpty == true)
                                ? (data!.itemImages!.first.image ?? "")
                                : "",
                            fit: BoxFit.cover,
                            placeholder: (_, __) => const SizedBox(),
                            errorWidget: (_, __, ___) => const SizedBox(),
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
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
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
                            const SizedBox(width: 10),
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

                    final categoryId = attrCategory.id ?? 0;
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

                                for (var category in attributeCategories) {
                                  final catId = category.id;
                                  final selectedIndex =
                                      selectedAttributeIndex[catId];

                                  if (selectedIndex != null) {
                                    final sub = category
                                        .attributeSubcategory![selectedIndex];
                                    final categoryName =
                                        category.attributeCategory?.name ?? "";

                                    attributeMap[categoryName] = sub.label;
                                  }
                                }

                                log("ATTRIBUTE MAP: $attributeMap");

                                await Provider.of<ProjectProvider>(
                                  context,
                                  listen: false,
                                ).fetchVariationLists(
                                  context: context,
                                  catId: data?.id?.toString(),
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
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xffF4F4F4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Delivery to",
                      style: TextStyle(fontWeight: FontWeight.w500),
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
                  _detailRow("Material Type", ""),
                  _detailRow("Weight", ""),
                  _detailRow("Seller", ""),
                  _detailRow("Packet", ""),
                  _detailRow("Description", data?.description ?? ""),

                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
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
