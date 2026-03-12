import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/model/search_model.dart';
import 'package:youbuilt/providers/signin/project_provider.dart';
import 'package:youbuilt/screen/cart/all_product.dart';
import 'package:youbuilt/screen/service/service_page.dart';

import '../utils/colors.dart';

class SearchResultPage extends StatefulWidget {
  final String keyword;

  const SearchResultPage({super.key, required this.keyword});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.keyword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// APP BAR
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xff7A7A7A)),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Color(0xff7A7A7A)),
              const SizedBox(width: 8),

              /// SEARCH FIELD
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search for Services",
                  ),
                  onSubmitted: (value) async {
                    if (value.isNotEmpty) {
                      await context.read<ProjectProvider>().fetchSearch(
                        context: context,
                        keyword: value,
                      );
                    }
                  },
                  onChanged: (value) async {
                    if (value.isNotEmpty) {
                      await context.read<ProjectProvider>().fetchSearch(
                        context: context,
                        keyword: value,
                      );
                    }
                  },
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Manrope",
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
              ),

              /// CLEAR BUTTON
              GestureDetector(
                onTap: () {
                  controller.clear();
                  context.read<ProjectProvider>().fetchSearch(
                    context: context,
                    keyword: "",
                  );
                },
                child: const Icon(Icons.close, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),

      /// BODY
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// SEARCH TITLE
          // Padding(
          //   padding: const EdgeInsets.all(12),
          //   child: Text(
          //     "Showing results for ${controller.text}",
          //     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          //   ),
          // ),

          /// SEARCH RESULTS
          Consumer<ProjectProvider>(
            builder: (context, provider, child) {
              final products = provider.searchModel?.itemList ?? [];
              final services = provider.searchModel?.serviceList ?? [];

              if (products.isEmpty && services.isEmpty) {
                return const Expanded(child: EmptySearchWidget());
              }

              return Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// PRODUCTS SECTION
                      if (products.isNotEmpty) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Products",
                                style: TextStyle(
                                  fontSize: 16,

                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  HapticFeedback.heavyImpact();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AllProductsPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "View All",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Manrope",
                                    color: Colors.red,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 170,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final item = products[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: SizedBox(
                                  width: 120,
                                  child: ProductCard(
                                    item: item,
                                    onTap: () {
                                      HapticFeedback.heavyImpact();
                                      provider.fetchItemListDetails(
                                        context: context,
                                        id: item?.id.toString() ?? "",
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],

                      /// SERVICES SECTION
                      if (services.isNotEmpty) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Services",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  HapticFeedback.heavyImpact();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ServicesPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "View All",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Manrope",
                                    color: Colors.red,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 170,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: services.length,
                            itemBuilder: (context, index) {
                              final item = services[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: SizedBox(
                                  width: 140,
                                  child: ProductCard(
                                    item: item,
                                    onTap: () {
                                      HapticFeedback.heavyImpact();
                                      provider.fetchServiceView(
                                        context: context,
                                        id: item?.id.toString() ?? "",
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ItemListElement item;
  final void Function()? onTap;
  const ProductCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.image ?? "",
                fit: BoxFit.fill,
                height: 100,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return SizedBox(
                    height: 100,
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 40),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            item.name ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class EmptySearchWidget extends StatelessWidget {
  const EmptySearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/Group 1171275275.png", height: 150),

          const SizedBox(height: 12),

          const Text("No results found.", style: TextStyle(fontSize: 16)),

          const SizedBox(height: 4),

          const Text(
            "Search another item",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
