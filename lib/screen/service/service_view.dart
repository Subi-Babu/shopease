import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/custom_widgets/custom_button.dart';
import 'package:youbuilt/providers/signin/project_provider.dart';
import 'package:youbuilt/screen/projects/widgets/wallet.dart';

import '../../utils/colors.dart';
import '../sign_up.dart';

class ProductViewSectionPage extends StatelessWidget {
  const ProductViewSectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text("Service", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomButton(text: "Confirm Booking", onPress: () {}),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 SERVICE IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                "https://images.unsplash.com/photo-1581578731548-c64695cc6952",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16),

            /// 🔹 TITLE + RATING
            Row(
              children: const [
                Expanded(
                  child: Text(
                    "Deep Cleaning",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                Icon(Icons.star, color: Colors.orange, size: 18),
                SizedBox(width: 4),
                Text("4.5"),
              ],
            ),

            const SizedBox(height: 10),

            /// 🔹 DESCRIPTION
            const Text(
              "Complete deep cleaning of your home with professional equipment and trained staff.",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            /// 🔹 WORK PROCESS
            const Text(
              "Work Process",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            _bulletPoint("Inspection of service area"),
            _bulletPoint("Use of eco-friendly cleaning products"),
            _bulletPoint("Final quality check and review"),

            const SizedBox(height: 24),

            /// 🔹 BOOK SERVICE FORM
            const Text(
              "Book Your Service",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            CustomTextField(hintText: "Full Name", fillColor: Colors.white),
            const SizedBox(height: 12),
            CustomTextField(hintText: "Phone Number", fillColor: Colors.white),
            const SizedBox(height: 12),
            CustomTextField(hintText: "Project Type", fillColor: Colors.white),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Upload Image (If any)",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "Manrope",
                    fontSize: 14,
                    color: Color(0xff737373),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            uploadFileBox(
              title:
                  // project.fileFile == null
                  //     ?
                  "Upload file",
              // : project.fileFile!.path.split('/').last,
              onTap: () {
                // project.pickFileSection();
              },
            ),
            const SizedBox(height: 12),
            CustomTextField(hintText: "Message", fillColor: Colors.white),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 18)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _textField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xffF4F4F4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
