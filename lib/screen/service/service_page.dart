import 'package:flutter/material.dart';
import 'package:youbuilt/screen/cart/view_cart.dart';
import 'package:youbuilt/screen/service/service_view.dart';

import '../cart/cart.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: const Text(
          "All Services",
          style: TextStyle(color: Colors.black),
        ),
        leading: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: Column(
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
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                _CategoryItem(
                  icon: Icons.construction,
                  title: "Building Material",
                ),
                _CategoryItem(icon: Icons.construction, title: "Fabrication"),
                _CategoryItem(icon: Icons.plumbing, title: "Plumbing"),
                _CategoryItem(
                  icon: Icons.electrical_services,
                  title: "Electrical",
                ),
                _CategoryItem(icon: Icons.edit, title: "Painting"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// Grid
          Expanded(
            child: GridView.builder(
              itemCount: 8,
              padding: EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductViewSectionPage(),
                      ),
                    );
                  },
                  child: const _ServiceCard(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _CategoryItem({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.network(
              "https://via.placeholder.com/150",
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Deep Cleaning",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 4),

                const Row(
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.orange),
                    SizedBox(width: 4),
                    Text("4.2 (500)", style: TextStyle(fontSize: 12)),
                  ],
                ),

                const SizedBox(height: 4),

                // Row(
                //   children: const [
                //     Text(
                //       "₹1,499",
                //       style: TextStyle(fontWeight: FontWeight.bold),
                //     ),
                //     SizedBox(width: 6),
                //     Text(
                //       "₹2500",
                //       style: TextStyle(
                //         fontSize: 12,
                //         decoration: TextDecoration.lineThrough,
                //         color: Colors.grey,
                //       ),
                //     ),
                //   ],
                // ),
                //
                // const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Add to Cart",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
