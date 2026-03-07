import 'package:flutter/material.dart';
import 'package:youbuilt/screen/profile/orders.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// ✅ Green Check Circle
              Container(
                height: 90,
                width: 90,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 50),
              ),

              const SizedBox(height: 30),

              /// Title
              const Text(
                "Order Placed Successfully",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              /// Subtitle
              const Text(
                "Please Track your order in My Orders in Profile Section",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: "Manrope",
                ),
              ),

              const SizedBox(height: 30),

              /// Track Order Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyOrdersPage()),
                  );
                  ;
                  // Or navigate to Orders Page
                },
                child: const Text(
                  "Track Order",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
