import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youbuilt/providers/signin/project_provider.dart';
import 'package:youbuilt/screen/cart/all_product.dart';
import 'package:youbuilt/screen/estimation/estimation.dart';
import 'package:youbuilt/screen/profile/address.dart';
import 'package:youbuilt/screen/profile/edit_profile.dart';
import 'package:youbuilt/screen/profile/profile.dart';
import 'package:youbuilt/screen/projects/add_projects.dart';
import 'package:youbuilt/screen/projects/projects.dart';
import 'package:youbuilt/screen/rental/rental_page.dart';
import 'package:youbuilt/screen/search.dart';
import 'package:youbuilt/screen/service/service_page.dart';
import 'package:youbuilt/utils/colors.dart';
import 'package:youbuilt/utils/constants.dart';

import '../model/addressListModel.dart';

final List<String> imagecarousel = [
  'assets/Mask Group.png',
  'assets/Mask Group.png',
  'assets/Mask Group.png',
];

// Height of the frozen top bar (logo row + status bar padding).
// SafeArea handles status bar automatically, so we only need the logo row height.
const double _kFrozenBarContentHeight = 50.0;

String? city;
String? state;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = Provider.of<ProjectProvider>(context, listen: false);
      await reg.fetchProfile(context: context);
      await reg.fetchAddressList(context: context);
      await reg.fetchServiceList(context: context, id: "", keywrd: "");
      await reg.fetchServiceCategry(context: context);
      // await reg.fetchSearch(context: context, keyword: "");
      reg.fetchProjectList(context: context, status: "");
    });
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      setState(() {
        city = place.street;
        state = place.locality;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate top padding for the scroll content so it starts below the frozen bar.
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double frozenBarTotalHeight =
        statusBarHeight + _kFrozenBarContentHeight;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // ─────────────────────────────────────────────────────────────
            // 1. SCROLLABLE BODY
            // ─────────────────────────────────────────────────────────────
            SingleChildScrollView(
              child: Consumer<ProjectProvider>(
                builder: (context, project, _) {
                  final addressList = project.addressListModel?.data ?? [];
                  Datum? defaultAddress;
                  if (addressList.isNotEmpty) {
                    defaultAddress = addressList.firstWhere(
                      (element) => element.isDefault == true,
                      orElse: () => addressList.first,
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Coloured header (sits behind the frozen bar at the top)
                      Container(
                        // Extra top padding so name / search aren't hidden under the frozen bar
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: frozenBarTotalHeight + 4,
                          bottom: 25,
                        ),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/Ellipse 1682.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name + dropdown arrow
                            Row(
                              children: [
                                InkWell(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddressPage(),
                                    ),
                                  ),
                                  child: Text(
                                    project.profileModel?.data?.name ?? "",
                                    style: TextStyle(
                                      color: backgroundColor,
                                      fontFamily: "Manrope",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                InkWell(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddressPage(),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),

                            // Address row
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                  size: 15,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  formatAddress(
                                    "${defaultAddress?.address ?? ""}, ${defaultAddress?.addressTitle ?? ""}",
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: const Color(0xffA3A3A3),
                                    fontFamily: "Manrope",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),

                            // Search bar
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        SearchResultPage(keyword: ""),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                  top: 15,
                                  bottom: 0,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.search,
                                      color: Color(0xff7A7A7A),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "What are you looking for?",
                                      style: TextStyle(
                                        color: const Color(0xff7A7A7A),
                                        fontFamily: "Manrope",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── My Projects banner
                      Container(
                        height: 100,
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 10,
                          bottom: 10,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage("assets/bgg.png"),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "My Projects",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Manrope",
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                Text(
                                  "${project.projectListModel?.statusCount?.inProcess ?? ""}  Active Project",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Manrope",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProjectScreen(),
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: const Color(0xffFF3B30),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "View Projects",
                                      style: TextStyle(
                                        color: backgroundColor,
                                        fontFamily: "Manrope",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.keyboard_arrow_right_outlined,
                                      color: backgroundColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── Quick action icons (Purchase / Service / Rental / Quote)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 15,
                        ),
                        child: Row(
                          children: [
                            // Purchase
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  HapticFeedback.heavyImpact();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AllProductsPage(),
                                    ),
                                  );
                                },
                                child: _QuickActionTile(
                                  image: "assets/solar_bag-check-bold.png",
                                  label: "Purchase",
                                ),
                              ),
                            ),
                            // Service
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  HapticFeedback.heavyImpact();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ServicesPage(),
                                    ),
                                  );
                                },
                                child: _QuickActionTile(
                                  image: "assets/fluent_toolbox-32-filled.png",
                                  label: "Service",
                                ),
                              ),
                            ),
                            // Rental (no nav yet)
                            // Quote
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  HapticFeedback.heavyImpact();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EstimationPage(),
                                    ),
                                  );
                                },
                                child: _QuickActionTile(
                                  image: "assets/solar_clipboard-bold.png",
                                  label: "Quotation",
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  HapticFeedback.heavyImpact();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => RentalPage(),
                                    ),
                                  );
                                },
                                child: _QuickActionTile(
                                  image: "assets/solar_clipboard-bold.png",
                                  label: "Rental",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ── Offer carousel
                      OfferCarouselWidget(
                        imageCarousel: imagecarousel,
                        controller: CarouselSliderController(),
                      ),

                      // ── Featured Services heading
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 5,
                        ),
                        child: Text(
                          "Featured Services",
                          style: TextStyle(
                            color: primaryClr,
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 4,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Quality services for every build.",
                              style: TextStyle(
                                color: primaryClr,
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "View All",
                              style: TextStyle(
                                color: const Color(0xffFF3B30),
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.w700,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── Service category horizontal list
                      SizedBox(
                        height: 110.h,
                        child: Consumer<ProjectProvider>(
                          builder: (context, service, _) {
                            final categories =
                                service
                                    .serviceCategryListModel
                                    ?.serviceCategoryList ??
                                [];
                            if (categories.isEmpty) {
                              return const Center(child: Text("No Categories"));
                            }
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                final category = categories[index];
                                return InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ServicesPage(),
                                    ),
                                  ),
                                  child: _CategoryItem(
                                    title: category.name ?? "",
                                    image: category.image ?? "",
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ServicesPage(),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),

                      // ── Free consultation card
                      Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xffDFDFDF),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/172 1.png",
                              height: 140.h,
                              width: 157,
                              fit: BoxFit.cover,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 12,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Book your free\nconsultation",
                                      style: TextStyle(
                                        color: primaryClr,
                                        fontFamily: "Manrope",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Get expert guidance for your\nconstruction project — absolutely free!",
                                      style: TextStyle(
                                        color: primaryClr,
                                        fontFamily: "Manrope",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                        Icons.arrow_forward_sharp,
                                        color: primaryClr,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),
                      const SupportTeamCard(),
                      Image.asset(
                        "assets/Group 1171275262.png",
                        width: double.infinity,
                      ),
                      const SizedBox(height: 90),
                    ],
                  );
                },
              ),
            ),

            // ─────────────────────────────────────────────────────────────
            // 2. FROZEN HEADER  —  logo left, notification icon right
            //    Sits on top of the scroll; SafeArea handles status bar.
            // ─────────────────────────────────────────────────────────────
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/Ellipse 1682.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: SizedBox(
                    height: _kFrozenBarContentHeight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "assets/Logo2 1.png",
                            height: 34,
                            width: 120.w,
                          ),
                          Image.asset(
                            "assets/Frame 81.png",
                            height: 30.h,
                            width: 30.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Quick action tile (Purchase / Service / Rental / Quote)
// ─────────────────────────────────────────────────────────────────────────────
class _QuickActionTile extends StatelessWidget {
  final String image;
  final String label;

  const _QuickActionTile({required this.image, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 30, width: 30),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: primaryClr,
              fontFamily: "Manrope",
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Carousel
// ─────────────────────────────────────────────────────────────────────────────
ValueNotifier<int> _current = ValueNotifier(0);

class OfferCarouselWidget extends StatelessWidget {
  const OfferCarouselWidget({
    super.key,
    required CarouselSliderController controller,
    required this.imageCarousel,
  }) : _controller = controller;

  final CarouselSliderController _controller;
  final List<String> imageCarousel;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _current,
      builder: (context, int newIndex, _) {
        return Column(
          children: [
            CarouselSlider(
              carouselController: _controller,
              items: imageCarousel
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10, left: 15),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            Image.asset(
                              e,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Colors.black.withOpacity(0.6),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 16,
                              top: 10,
                              child: Image.asset(
                                "assets/Logo2 1.png",
                                height: 25,
                                width: 90,
                              ),
                            ),
                            Positioned(
                              left: 16,
                              bottom: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "40% Off",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 21.1,
                                      fontFamily: "Manrope",
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "On First Deep Cleaning Service",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontFamily: "Manrope",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 25),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                autoPlay: false,
                height: 180,
                viewportFraction: 0.75,
                padEnds: false,
                enlargeCenterPage: false,
                onPageChanged: (index, _) {
                  _current.value = index;
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Support Team Card
// ─────────────────────────────────────────────────────────────────────────────
const Color primaryClr = Color(0xFF1A1A2E);
const Color accentRed = Color(0xFFE53935);

class SupportTeamCard extends StatelessWidget {
  const SupportTeamCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 40, right: 40),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xffF4F4F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/Image.png", height: 58, width: 58),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Support Team",
                      style: TextStyle(
                        fontFamily: "Manrope",
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: primaryClr,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Seamless assistance to keep\nyour projects moving",
                      style: TextStyle(
                        fontFamily: "Manrope",
                        fontSize: 11,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _SupportActionButton(
                  icon: Icons.phone_outlined,
                  label: "Call",
                  onTap: () async {
                    final Uri phoneUri = Uri(
                      scheme: 'tel',
                      path: '+91 9778083067',
                    );
                    if (await canLaunchUrl(phoneUri)) {
                      await launchUrl(phoneUri);
                    }
                  },
                ),
                const SizedBox(width: 10),
                _SupportActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: "Chat",
                  onTap: () => launchContactUs(),
                ),
                const SizedBox(width: 10),
                _SupportActionButton(
                  icon: Icons.assignment_outlined,
                  label: "Ticket",
                  onTap: () => launchContactUs(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              "Working Hour : 7PM – 9AM",
              style: TextStyle(
                fontFamily: "Manrope",
                fontSize: 12,
                color: primaryClr,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SupportActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xffDFDFDF)),
          ),
          child: Column(
            children: [
              Icon(icon, color: primaryClr, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: "Manrope",
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: primaryClr,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Category item (horizontal service list)
// ─────────────────────────────────────────────────────────────────────────────
class _CategoryItem extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback? onTap;

  const _CategoryItem({required this.title, required this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              height: 65,
              width: 65,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(65),
                color: const Color(0xffF5F5F5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image, size: 30),
                ),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 80,
              child: Text(
                title,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────
String formatAddress(String text) {
  if (text.length <= 20) return text;
  return "${text.substring(0, 20)}...";
}
