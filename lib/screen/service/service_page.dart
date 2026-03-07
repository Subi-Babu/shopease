import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/screen/cart/view_cart.dart';
import 'package:youbuilt/screen/service/service_view.dart';

import '../../providers/signin/project_provider.dart';
import '../../utils/colors.dart';
import '../cart/all_product.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = Provider.of<ProjectProvider>(context, listen: false);

      reg.fetchServiceList(context: context, id: "");
      reg.fetchServiceCategry(context: context);
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
          "All Services",
          style: TextStyle(
            color: primaryClr,
            fontFamily: "Manrope",
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, service, _) {
          return Column(
            children: [
              /// 🔍 Search
              Divider(color: Color(0xffE0E0E0)),
              // const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: EdgeInsets.all(12),
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xffDFDFDF)),
                  ),
                  child: TextField(
                    // controller: searchController,
                    onChanged: (value) {
                      // setDialogState(() {
                      //   searchQuery = value;
                      // });
                    },
                    decoration: InputDecoration(
                      hintText: "Search members",
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
                        padding: const EdgeInsets.only(left: 8),
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
              ),

              // filterSortRow(context),
              const SizedBox(height: 10),

              /// 🧱 Categories
              SizedBox(
                height: 110,
                child: Consumer<ProjectProvider>(
                  builder: (context, service, _) {
                    final categories =
                        service.serviceCategryListModel?.serviceCategoryList ??
                        [];

                    if (categories.isEmpty) {
                      return const Center(child: Text("No Categories"));
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];

                        return _CategoryItem(
                          title: category.name ?? "",
                          image: category.image ?? "",
                          isSelected:
                              service.selectedCategoryId1 ==
                              category.id.toString(),
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            service.fetchServiceList(
                              context: context,
                              id: category?.id.toString() ?? "",
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),

              /// Grid
              service.serviceModel?.serviceList?.length == 0
                  ? Text("No Service Available")
                  : Expanded(
                      child: GridView.builder(
                        itemCount:
                            service.serviceModel?.serviceList?.length ?? 0,
                        padding: EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.7,
                            ),
                        itemBuilder: (context, index) {
                          final serviceItem =
                              service.serviceModel?.serviceList?[index];
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
                                    service
                                        .serviceModel
                                        ?.serviceList?[index]
                                        ?.id
                                        .toString() ??
                                    "",
                              );
                            },
                            child: _ServiceCard(
                              image:
                                  service
                                      ?.serviceModel
                                      ?.serviceList?[index]
                                      .image
                                      .toString() ??
                                  "",
                              name:
                                  service
                                      .serviceModel
                                      ?.serviceList?[index]
                                      ?.name ??
                                  "",
                              rating: "0",
                              onPressed: () async {
                                HapticFeedback.heavyImpact();
                                await service.fetchServiceView(
                                  context: context,
                                  id:
                                      service
                                          .serviceModel
                                          ?.serviceList?[index]
                                          ?.id
                                          .toString() ??
                                      "",
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String title;
  final String image;
  final bool isSelected;
  final VoidCallback? onTap;

  const _CategoryItem({
    required this.title,
    required this.image,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              height: 60,
              width: 60,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: isSelected
                    ? Colors
                          .grey
                          .shade300 // ✅ Selected color
                    : const Color(0xffF5F5F5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.network(
                  image,
                  fit: BoxFit.fill,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image, size: 30),
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 70,
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
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final void Function()? onPressed;

  final String name;
  final String image;
  // final String price;
  final String rating;

  const _ServiceCard({
    required this.onPressed,
    required this.name,
    required this.image,
    // required this.price,
    required this.rating,
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
                        fit: BoxFit.fill,
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
                    rating ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // /// Price
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8),
            //   child: Text(
            //     "₹$price",
            //     style: const TextStyle(
            //       fontWeight: FontWeight.bold,
            //       fontSize: 15,
            //     ),
            //   ),
            // ),
            //
            // const SizedBox(height: 8),

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
                      child: const Text(
                        "Book Now",
                        style: TextStyle(color: Colors.white, fontSize: 13),
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
