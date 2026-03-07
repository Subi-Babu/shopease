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
import 'package:youbuilt/screen/service/service_page.dart';
import 'package:youbuilt/utils/colors.dart';
import 'package:youbuilt/utils/constants.dart';

import '../model/addressListModel.dart';

final List<String> imagecarousel = [
  'assets/Mask Group.png',
  'assets/Mask Group.png',
  'assets/Mask Group.png',
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = Provider.of<ProjectProvider>(context, listen: false);
      await reg.fetchProfile(context: context);
      await reg.fetchAddressList(context: context);

      await reg.fetchServiceList(context: context, id: "");
      await reg.fetchServiceCategry(context: context);
    });
    getCurrentLocation();
    // TODO: implement initState
    super.initState();
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1️⃣ Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return;
    }

    // 2️⃣ Check permission
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permission denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permission permanently denied");
      return;
    }

    // 3️⃣ Get position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // 4️⃣ Convert to address
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;

      setState(() {
        city = place.street; // Correct city
        state = place.locality; // Correct state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Android
        statusBarIconBrightness: Brightness.light, // Android icons
        statusBarBrightness: Brightness.dark, // iOS icons
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
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
                  Container(
                    height: ScreenUtil().screenHeight / 3,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage("assets/Ellipse 1682.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 45,
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
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
                          SizedBox(height: 30),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddressPage(),
                                    ),
                                  );
                                },
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
                              SizedBox(width: 4),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddressPage(),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.keyboard_arrow_down_sharp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 15,
                              ),
                              SizedBox(width: 5),
                              Text(
                                formatAddress(
                                  "${defaultAddress?.address ?? ""}, ${defaultAddress?.addressTitle ?? ""}",
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xffA3A3A3),
                                  fontFamily: "Manrope",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                ),
                              ),
                              SizedBox(width: 10),
                              Spacer(),
                              // InkWell(
                              //   onTap: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) => UserProfilePage(),
                              //       ),
                              //     );
                              //   },
                              //   child: Container(
                              //     padding: EdgeInsets.symmetric(
                              //       horizontal: 10,
                              //       vertical: 12,
                              //     ),
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(6),
                              //       color: Color(0xffFF3B30),
                              //     ),
                              //     child: Text(
                              //       "Complete Profile",
                              //       style: TextStyle(
                              //         color: backgroundColor,
                              //         fontFamily: "Manrope",
                              //         fontWeight: FontWeight.w700,
                              //         fontSize: 11.79.sp,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15, bottom: 15),
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.search, color: Color(0xff7A7A7A)),
                                SizedBox(width: 8),
                                Text(
                                  "What are you looking for?",
                                  style: TextStyle(
                                    color: Color(0xff7A7A7A),
                                    fontFamily: "Manrope",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 5,
                    ),
                    child: Text(
                      "Projects",
                      style: TextStyle(
                        color: primaryClr,
                        fontFamily: "Manrope",
                        fontWeight: FontWeight.w700,
                        fontSize: 22.sp,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 5,
                    ),

                    child: Row(
                      children: [
                        Text(
                          "Digitize and streamline the\nconstruction process",
                          style: TextStyle(
                            color: primaryClr,
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.w400,
                            fontSize: 15.sp,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => AddProjects()),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Color(0xff0D0D0D),
                              // color: primaryClr,
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.add, color: backgroundColor),
                                SizedBox(width: 4),
                                Text(
                                  "Add Project",
                                  style: TextStyle(
                                    color: backgroundColor,
                                    fontFamily: "Manrope",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllProductsPage(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Color(0xffF5F5F5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/solar_bag-check-bold.png",
                                  height: 35,
                                  width: 35,
                                ),
                                Text(
                                  "Purchase",
                                  style: TextStyle(
                                    color: primaryClr,
                                    fontFamily: "Manrope",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            HapticFeedback.heavyImpact();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ServicesPage(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Color(0xffF5F5F5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/fluent_toolbox-32-filled.png",
                                  height: 35,
                                  width: 35,
                                ),
                                Text(
                                  "Service",
                                  style: TextStyle(
                                    color: primaryClr,
                                    fontFamily: "Manrope",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Color(0xffF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/solar_clipboard-bold.png",
                                height: 35,
                                width: 35,
                              ),
                              Text(
                                "Rental",
                                style: TextStyle(
                                  color: primaryClr,
                                  fontFamily: "Manrope",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            HapticFeedback.heavyImpact();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EstimationPage(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Color(0xffF5F5F5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/solar_clipboard-bold.png",
                                  height: 35,
                                  width: 35,
                                ),
                                Text(
                                  "Quote",
                                  style: TextStyle(
                                    color: primaryClr,
                                    fontFamily: "Manrope",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  OfferCarouselWidget(
                    imageCarousel: imagecarousel,
                    controller: CarouselSliderController(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 5,
                    ),
                    child: Text(
                      "Featured Services ",
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
                        Spacer(),
                        Text(
                          "View All",
                          style: TextStyle(
                            color: Color(0xffFF3B30),
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];

                            return InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ServicesPage(),
                                  ),
                                );
                              },
                              child: _CategoryItem(
                                title: category.name ?? "",
                                image: category.image ?? "",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ServicesPage(),
                                    ),
                                  );
                                  // service.fetchServiceList(
                                  //   context: context,
                                  //   categoryId: category.id.toString(),
                                  // );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // const SizedBox(height: 10),
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

                        // 🔹 TEXT SECTION TAKES REMAINING WIDTH
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
                                SizedBox(height: 6),
                                Text(
                                  "Get expert guidance for your\nconstruction project — absolutely free!",
                                  style: TextStyle(
                                    color: primaryClr,
                                    fontFamily: "Manrope",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.sp,
                                  ),
                                ),

                                // 🔹 ARROW ALIGN RIGHT
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
                  SizedBox(height: 10),
                  SupportTeamCard(),
                  Image.asset(
                    "assets/Group 1171275262.png",
                    width: double.infinity,
                  ),
                  SizedBox(height: 90),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

ValueNotifier<int> _current = ValueNotifier(0);

class OfferCarouselWidget extends StatelessWidget {
  const OfferCarouselWidget({
    super.key,
    required CarouselSliderController controller, // FIXED HERE
    required this.imageCarousel,
  }) : _controller = controller;

  final CarouselSliderController _controller; // FIXED HERE
  final List<String> imageCarousel;

  @override
  Widget build(BuildContext context) {
    const IndicatorEffect effect = ExpandingDotsEffect(
      dotColor: Colors.black54,
      activeDotColor: primaryClr,
      dotWidth: 5.0,
      dotHeight: 7.0,
      expansionFactor: 4,
    );

    return ValueListenableBuilder(
      valueListenable: _current,
      builder: (context, int newIndex, _) {
        return Column(
          children: [
            SizedBox(
              // width: double.infinity,
              // height: 200,
              child: CarouselSlider(
                carouselController: _controller,
                items: imageCarousel
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            children: [
                              // 🔹 Background Image
                              Image.asset(
                                e,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),

                              // 🔹 Dark gradient for text readability
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

                              // 🔹 TEXT ON LEFT
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
                                  children: [
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
                  viewportFraction: 0.75, // 👈 KEY
                  padEnds: false, // 👈 KEY
                  enlargeCenterPage: false,
                  onPageChanged: (index, _) {
                    _current.value = index;
                  },
                ),
              ),
            ),

            // SmoothIndicator(
            //   offset: newIndex.toDouble(),
            //   count: imageCarousel.length,
            //   effect: effect,
            //   size: effect.calculateSize(imageCarousel.length),
            // ),
          ],
        );
      },
    );
  }
}

const Color primaryClr = Color(0xFF1A1A2E); // deep navy – replace with yours
const Color accentRed = Color(0xFFE53935);

// ─────────────────────────────────────────────
// 1.  SUPPORT TEAM CARD
// ─────────────────────────────────────────────
class SupportTeamCard extends StatelessWidget {
  const SupportTeamCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 40, right: 40),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Color(0xffF4F4F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Brand row ──
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

            // ── Action buttons ──
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
                    } else {
                      debugPrint("Could not launch $phoneUri");
                    }
                  },
                ),
                const SizedBox(width: 10),
                _SupportActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: "Chat",
                  onTap: () {
                    launchContactUs();
                  },
                ),
                const SizedBox(width: 10),
                _SupportActionButton(
                  icon: Icons.assignment_outlined,
                  label: "Ticket",
                  onTap: () {
                    launchContactUs();
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Working hours ──
            Text(
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
            border: Border.all(color: Color(0xffDFDFDF)),
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

// ─────────────────────────────────────────────
// 2.  HERO BANNER  –  "Everything You Need to Build"
// ─────────────────────────────────────────────
class EverythingHeroBanner extends StatelessWidget {
  const EverythingHeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFF8F8F8), Color(0xFFEEEEEE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // ── Blueprint grid overlay ──
          Positioned.fill(child: CustomPaint(painter: _GridPainter())),

          // ── Construction sketch illustration placeholder ──
          Positioned(
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.18,
              child: Image.network(
                // Replace with your assets:  AssetImage("assets/construction_sketch.png")
                "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Construction_worker_icon.svg/480px-Construction_worker_icon.svg.png",
                width: 180,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox(
                  width: 180,
                  child: Icon(
                    Icons.construction,
                    size: 100,
                    color: Colors.black26,
                  ),
                ),
              ),
            ),
          ),

          // ── Text content ──
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Everything You\nNeed to Build",
                  style: TextStyle(
                    fontFamily: "Manrope",
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: primaryClr,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 3,
                  decoration: BoxDecoration(
                    color: accentRed,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Construction Made Simple",
                  style: TextStyle(
                    fontFamily: "Manrope",
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    letterSpacing: 0.4,
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

/// Light blueprint-style dot grid
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.15)
      ..strokeWidth = 1;

    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

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
              padding: EdgeInsets.all(12),
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
                // overflow: TextOverflow.ellipsis,
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

String formatAddress(String text) {
  if (text.length <= 20) return text;
  return "${text.substring(0, 20)}...";
}
