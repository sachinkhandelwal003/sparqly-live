import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sparqly/app/constants/App_Colors.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/AppCustomScaffold.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_AppResponsive.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Button.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Container.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Scaffold.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Texts.dart';
import '../../../models/Get_Models_All/Subscription_Plan_Activation_model.dart';
import '../../../services/api_services/apiServices.dart';
import '../../../services/location services/Location.dart';
import '../../../services/location services/MapReusableCodeListing.dart';
import '../../../widgets/Custom_Widgets/feature_Access.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/business_listings_controller.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/Custom_Input_Field.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/Custom_Dropdown_Field.dart';

class BusinessListingsView extends GetView<BusinessListingsController> {
  BusinessListingsView({super.key});

  final LocationAccesss locationController = Get.put(LocationAccesss());

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

  final subscriptionController = GenericController<SubscriptionPlanActive>(
    fetchFunction: () async {
      return await ApiServices().fetchSubscriptionPlan();
    },
  );


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BusinessListingsController());
    final DashboardController dashboardController = Get.find<DashboardController>();
    subscriptionController.loadData();

    return AppCustomScaffold(
      customAppBar: AppCustomAppBar(title: "Business Listings"),
      BodyWidget: AppResponsive(
        builder: (context, constraints, mediaQuery) {
          return Card(
            color: AppColors.white,
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.fetchCategories();
                await Future.delayed(const Duration(seconds: 1));
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    AppCustomContainer(
                      widthColor: AppColors.dividercolor,
                      borderradius: 10,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            sectionTitle("Business Details"),
                            SizedBox(height: mediaQuery.size.height * 0.01),

                            Obx(() => DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(16),
                              dashPattern: const [6, 3],
                              color: Colors.grey.shade500,
                              strokeWidth: 1.8,
                              child: Container(
                                height: mediaQuery.size.height * 0.14,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: controller.logo.value != null
                                      ? DecorationImage(
                                    image: FileImage(controller.logo.value!),
                                    fit: BoxFit.cover,
                                  )
                                      : null,
                                  color: Colors.grey.shade100,
                                ),
                                child: controller.logo.value == null
                                    ? const Center(
                                  child: Icon(Icons.cloud_upload_outlined,
                                      size: 32, color: Colors.black54),
                                )
                                    : null,
                              ),
                            )),
                            SizedBox(height: mediaQuery.size.height * 0.02),
                            AppCustomButton(
                              action: () => controller.pickCompressedImage(),
                              height: constraints.maxHeight * 0.06,
                              borderradius: 12,
                              ButtonName: "Upload Image",
                            ),
                            SizedBox(height: mediaQuery.size.height * 0.02),
                            CustomInputField(
                              controller: controller.businessController,
                              label: "Business Name",
                              hint: "Your business name",
                              icon: Icons.business,
                              onChanged: (v) => controller.businessName.value = v,
                            ),
                            CustomInputField(
                              controller: controller.shortDescriptionController,
                              label: "Short Description",
                              hint: "Briefly describe your business (shows on listing cards)",
                              icon: Icons.description,
                              maxLines: 3,
                              onChanged: (v) => controller.shortDescription.value = v,
                            ),
                            CustomInputField(
                              controller: controller.fullDescriptionController,
                              label: "Full Description",
                              hint: "Provide a detailed description of your business (shows on detail page)",
                              icon: Icons.description,
                              maxLines: 4,
                              onChanged: (v) => controller.fullDescription.value = v,
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
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            sectionTitle("Categorization"),
                            SizedBox(height: mediaQuery.size.height * 0.01),
                            Obx(() {
                              if (controller.isLoading.value) {
                                return CustomDropdownField(
                                  label: "Category",
                                  value: "Loading...",
                                  items: ["Loading..."],
                                  onChanged: (_) {},
                                );
                              } else if (controller.hasError.value) {
                                return CustomDropdownField(
                                  label: "Category",
                                  value: "Failed to load",
                                  items: ["Failed to load"],
                                  onChanged: (_) {},
                                );
                              } else if (controller.categories.isEmpty) {
                                return CustomDropdownField(
                                  label: "Category",
                                  value: "No categories available",
                                  items: ["No categories available"],
                                  onChanged: (_) {},
                                );
                              } else {
                                return CustomDropdownField(
                                  label: "Category",
                                  value: controller.selectedCategory.value?.name,
                                  items: controller.categories.map((cat) => cat.name).toList(),
                                  onChanged: (value) {
                                    final selected = controller.categories
                                        .firstWhereOrNull((cat) => cat.name == value);
                                    controller.selectedCategory.value = selected;
                                  },
                                );
                              }
                            })

                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: mediaQuery.size.height * 0.02),

                            LocationPicker(controller: locationController),

                    SizedBox(height: mediaQuery.size.height * 0.02),

                    AppCustomContainer(
                      widthColor: AppColors.dividercolor,
                      borderradius: 10,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            sectionTitle("Contact & Links"),
                            SizedBox(height: mediaQuery.size.height * 0.02),
                            CustomInputField(
                              label: "Website or Social Link",
                              icon: Icons.link,
                              controller: controller.websiteController,
                              onChanged: (v) => controller.website.value = v,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: mediaQuery.size.height * 0.02),

                    CustomInputField(
                      controller: controller.startingPriceController,
                      label: "Minimum / Starting Price",
                      hint: "e.g. Cheapest item price in your business",
                      icon: Icons.currency_rupee,
                      onChanged: (v) => controller.startingPrice.value = v,
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
                            SizedBox(height: mediaQuery.size.height * 0.02),
                            CustomInputField(
                              controller: controller.mobileVerificationController,
                              label: "Contact Number for Verification",
                              hint: "Recruiter's Contact Number",
                              icon: Icons.link,
                              onChanged: (v) =>
                              controller.mobileVerification.value = v,
                            ),
                            SizedBox(height: mediaQuery.size.height * 0.01),
                            AppCustomTexts(
                              TextName:
                              "This number is required for verification. If our moderators cannot reach you, your listing may be disapproved. Please provide a working contact number.",
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                color: Colors.grey.shade900,
                                fontFamily: "Times New Roman",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: mediaQuery.size.height * 0.02),

                Obx(() {
                  final sub = subscriptionController.data.value;
                  if (subscriptionController.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (sub == null) {
                    return const SizedBox.shrink();
                  }
                  if (!sub.access.businessAdd) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: AppCustomTexts(
                        TextName:
                        "Your current plan does not allow adding business listings.",
                        textStyle: TextStyle(
                          color: Colors.red.shade600,
                          fontFamily: "Times New Roman",
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: AppCustomButton(
                      height: 45,
                      action: () => controller.submitBusiness(),
                      borderradius: 14,
                      width: double.infinity,
                      ButtonName: "Submit for Review",
                    ),
                  );
                })
                ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
