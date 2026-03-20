import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sparqly/app/constants/App_Colors.dart';
import 'package:sparqly/app/services/location%20services/MapReusableCodeListing.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_AppResponsive.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Button.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Container.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Scaffold.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Texts.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/Custom_Dropdown_Field.dart';
import '../../../models/Get_Models_All/Subscription_Plan_Activation_model.dart';
import '../../../services/api_services/apiServices.dart';
import '../../../services/location services/Location.dart';
import '../../../widgets/Custom_Widgets/AppCustomScaffold.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Button_Listing.dart';
import '../../../widgets/Custom_Widgets/Custom_Input_Field.dart';
import '../../../widgets/Custom_Widgets/feature_Access.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../influencers_listings/controllers/influencers_listings_controller.dart';


class InfluencersListingsView extends GetView<InfluencersListingsController> {
  InfluencersListingsView({super.key});

  final LocationAccesss locationController = Get.find<LocationAccesss>();
  final DashboardController dashboardController = Get.find<DashboardController>();

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

  final subscriptionController = GenericController<SubscriptionPlanActive>(
    fetchFunction: () async {
      return await ApiServices().fetchSubscriptionPlan();
    },
  );


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InfluencersListingsController());
    subscriptionController.loadData();

    return AppCustomScaffold(
      customAppBar: AppCustomAppBar(title: "Influencers Listings"),
      BodyWidget: AppResponsive(
        builder: (context, constraints, mediaQuery) {
          return Card(
            color: AppColors.white,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------- Profile Details ----------
                  AppCustomContainer(
                    widthColor: AppColors.dividercolor,
                    borderradius: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle("Profile Details"),
                          SizedBox(height: mediaQuery.size.height * 0.01),

                          // Profile Picture Upload
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(
                                    () =>
                                    DottedBorder(
                                      borderType: BorderType.Circle,
                                      dashPattern: const [6, 3],
                                      color: Colors.grey.shade500,
                                      strokeWidth: 1.8,
                                      child: Container(
                                        height: mediaQuery.size.height * 0.13,
                                        width: mediaQuery.size.width * 0.30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.shade100,
                                          image: controller.profilePic.value !=
                                              null
                                              ? DecorationImage(
                                            image: FileImage(
                                                controller.profilePic.value!),
                                            fit: BoxFit.cover,
                                          )
                                              : null,
                                        ),
                                        child: controller.profilePic.value ==
                                            null
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
                                action: () => controller.pickProfilePic(),
                                height: constraints.maxHeight * 0.05,
                                width: constraints.maxWidth * 0.40,
                                borderradius: 12,
                                ButtonName: "Upload Picture",
                              ),
                            ],
                          ),
                          SizedBox(height: mediaQuery.size.height * 0.01),

                          CustomInputField(
                            controller: controller.nameController,
                            label: "Name",
                            hint: "Your name or alias",
                            icon: Icons.person,
                            onChanged: (v) => controller.name.value = v,
                          ),
                          CustomInputField(
                            controller: controller.professionController,
                            label: "Profession",
                            hint: "e.g., Content Creator, Artist",
                            icon: Icons.work,
                            onChanged: (v) => controller.profession.value = v,
                          ),
                          CustomInputField(
                            controller: controller.bioController,
                            label: "Bio",
                            hint: "Tell us a little about yourself",
                            icon: Icons.info,
                            maxLines: 3,
                            onChanged: (v) => controller.bio.value = v,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: mediaQuery.size.height * 0.01),

                  // ---------- Categorization ----------
                  AppCustomContainer(
                    widthColor: AppColors.dividercolor,
                    borderradius: 10,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle("Categorization"),
                          SizedBox(height: mediaQuery.size.height * 0.02),
                          Obx(() {
                            if (controller.isLoading.value) {
                              // Show loading state
                              return CustomDropdownField(
                                label: "Category",
                                value: "Loading...",
                                items: ["Loading..."],
                                onChanged: (_) {},
                              );
                            } else if (controller.hasError.value) {
                              // Show error state
                              return CustomDropdownField(
                                label: "Category",
                                value: "Failed to load",
                                items: ["Failed to load"],
                                onChanged: (_) {},
                              );
                            } else if (controller.categories.isEmpty) {
                              // No categories (empty but no error)
                              return CustomDropdownField(
                                label: "Category",
                                value: "No categories available",
                                items: ["No categories available"],
                                onChanged: (_) {},
                              );
                            } else {
                              // Data available
                              return CustomDropdownField(
                                label: "Category",
                                value: controller.selectedCategory.value?.categoryName,
                                items: controller.categories.map((cat) => cat.categoryName).toList(),
                                onChanged: (value) {
                                  final selected = controller.categories
                                      .firstWhereOrNull((cat) => cat.categoryName == value);
                                  controller.selectedCategory.value = selected;
                                },
                              );
                            }
                          })
                        ]
                    )
                    )
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.01),
                  LocationPicker(controller: locationController),

                  SizedBox(height: mediaQuery.size.height * 0.01),

                  // ---------- Links ----------
                  AppCustomContainer(
                    widthColor: AppColors.dividercolor,
                    borderradius: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle("Links & Socials"),
                          SizedBox(height: mediaQuery.size.height * 0.02),
                          Obx(() =>
                              CustomInputField(
                                label: "Website or Social Link",
                                hint: "https://your-link.com",
                                icon: Icons.link,
                                controller: TextEditingController(
                                    text: controller.website.value)
                                  ..selection = TextSelection.collapsed(
                                      offset: controller.website.value.length),
                                onChanged: (v) => controller.website.value = v,
                              )),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: mediaQuery.size.height * 0.01),

                  // ---------- Followers ----------
                  AppCustomContainer(
                    widthColor: AppColors.dividercolor,
                    borderradius: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle("Followers"),
                          SizedBox(height: mediaQuery.size.height * 0.02),

                          CustomDropdownField(
                            label: "Instagram Followers",
                            value: controller.instagramFollowers.value,
                            items: controller.followerRanges,
                            onChanged: (v) =>
                            controller.instagramFollowers.value = v,
                          ),
                          CustomDropdownField(
                            label: "YouTube Followers",
                            value: controller.youtubeFollowers.value,
                            items: controller.followerRanges,
                            onChanged: (v) =>
                            controller.youtubeFollowers.value = v,
                          ),
                          CustomDropdownField(
                            label: "Facebook Followers",
                            value: controller.facebookFollowers.value,
                            items: controller.followerRanges,
                            onChanged: (v) =>
                            controller.facebookFollowers.value = v,
                          ),
                          CustomDropdownField(
                            label: "LinkedIn Followers",
                            value: controller.linkedinFollowers.value,
                            items: controller.followerRanges,
                            onChanged: (v) =>
                            controller.linkedinFollowers.value = v,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: mediaQuery.size.height * 0.02),
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
                            controller: controller.mobileVerificationController,
                            label: "Contact Number for Verification",
                            hint: "Recruiter's Contact Number",
                            icon: Icons.phone,
                            onChanged: (v) =>
                            controller.applicationLink.value = v,
                          ),
                          SizedBox(height: mediaQuery.size.height * 0.01),
                          AppCustomTexts(
                            TextName:
                            "This number is required for verification. If our moderators cannot reach you, your listing may be disapproved. Please provide a working contact number.",
                            textStyle: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.grey.shade900,
                              fontFamily: "Times New Roman",),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: mediaQuery.size.height * 0.025),
                  // ---------- Submit ----------

                  Obx(() {
                    final sub = subscriptionController.data.value;

                    // ⏳ Subscription loading
                    if (subscriptionController.isLoading.value) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    // ⛔ No subscription
                    if (sub == null) {
                      return const SizedBox.shrink();
                    }

                    // ⛔ Feature not allowed
                    if (!sub.access.influencerAdd) {
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

                    // ✅ Allowed
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: AppCustomButton(
                        height: 45,
                        action: () => controller.submitProfile(),
                        borderradius: 14,
                        width: double.infinity,
                        ButtonName: "Submit for Review",
                      ),
                    );
                  })

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
