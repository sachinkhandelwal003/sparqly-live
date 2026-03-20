import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparqly/app/constants/App_Assets.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Button.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Container.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Scaffold.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Texts.dart';
import '../controllers/referal_controller.dart';


class ReferalView extends GetView<ReferalController> {
  ReferalView({super.key});

  final ReferalController controller = Get.put(ReferalController());

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return AppCustomScaffold(
      scaffoldbackgroundColor: Colors.white,
      BodyWidget: AppCustomContainer(
        height: mediaQuery.size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top white section with image
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  children: [
                    Image.asset(
                      AppAssets.referal,
                      height: mediaQuery.size.height * 0.18,
                    ),
                    const SizedBox(height: 20),
                    AppCustomTexts(
                      TextName: '🎉 Claim Your Rewards!',
                      textStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      Textalign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    AppCustomTexts(
                      TextName: 'Invite friends and earn points instantly.',
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                      Textalign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    // Referral code box
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.referralCodeController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: controller.copyReferralCode,
                            icon: const Icon(Icons.copy, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Claim button
                    AppCustomButton(
                      height: 45,
                      width: double.infinity,
                      action: () {
                        if(controller.referralCodeController.text.isNotEmpty)
                          {
                            const String green = '\x1B[32m';

                            controller.applyReferral(controller.referralCodeController.text);
                            print("${green}✅ Success: Referral applied successfully${controller
                                .referralCodeController.text}");
                          }
                        else
                          {
                            Get.snackbar(
                              'Error',
                              'Please enter a referral code',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                      },
                      borderradius: 15,
                      CustomName: AppCustomTexts(
                        TextName: "Claim Now",
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // How it works section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppCustomTexts(
                      TextName: '💡 How it works',
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      Textalign: TextAlign.start,
                    ),
                    const SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "1. Share your referral code with friends.",
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "2. Friends register using your code.",
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "3. You both earn points!",
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
