import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:youbuilt/providers/signin/project_provider.dart';
import 'package:youbuilt/screen/cart/cart.dart';
import 'package:youbuilt/screen/estimation/estimation.dart';
import 'package:youbuilt/screen/projects/add_projects.dart';
import 'package:youbuilt/screen/service/service_page.dart';
import 'package:youbuilt/utils/colors.dart';

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
    });
    // TODO: implement initState
    super.initState();
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
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Consumer<ProjectProvider>(
            builder: (context, project, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: ScreenUtil().screenHeight / 2.9,
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
                          Text(
                            project.profileModel?.data?.name ?? "",
                            style: TextStyle(
                              color: backgroundColor,
                              fontFamily: "Manrope",
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                            ),
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
                                "",
                                style: TextStyle(
                                  color: Color(0xffA3A3A3),
                                  fontFamily: "Manrope",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "Complete Profile 50%",
                                style: TextStyle(
                                  color: backgroundColor,
                                  fontFamily: "Manrope",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11.79.sp,
                                ),
                              ),
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
                              color: Color(0xffFF3B30),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllProductsPage(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
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
                      bottom: 5,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: Color(0xffF5F5F5),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              "assets/engineer_2941883.png",
                              height: 37,
                              width: 37,
                            ),
                          ),
                        ),
                        // SizedBox(width: 4),
                        CircleAvatar(
                          radius: 38,
                          backgroundColor: Color(0xffF5F5F5),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              "assets/construction_15901267.png",
                              height: 37,
                              width: 37,
                            ),
                          ),
                        ),

                        // SizedBox(width: 4),
                        CircleAvatar(
                          radius: 38,
                          backgroundColor: Color(0xffF5F5F5),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              "assets/planning_888979.png",
                              height: 37,
                              width: 37,
                            ),
                          ),
                        ),

                        // SizedBox(width: 4),
                        CircleAvatar(
                          radius: 38,
                          backgroundColor: Color(0xffF5F5F5),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              "assets/material_13830965.png",
                              height: 37,
                              width: 37,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text(
                          "Civil work",
                          style: TextStyle(
                            color: primaryClr,
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                        Text(
                          "Carpentry Wdork ",
                          style: TextStyle(
                            color: primaryClr,
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                        Text(
                          "Design & Plan",
                          style: TextStyle(
                            color: primaryClr,
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                        Text(
                          "Fabrication",
                          style: TextStyle(
                            color: primaryClr,
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  SizedBox(height: 50),
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
