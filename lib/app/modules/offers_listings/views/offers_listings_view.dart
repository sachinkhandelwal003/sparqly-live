import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sparqly/app/services/location%20services/MapReusableCodeListing.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Texts.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/Custom_Dropdown_Field.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/Custom_Input_Decoration_Helper.dart';
import '../../../constants/App_Colors.dart';
import '../../../services/location services/Location.dart';
import '../../../widgets/Custom_Widgets/AppCustomScaffold.dart';
import '../../../widgets/Custom_Widgets/App_AppResponsive.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Button.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Button_Listing.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Container.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Scaffold.dart';
import '../../../widgets/Custom_Widgets/Custom_Input_Field.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/offers_listings_controller.dart';

class OffersListingsView extends GetView<OffersListingsController> {
  OffersListingsView({super.key});

  final LocationAccesss locationController = Get.put(LocationAccesss());
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  // ---------- Section Title ----------
  Widget sectionTitle(String title) {
    return AppCustomTexts(
      TextName: title,
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        fontFamily: "Times New Roman",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OffersListingsController());

    return AppCustomScaffold(
      customAppBar: AppCustomAppBar(title: "Offer Listings"),
      BodyWidget: AppResponsive(
        builder: (context, constraints, mediaQuery) {
          return Card(
            color: Colors.white,
            shadowColor: Colors.black12,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------- Offer Image ----------
                  AppCustomContainer(
                    widthColor: AppColors.dividercolor,
                    borderradius: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle("Offer Image"),
                          SizedBox(height: mediaQuery.size.height * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(
                                () => DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(16),
                                  dashPattern: const [6, 3],
                                  color: Colors.grey.shade500,
                                  strokeWidth: 1.8,
                                  child: Container(
                                    height: 90,
                                    width: 130,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      image: controller.offerImage.value != null
                                          ? DecorationImage(
                                              image: FileImage(
                                                controller.offerImage.value!,
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                      color: Colors.grey.shade100,
                                    ),
                                    child: controller.offerImage.value == null
                                        ? const Center(
                                            child: Icon(
                                              Icons.cloud_upload_outlined,
                                              size: 32,
                                              color: Colors.black54,
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                              AppCustomButton(
                                action: () => controller.pickOfferImage(),
                                height: constraints.maxHeight * 0.05,
                                width: constraints.maxWidth * 0.40,
                                borderradius: 12,
                                ButtonName: "Upload Image",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: mediaQuery.size.height * 0.01),

                  // ---------- Offer Details ----------
                  AppCustomContainer(
                    widthColor: AppColors.dividercolor,
                    borderradius: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle("Offer Details"),
                          SizedBox(height: mediaQuery.size.height * 0.01),

                          CustomInputField(
                            controller: controller.titleController,
                            label: "Offer Title",
                            hint: "e.g., Summer Sale",
                            icon: Icons.local_offer,
                          ),
                          CustomInputField(
                            controller: controller.descriptionController,
                            label: "Short Description",
                            hint: "Briefly describe the offer",
                            icon: Icons.description,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: mediaQuery.size.height * 0.01),
                  AppCustomContainer(
                    widthColor: AppColors.dividercolor,
                    borderradius: 10,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle("Redemption Details"),
                          SizedBox(height: mediaQuery.size.height * 0.01),

                          /// Radio Buttons (normal, no Expanded)
                          Obx(
                            () => Row(
                              children: [
                                Radio<String>(
                                  value: "all",
                                  groupValue: controller.locationType.value,
                                  activeColor: AppColors.buttonColor,
                                  onChanged: (val) =>
                                      controller.locationType.value = val!,
                                ),
                                const Icon(
                                  Icons.public,
                                  size: 18,
                                  color: Colors.black87,
                                ),
                                const SizedBox(width: 4),
                                AppCustomTexts(
                                  TextName: "Online",
                                  textStyle: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Times New Roman",
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Radio<String>(
                                  value: "specific",
                                  groupValue: controller.locationType.value,
                                  activeColor: AppColors.buttonColor,
                                  onChanged: (val) =>
                                      controller.locationType.value = val!,
                                ),
                                const Icon(
                                  Icons.store,
                                  size: 18,
                                  color: Colors.black87,
                                ),
                                const SizedBox(width: 4),
                                AppCustomTexts(
                                  TextName: "In-Store",
                                  textStyle: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Times New Roman",
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// Show Map + Address only if "In-Store" is selected
                          Obx(() {
                            if (controller.locationType.value == "specific") {
                              return Column(
                                children: [
                                  /// Map
                                  LocationPicker(
                                    locationTitle: "",
                                    widthColor: Colors.transparent,
                                    horizontalPadding: 0,
                                    verticalPadding: 0,
                                    controller: locationController,
                                  ),
                                  SizedBox(
                                    height: mediaQuery.size.height * 0.01,
                                  ),
                                  CustomInputField(
                                    controller: controller.onlineRedemptionInstructionController,
                                    maxLines: 4,
                                    label: "Redemption Instructions",
                                    hint:
                                        "e.g.,  'Show this screen at checkout ' or 'Enter code at online checkout'.",
                                    icon: Icons.description,
                                  ),
                                ],
                              );
                            }
                            return Column(
                              children: [
                                SizedBox(height: mediaQuery.size.height * 0.01),
                                CustomInputField(
                                  label: "Coupon Code",
                                  hint: "e.g, SUMMER50,",
                                  icon: Icons.description,
                                ),
                                SizedBox(height: mediaQuery.size.height * 0.01),
                                CustomInputField(
                                  controller: controller.redemptionInstructionsController,
                                  maxLines: 4,
                                  label: "Redemption Instructions",
                                  hint:
                                      "e.g.,  'Show this screen at checkout ' or 'Enter code at online checkout'.",
                                  icon: Icons.description,
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: mediaQuery.size.height * 0.01),
                  // ---------- Discount ----------
                  AppCustomContainer(
                    widthColor: AppColors.dividercolor,
                    borderradius: 10,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle("Discount"),
                          SizedBox(height: mediaQuery.size.height * 0.01),

                          CustomDropdownField(
                            label: "Discount Type",
                            value: controller.discountType.value,
                            items: controller.discountTypes,
                            onChanged: (v) =>
                                controller.discountType.value = v ?? "",
                          ),
                          CustomInputField(
                            controller: controller.originalPriceController,
                            label: "Original Price (₹)",
                            hint: "e.g., 1999",
                            icon: Icons.currency_rupee,
                            keyboard: TextInputType.number,
                          ),
                          CustomInputField(
                            controller: controller.discountValueController,
                            label: "Discount Value",
                            hint: "e.g., 50 or 500",
                            icon: Icons.percent,
                            keyboard: TextInputType.number,
                          ),

                          CustomDropdownField(
                            label: "Target Audience",
                            value: controller.targetAudience.value,
                            items: controller.targetCategories,
                            onChanged: (value) {
                              controller.targetAudience.value = value ?? "";
                            },
                          ),

                          CustomDropdownField(
                            label: "Usage Limit",
                            value: controller.usageLimitt.value,
                            items: controller.usageLimit,
                            onChanged: (value) {
                              controller.usageLimitt.value = value ?? "";
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: mediaQuery.size.height * 0.01),

                  // ---------- Validity ----------
                  AppCustomContainer(
                    widthColor: AppColors.dividercolor,
                    borderradius: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle("Validity"),
                          SizedBox(height: mediaQuery.size.height * 0.01),
                          Obx(
                            () => TextField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: controller.validityDate.value,
                              ),
                              decoration: appInputDecoration(
                                context,
                                "Offer Validity",
                                prefixIcon: Icons.calendar_today,
                              )..copyWith(hintText: "Pick an expiry date"),
                              onTap: () => controller.pickDate(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: mediaQuery.size.height * 0.01),

                  // ---------- Terms ----------
                  AppCustomContainer(
                    widthColor: AppColors.dividercolor,
                    borderradius: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle("Terms & Conditions"),
                          SizedBox(height: mediaQuery.size.height * 0.01),
                          CustomInputField(
                            controller: controller.termsConditionsController,
                            label: "Terms & Conditions",
                            hint: "e.g., Offer valid on select items only.",
                            icon: Icons.rule,
                            maxLines: 3,
                            onChanged: (v) => controller.terms.value = v,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: mediaQuery.size.height * 0.01),

                  AppCustomContainer(
                    borderradius: 10,
                    widthColor: AppColors.dividercolor,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle("Verification"),
                          SizedBox(height: mediaQuery.size.height * 0.01),

                          CustomInputField(
                            controller: controller.mobileController,
                            label: "Contact Number for Verification",
                            hint: "Business Contact Number",
                            icon: Icons.phone,
                            onChanged: (v) =>
                                controller.applicationLink.value = v,
                          ),
                          SizedBox(height: mediaQuery.size.height * 0.01),
                          AppCustomTexts(
                            TextName:
                                "This number is required for verification. If our moderators cannot reach you, your listing may be disapproved. Please provide a working contact number.",
                            textStyle: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: Colors.grey.shade900,
                                  fontFamily: "Times New Roman",
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: mediaQuery.size.height * 0.025),
                  // ---------- Submit ----------

                  Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: AppLoadingButton(
                      isLoading: controller.isLoading.value,
                      onPressed: () =>controller.submitOffer(),
                      buttonText: "Submit for Review",
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
