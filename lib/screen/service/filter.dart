import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/custom_widgets/custom_button.dart';
import 'package:youbuilt/providers/signin/project_provider.dart';

import '../../utils/colors.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  int selectedIndex = 0;

  RangeValues priceRange = const RangeValues(0, 500);

  // ✅ Store selected brand IDs and Names
  List<String> selectedBrandIds = [];
  List<String> selectedBrandNames = [];

  final List<String> leftMenu = ["Sub Categories", "Price Range", "Brands"];
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProjectProvider>(context, listen: false);

      if (provider.selectedCategoryId.isNotEmpty) {
        provider.fetchSubCategoryLists(
          context: context,
          catId: provider.selectedCategoryId,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: Text(
          "Filters",
          style: TextStyle(
            color: primaryClr,
            fontFamily: "Manrope",
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: false,
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, items, _) {
          return Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    /// LEFT MENU
                    Container(
                      width: 120.w,
                      color: Color(0xffDADDE1),
                      child: ListView.builder(
                        itemCount: leftMenu.length,
                        itemBuilder: (context, index) {
                          final isSelected = selectedIndex == index;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey.shade100,
                                border: Border(
                                  left: BorderSide(
                                    color: isSelected
                                        ? Colors.red
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  leftMenu[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: isSelected ? Colors.red : primaryClr,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    /// RIGHT CONTENT
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: buildRightContent(),
                      ),
                    ),
                  ],
                ),
              ),

              /// Bottom Buttons
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xffE5E5E5))),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: "Clear",
                        onPress: () {
                          setState(() {
                            selectedBrandIds.clear();
                            selectedBrandNames.clear();
                            items.selectedSubIds.clear();
                            items.selectedSubNames.clear();
                          });
                        },
                        borderSide: BorderSide(color: primaryClr),
                        bgColor: Colors.white,
                        textColor: primaryClr,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        text: "Apply",
                        onPress: () {
                          HapticFeedback.heavyImpact();
                          print("Selected Sub IDs: ${items.selectedSubIds}");
                          print("Selected Brand IDs: $selectedBrandIds");
                          print(
                            "Price Range: ${priceRange.start} - ${priceRange.end}",
                          );
                          items.fetchItemLists2(
                            context: context,
                            startPrice: "${priceRange.start}",
                            endPrice: "${priceRange.end}",
                            catid: "",
                            brandiid: "$selectedBrandIds",
                            sort: "",
                          );
                          items.selectedSubIds.clear();
                          // items.selectedBrandIds.clear();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildRightContent() {
    switch (selectedIndex) {
      /// ---------------- SUB CATEGORIES ----------------
      case 0:
        return Consumer<ProjectProvider>(
          builder: (context, provider, _) {
            if (provider.itemLoadingSub == true) {
              return const Center(
                child: CircularProgressIndicator(color: primaryClr),
              );
            }

            if (provider.subCategoryModel == null ||
                provider.subCategoryModel!.categoryList == null ||
                provider.subCategoryModel!.categoryList!.isEmpty) {
              return const Center(child: Text("No Sub Categories"));
            }

            final subList = provider.subCategoryModel!.categoryList!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sub Categories",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: primaryClr,
                  ),
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    itemCount: subList.length,
                    itemBuilder: (context, index) {
                      final sub = subList[index];
                      final String subId = sub.id.toString();
                      final String subName = sub.name ?? "";

                      final bool isChecked = provider.selectedSubIds.contains(
                        subId,
                      );

                      return CheckboxListTile(
                        value: isChecked,
                        title: Text(subName),
                        activeColor: const Color(0xffFF3B30),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              provider.selectedSubIds.add(subId);
                              provider.selectedSubNames.add(subName);
                            } else {
                              provider.selectedSubIds.remove(subId);
                              provider.selectedSubNames.remove(subName);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );

      /// ---------------- PRICE RANGE ----------------
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Price Range",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: "Manrope",
                color: primaryClr,
              ),
            ),
            const SizedBox(height: 20),
            RangeSlider(
              values: priceRange,
              min: 0,
              max: 5000,
              activeColor: Color(0xffFF3B30),
              divisions: 20,
              labels: RangeLabels(
                "₹${priceRange.start.round()}",
                "₹${priceRange.end.round()}",
              ),
              onChanged: (values) {
                setState(() {
                  priceRange = values;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("₹${priceRange.start.round()}"),
                Text("₹${priceRange.end.round()}"),
              ],
            ),
          ],
        );

      /// ---------------- BRANDS ----------------
      case 2:
        return Consumer<ProjectProvider>(
          builder: (context, provider, _) {
            if (provider.brand) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.brandModel == null ||
                provider.brandModel!.brandsList == null ||
                provider.brandModel!.brandsList!.isEmpty) {
              return const Center(child: Text("No Brands Available"));
            }

            final brandList = provider.brandModel!.brandsList!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Brands",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: "Manrope",
                    color: primaryClr,
                  ),
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    itemCount: brandList.length,
                    itemBuilder: (context, index) {
                      final brand = brandList[index];
                      final String brandId = brand.id.toString();
                      final String brandName = brand.name ?? "";

                      // ✅ Check if this brand is already selected
                      final bool isChecked = selectedBrandIds.contains(brandId);

                      return CheckboxListTile(
                        value: isChecked,
                        title: Text(brandName),
                        activeColor: Color(0xffFF3B30),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              // ✅ Add brand ID and Name
                              selectedBrandIds.add(brandId);
                              selectedBrandNames.add(brandName);
                            } else {
                              // ✅ Remove brand ID and Name
                              selectedBrandIds.remove(brandId);
                              selectedBrandNames.remove(brandName);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );

      default:
        return const SizedBox();
    }
  }
}
