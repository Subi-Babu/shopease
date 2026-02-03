import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/custom_widgets/custom_button.dart';
import 'package:youbuilt/screen/sign_up.dart';
// import 'package:youbuilt/sign_up.dart';
import 'package:youbuilt/utils/colors.dart';

import '../../providers/signin/project_provider.dart';

class AddProjects extends StatelessWidget {
  const AddProjects({super.key});

  @override
  Widget build(BuildContext context) {
    final projectProvider = context.watch<ProjectProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Create Project",
          style: TextStyle(
            color: primaryClr,
            fontFamily: "Manrope",
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔼 Scrollable Form Section
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextField(
                      hintText: "Project Title",
                      fillColor: Colors.white,
                      controller: projectProvider.titleCntrl,
                    ),
                    const SizedBox(height: 8),

                    CustomTextField(
                      hintText: "Budget",
                      fillColor: Colors.white,
                      controller: projectProvider.budgetCntrl,
                    ),
                    const SizedBox(height: 8),

                    GestureDetector(
                      onTap: () {
                        context.read<ProjectProvider>().pickDueDate(context);
                      },
                      child: AbsorbPointer(
                        child: CustomTextField(
                          hintText: "Due Date",
                          fillColor: Colors.white,
                          controller: TextEditingController(
                            text: projectProvider.formattedDueDate,
                          ),
                          suffixIcon: const Icon(
                            Icons.calendar_month_outlined,
                            color: Color(0xff737373),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    CustomTextField(
                      hintText: "Description",
                      fillColor: Colors.white,
                      maxLine: 4,
                      controller: projectProvider.desCntrl,
                    ),
                  ],
                ),
              ),
            ),

            /// 🔽 Fixed Button at Bottom
            CustomButton(
              text: "Create Project",
              onPress: () async {
                await projectProvider.addProject(
                  context: context,
                  title: projectProvider.titleCntrl.text,
                  budget: projectProvider.budgetCntrl.text,
                  datee: projectProvider.formattedDueDate,
                  description: projectProvider.desCntrl.text,
                );

                // ✅ CLEAR FORM AFTER SUBMIT
                projectProvider.clearForm();
              },
            ),
          ],
        ),
      ),
    );
  }
}
