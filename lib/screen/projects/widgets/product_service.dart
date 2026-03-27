import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/providers/signin/project_provider.dart';
import 'package:youbuilt/screen/profile/service_booking.dart';
import 'package:youbuilt/screen/service/service_page.dart';

import '../../../utils/colors.dart';
import '../../cart/all_product.dart';
import '../../cart/mycart2.dart';

class ProductServicePage extends StatefulWidget {
  final String? id;
  ProductServicePage({super.key, required this.id});

  @override
  State<ProductServicePage> createState() => _ProductServicePageState();
}

class _ProductServicePageState extends State<ProductServicePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = Provider.of<ProjectProvider>(context, listen: false);

      reg.fetchItemLists(context: context, endPrice: "", catid: "", keywrd: "");
      reg.fetchCategoryLists(context: context);
      reg.fetchBrand(context: context);
      reg.fetchCartList(context: context);
      reg.fetchServiceList(context: context, id: "", keywrd: "");
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,

      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: AnimatedBuilder(
          animation: _tabController,
          builder: (context, _) {
            /// ✅ Show ONLY in Products tab
            if (_tabController.index != 0) {
              return const SizedBox();
            }

            return Consumer<ProjectProvider>(
              builder: (context, items, _) {
                int cartCount = items.cartListModel?.data?.length ?? 0;

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
                            Text(
                              "View Cart",
                              style: TextStyle(color: Colors.white),
                            ),
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
            );
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back),
          ),

          elevation: 0,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Text(
            "All Products",
            style: TextStyle(
              color: primaryClr,
              fontFamily: "Manrope",
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
            ),
          ),
          centerTitle: false,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Column(
              children: [
                /// 🔍 Search
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    bottom: 5,
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
                            // controller: searchController,
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
                            // searchController.clear();
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
                TabBar(
                  controller: _tabController,
                  unselectedLabelColor: const Color(0xff737373),
                  indicatorColor: const Color(0xffFF3B30),
                  labelColor: primaryClr,
                  overlayColor: const WidgetStatePropertyAll(
                    Colors.transparent,
                  ),
                  labelStyle: TextStyle(
                    fontFamily: "Manrope",
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                  tabs: const [
                    Tab(text: "Products"),
                    Tab(text: "Services"),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [productOrders(), serviceOrders()],
        ),
      ),
    );
  }

  /// PRODUCT ORDERS TAB
  Widget productOrders() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Consumer<ProjectProvider>(
        builder: (context, items, _) {
          final categories = items.categroyListModel?.categoryList ?? [];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🛍 Product Grid
                items.itemLoading == true
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
                              childAspectRatio: 0.6,
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
                                projectid: widget.id ?? "",
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
                                  projectId: widget.id ?? "",
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

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  /// SERVICE ORDERS TAB
  Widget serviceOrders() {
    return Consumer<ProjectProvider>(
      builder: (context, service, _) {
        return service.serviceModel?.serviceList?.length == 0
            ? Text("No Service Available")
            : GridView.builder(
                itemCount: service.serviceModel?.serviceList?.length ?? 0,
                padding: EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final serviceItem = service.serviceModel?.serviceList?[index];
                  // final imageUrl =
                  //     service?.serviceModel?.serviceList?[index].fileName ==
                  //         true
                  //     ? item!.item!.itemImages!.first.image ?? ""
                  //     : "";
                  return InkWell(
                    onTap: () async {
                      HapticFeedback.heavyImpact();

                      await service.fetchServiceView(
                        context: context,
                        id:
                            service.serviceModel?.serviceList?[index]?.id
                                .toString() ??
                            "",
                      );
                    },
                    child: ServiceCard(
                      image:
                          service?.serviceModel?.serviceList?[index].image
                              .toString() ??
                          "",
                      name:
                          service.serviceModel?.serviceList?[index]?.name ?? "",
                      rating: "0",
                      onPressed: () async {
                        HapticFeedback.heavyImpact();
                        await service.fetchServiceView(
                          context: context,
                          id:
                              service.serviceModel?.serviceList?[index]?.id
                                  .toString() ??
                              "",
                        );
                      },
                    ),
                  );
                },
              );
      },
    );
  }
}
