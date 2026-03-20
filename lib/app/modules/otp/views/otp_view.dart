import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sparqly/app/constants/App_Colors.dart';
import 'package:sparqly/app/routes/app_pages.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_AppResponsive.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Button.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Container.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Scaffold.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Texts.dart';
import '../../../constants/App_Assets.dart';
import '../controllers/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

    return AppCustomScaffold(
      resize: false,
      BodyWidget: AppResponsive(
        builder: (context, constraints, mediaQuery) {
          return Obx(
                () => Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.size.width * 0.05,
                vertical: mediaQuery.size.height * 0.02,
              ),
              child: controller.isOtpSent.value
                  ? _otpView(
                context,
                mediaQuery,
                constraints,
                controller,
                focusNodes,
              )
                  : _phoneView(context, controller),
            ),
          );
        },
      ),
    );
  }
}

Widget _otpView(
    BuildContext context,
    MediaQueryData mediaQuery,
    BoxConstraints constraints,
    OtpController controller,
    List<FocusNode> focusNodes,
    ) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: mediaQuery.size.width * 0.06,
      vertical: mediaQuery.size.height * 0.03,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: mediaQuery.size.height * 0.05),
        Image.asset(
          AppAssets.otpLogo,
          width: mediaQuery.size.width * 0.45,
          height: mediaQuery.size.height * 0.10,
          fit: BoxFit.contain,
        ),
        SizedBox(height: mediaQuery.size.height * 0.005),

        AppCustomTexts(
          TextName: 'Enter the 4-digit code sent to your mobile number',
          textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
          Textalign: TextAlign.center,
        ),

        SizedBox(height: mediaQuery.size.height * 0.02),

        /// OTP Fields
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) {
            return SizedBox(
              width: mediaQuery.size.width * 0.12,
              child: TextFormField(
                controller: controller.otpControllers[index],
                focusNode: focusNodes[index],
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.black),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && index < 3) {
                    focusNodes[index + 1].requestFocus();
                  } else if (value.isEmpty && index > 0) {
                    focusNodes[index - 1].requestFocus();
                  }
                },
              ),
            );
          }),
        ),

        SizedBox(height: mediaQuery.size.height * 0.01),

        /// Resend OTP or Timer
        Obx(
              () => controller.secondsRemaining.value > 0
              ? Text(
            'Resend code in 00:${controller.secondsRemaining.value.toString().padLeft(2, '0')}',
            style: Theme.of(context).textTheme.bodyMedium,
          )
              : TextButton(
            onPressed: () => controller.resendOtp(context),
            child: Text(
              'Resend OTP',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        SizedBox(height: mediaQuery.size.height * 0.01),

        /// Verify Button
        AppCustomButton(
          borderradius: 12,
          height: mediaQuery.size.height * 0.055,
          width: mediaQuery.size.width * 0.8,
          action: () => controller.verify4DigitOtp(context),
          CustomName: controller.isLoading.value
              ? const CupertinoActivityIndicator()
              : AppCustomTexts(
            TextName: 'Verify',
            textStyle: Theme.of(
              context,
            ).textTheme.headlineSmall!.copyWith(color: AppColors.white),
          ),
        ),

        SizedBox(height: mediaQuery.size.height * 0.01),

        /// Back to phone input
        AppCustomTexts(
          action: () {
            controller.isOtpSent.value = false;
          },
          TextName: "Edit phone number?",
          textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
          ),
          Textalign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget _phoneView(BuildContext context, OtpController controller) {
  final mediaQuery = MediaQuery.of(context);

  return SizedBox(
    height: mediaQuery.size.height,
    child: Column(
      children: [
        /// Skip button
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(
              top: mediaQuery.size.height * 0.02,
              left: mediaQuery.size.width * 0.07,
            ),
            child: InkWell(
              onTap: (){
                final storage = GetStorage();
                storage.write('is_guest', true);  //  mark as guest
                storage.remove('auth_token');     // no token for guest
                Get.offAllNamed(Routes.DASHBOARD);
              },
              child: AppCustomContainer(
                width: mediaQuery.size.width * 0.20,
                height: mediaQuery.size.height * 0.035,
                borderradius: 10,
                widthColor: Colors.red,
                widthsize: 0.7,
                child: Center(
                  child: AppCustomTexts(
                    TextName: "Skip",
                    textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.red.shade300,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: mediaQuery.size.height * 0.06),

        /// Logo + texts
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                AppAssets.otpLogo,
                width: mediaQuery.size.width * 0.45,
                height: mediaQuery.size.height * 0.08,
                fit: BoxFit.contain,
              ),
              SizedBox(height: mediaQuery.size.height * 0.015),

              AppCustomTexts(
                TextName: "Easy | Local | Instant",
                textStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
                Textalign: TextAlign.center,
              ),

              SizedBox(height: mediaQuery.size.height * 0.01),
              Divider(
                color: AppColors.dividercolor,
                thickness: 1,
                indent: mediaQuery.size.width * 0.1,
                endIndent: mediaQuery.size.width * 0.1,
              ),
              SizedBox(height: mediaQuery.size.height * 0.01),

              AppCustomTexts(
                TextName:
                "Business | Jobs | Influencer | Offers | Courses\nAll in one app for you",
                textStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
                Textalign: TextAlign.center,
              ),

              SizedBox(height: mediaQuery.size.height * 0.03),

              /// Phone field
              TextFormField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Enter phone number",
                  prefixIcon: const Icon(Icons.phone),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.dividercolor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.dividercolor,
                      width: 2,
                    ),
                  ),
                ),
              ),

              SizedBox(height: mediaQuery.size.height * 0.025),

              /// Send OTP button
              AppCustomButton(
                borderradius: 12,
                height: mediaQuery.size.height * 0.05,
                width: mediaQuery.size.width * 0.85,
                action: () => controller.sendOtp(context),
                CustomName: controller.isLoading.value
                    ? const CupertinoActivityIndicator()
                    : AppCustomTexts(
                  TextName: 'Send OTP',
                  textStyle: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: AppColors.white),
                ),
              ),

              SizedBox(height: mediaQuery.size.height * 0.015),
              AppCustomTexts(
                TextName: "One step away from your opportunity",
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
                Textalign: TextAlign.center,
              ),
            ],
          ),
        ),

        /// Terms & Conditions
        Padding(
          padding: EdgeInsets.only(
            bottom: mediaQuery.size.height * 0.02,
            left: mediaQuery.size.width * 0.08,
            right: mediaQuery.size.width * 0.08,
          ),
          child: AppCustomTexts(
            TextName:
            "By continuing, you agree to our Terms of Use and Privacy Policy",
            textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
            Textalign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
