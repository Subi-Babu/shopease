import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/screen/cart/addcart.dart';
import 'package:youbuilt/screen/cart/view_cart.dart';
import 'package:youbuilt/screen/service/filter.dart';

import '../../providers/signin/project_provider.dart';
import '../../utils/colors.dart';
import 'mycart2.dart';

final TextEditingController searchController = TextEditingController();

class AllProductsPage extends StatefulWidget {
  final String? keyword;

  const AllProductsPage({super.key, this.keyword});

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  @override
  void initState() {
    searchController.text = widget.keyword ?? "";
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = Provider.of<ProjectProvider>(context, listen: false);
      // reg.fetchItemLists(context: context, endPrice: "", catid: "", keywrd: "");
      // searchController = TextEditingController(
      //   text: widget.keyword ?? "",
      // );
      reg.fetchItemLists(
        context: context,
        endPrice: "",
        catid: "",
        keywrd: widget.keyword ?? "",
      );

      reg.fetchCategoryLists(context: context);
      reg.fetchBrand(context: context);
      reg.fetchCartList(context: context);
      reg.selectedSort = null;
      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Consumer<ProjectProvider>(
        builder: (context, items, _) {
          /// 🔹 Show loader
          // if (items.itemLoading) {
          //   return Container(
          //     height: 60,
          //     margin: const EdgeInsets.all(16),
          //     decoration: BoxDecoration(
          //       color: Colors.black,
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     child: const Center(
          //       child: CircularProgressIndicator(
          //         color: Colors.white,
          //         strokeWidth: 2,
          //       ),
          //     ),
          //   );
          // }

          int cartCount = items.cartListModel?.data?.length ?? 0;

          /// 🔹 Hide if empty
          if (cartCount == 0) return const SizedBox();

          return Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$cartCount Item${cartCount > 1 ? 's' : ''} Added",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    elevation: 0,
                  ),
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyCartPage2(),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Text("View Cart", style: TextStyle(color: Colors.white)),
                      SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,

        title: Text(
          "All Products",
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
          final categories = items.categroyListModel?.categoryList ?? [];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(color: Color(0xffE0E0E0)),

                /// 🔍 Search
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    bottom: 10,
                    top: 5,
                    right: 16,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xffDFDFDF)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            onSubmitted: (value) async {
                              if (value.isNotEmpty) {
                                await context
                                    .read<ProjectProvider>()
                                    .fetchItemLists(
                                      context: context,
                                      catid: "",
                                      endPrice: "",
                                      keywrd: value,
                                    );
                              }
                            },
                            onChanged: (value) async {
                              if (value.isNotEmpty) {
                                await context
                                    .read<ProjectProvider>()
                                    .fetchItemLists(
                                      context: context,
                                      catid: "",
                                      endPrice: "",
                                      keywrd: value,
                                    );
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Search products",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 10,
                              ),
                              hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Manrope",
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  bottom: 2,
                                ),
                                child: Image.asset(
                                  "assets/search.png",
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                              prefixIconConstraints: BoxConstraints(
                                minHeight: 20,
                                minWidth: 30,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            searchController.clear();
                            await context
                                .read<ProjectProvider>()
                                .fetchItemLists(
                                  context: context,
                                  endPrice: "",
                                  catid: "",
                                  keywrd: "",
                                );
                          },
                          child: const Icon(Icons.close, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),

                /// 🔽 Filter & Sort
                filterSortRow(context),

                /// 🧱 Categories
                Consumer<ProjectProvider>(
                  builder: (context, items, _) {
                    final categories =
                        items.categroyListModel?.categoryList ?? [];

                    return SizedBox(
                      height: 100.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: categories.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () async {
                                HapticFeedback.heavyImpact();

                                await items.fetchItemLists(
                                  context: context,
                                  endPrice: "",
                                  catid: "",
                                  keywrd: "",
                                );
                                items.setSelectedCategory(""); //
                              },
                              child: _CategoryItem(
                                icon: "assets/planning_888979.png",
                                title: "All",
                                isAsset: true,
                                isSelected: items.selectedCategoryId == "",
                              ),
                            );
                          }

                          final category = categories[index - 1];

                          return InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async {
                              HapticFeedback.heavyImpact();

                              items.setSelectedCategory(
                                category.id.toString(),
                              ); // 👈 SET FIRST

                              await items.fetchItemLists(
                                context: context,
                                endPrice: "",
                                keywrd: "",
                                catid: category.id.toString(),
                              );
                              items.setSelectedCategory(category.id.toString());
                              await items.fetchSubCategoryLists(
                                context: context,
                                catId: category?.id.toString() ?? "",
                              );
                            },
                            child: _CategoryItem(
                              icon: category.image ?? "",
                              title: category.name ?? "",
                              isAsset: false,
                              isSelected:
                                  items.selectedCategoryId ==
                                  category.id.toString(),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),

                /// 🛍 Product Grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: items.itemLoading == true
                      ? const Center(
                          child: CircularProgressIndicator(color: primaryClr),
                        )
                      : items.itemListModel?.itemList?.length == 0
                      ? Center(child: Text("No data"))
                      : GridView.builder(
                          shrinkWrap: true, // ✅ VERY IMPORTANT
                          physics:
                              const NeverScrollableScrollPhysics(), // ✅ Disable inner scroll
                          itemCount: items.itemListModel?.itemList?.length ?? 0,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.63,
                              ),
                          itemBuilder: (context, index) {
                            final item = items.itemListModel?.itemList?[index];

                            print("NAME: ${item?.item?.name}");
                            print("IMAGES: ${item?.item?.itemImages}");
                            final imageUrl =
                                item?.item?.itemImages?.isNotEmpty == true
                                ? item!.item!.itemImages!.first.image ?? ""
                                : "";
                            return InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () async {
                                await items.fetchItemListDetails(
                                  context: context,
                                  id: item?.id.toString() ?? "",
                                );
                              },
                              child: ProductCard(
                                load:
                                    items.cartLoadingMap[item?.itemId
                                            ?.toString() ??
                                        ""] ??
                                    false,
                                name:
                                    items
                                        .itemListModel
                                        ?.itemList?[index]
                                        ?.item
                                        ?.name ??
                                    "",
                                image: imageUrl ?? "",
                                price: item?.yourPrice?.toString() ?? "",
                                rating: "",
                                onPressed: () async {
                                  HapticFeedback.heavyImpact();

                                  int qty = 1;

                                  double yourPrice =
                                      double.tryParse(
                                        item?.yourPrice?.toString() ?? "0",
                                      ) ??
                                      0;

                                  double calPrice = yourPrice * qty;

                                  /// ✅ Immediately update cart count UI
                                  items.addLocalCartItem(
                                    item?.itemId?.toString() ?? "",
                                  );

                                  /// ✅ Call API in background
                                  await items.addtoCart(
                                    context: context,
                                    projectId: "",
                                    calPrice: calPrice.toString(),
                                    storeId: item?.storeId?.toString() ?? "",
                                    itemId: item?.itemId?.toString() ?? "",
                                    mrp: item?.mrp?.toString() ?? "",
                                    qty: qty.toString(),
                                    categoryId: "",
                                    attributeCategory: [],
                                    attributeName: {},
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String image;
  final String price;
  final String rating;
  final bool load;
  final void Function()? onPressed;

  const ProductCard({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    this.load = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffDFDFDF)),
      ),
      // ✅ FIX 2: ClipRect prevents any child from painting outside the box
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // ✅ FIX 3: mainAxisSize.min so column doesn't try to stretch
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Product Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: image.isNotEmpty
                    ? Image.network(
                        image,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 5),

            /// Product Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                height: 36, // 👈 FIXED HEIGHT (2 lines space)
                child: Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 1.0, // optional better spacing
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),

            /// Rating
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    rating.isNotEmpty ? rating : "0.0",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            /// Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "₹$price",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),

            const SizedBox(height: 8),

            /// ✅ FIX 4: Spacer pushes button to bottom only if space allows
            /// Add to Cart Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 36,
                width: double.infinity,
                child: Consumer<ProjectProvider>(
                  builder: (context, items, _) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: onPressed,
                      child: load == true
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Add to Cart",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String icon;
  final String title;
  final bool isAsset;
  final bool isSelected;

  const _CategoryItem({
    required this.icon,
    required this.title,
    required this.isAsset,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors
                        .grey
                        .shade300 // 👈 Selected color
                  : const Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(60),
            ),
            child: isAsset
                ? Image.asset(icon, fit: BoxFit.fill)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: icon.isNotEmpty
                        ? Image.network(
                            icon,
                            fit: BoxFit.fill,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image, size: 24);
                            },
                          )
                        : const Icon(Icons.image, size: 24),
                  ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 60,
            child: Text(
              title,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

Widget filterSortRow(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      children: [
        /// Filter Button
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FilterPage()),
            );
          },
          child: Container(
            height: 45,
            width: 80,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xffE5E5E5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Filter",
                  style: TextStyle(
                    fontSize: 12,
                    color: primaryClr,
                    fontFamily: "Manrope",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.sort, size: 18),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        /// Sort By Button
        // Consumer<ProjectProvider>(
        //   builder: (context, items, _) {
        //     return Container(
        //       height: 45,
        //       width: 130,
        //       padding: const EdgeInsets.symmetric(horizontal: 12),
        //       decoration: BoxDecoration(
        //         color: Colors.white,
        //         borderRadius: BorderRadius.circular(10),
        //         border: Border.all(color: const Color(0xffE5E5E5)),
        //       ),
        //       child: DropdownButtonHideUnderline(
        //         child: DropdownButton<String>(
        //           value: items.selectedSort,
        //           hint: const Text(
        //             "Sort By",
        //             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        //           ),
        //           isExpanded: true,
        //           items: const [
        //             DropdownMenuItem(
        //               value: "low-to-high",
        //               child: Text("Low to High"),
        //             ),
        //             DropdownMenuItem(
        //               value: "high-to-low",
        //               child: Text("High to Low"),
        //             ),
        //           ],
        //           onChanged: (value) {
        //             if (value != null) {
        //               items.setSelectedSort(value);
        //               print("$value");
        //               items.fetchItemLists2(
        //                 context: context,
        //                 startPrice: "",
        //                 endPrice: "",
        //                 catid: "",
        //                 brandiid: "",
        //                 sort: value,
        //               );
        //             }
        //           },
        //         ),
        //       ),
        //     );
        //   },
        // ),
      ],
    ),
  );
}
