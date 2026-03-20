import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sparqly/app/services/location%20services/MapReusableCodeListing.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Scaffold.dart';
import '../../../constants/App_Colors.dart';
import '../../../models/Get_Models_All/Subscription_Plan_Activation_model.dart';
import '../../../services/api_services/apiServices.dart';
import '../../../services/location services/Location.dart';
import '../../../widgets/Custom_Widgets/AppCustomScaffold.dart';
import '../../../widgets/Custom_Widgets/App_AppResponsive.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Button.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Button_Listing.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Container.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Texts.dart';
import '../../../widgets/Custom_Widgets/Custom_Input_Decoration_Helper.dart';
import '../../../widgets/Custom_Widgets/Custom_Input_Field.dart';
import '../../../widgets/Custom_Widgets/Custom_Dropdown_Field.dart';
import '../../../widgets/Custom_Widgets/feature_Access.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/jobs_listings_controller.dart';

class JobsListingsView extends GetView<JobsListingsController> {
  JobsListingsView({super.key});

  final LocationAccesss locationController = Get.find<LocationAccesss>();


  final subscriptionController = GenericController<SubscriptionPlanActive>(
    fetchFunction: () async {
      return await ApiServices().fetchSubscriptionPlan();
    },
  );

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
    final controller = Get.put(JobsListingsController());
    subscriptionController.loadData();

    return AppCustomScaffold(
      customAppBar: AppCustomAppBar(title: "Job Listings"),
      BodyWidget: AppResponsive(
        builder: (context, constraints, mediaQuery) {
          return Card(
            color: AppColors.white,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------- Company & Logo ----------
                  AppCustomContainer(
                    borderradius: 10,
                    widthColor: AppColors.dividercolor,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle("Company Details"),
                          SizedBox(height: mediaQuery.size.height * 0.02),

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
                                      image: controller.logo.value != null
                                          ? DecorationImage(
                                        image: FileImage(
                                          controller.logo.value!,
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                          : null,
                                      color: Colors.grey.shade100,
                                    ),
                                    child: controller.logo.value == null
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
                                action: () => controller.pickCompressedImage(),
                                height: constraints.maxHeight * 0.05,
                                width: constraints.maxWidth * 0.50,
                                borderradius: 5,
                                ButtonName: "Upload Logo",
                              ),
                            ],
                          ),
                          SizedBox(height: mediaQuery.size.height * 0.02),

                          CustomInputField(
                            controller: controller.companyNameController,
                            label: "Company Name",
                            hint: "Your company name",
                            icon: Icons.business,
                            onChanged: (v) =>
                            controller.companyName.value = v,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: mediaQuery.size.height * 0.02),

                  // ---------- Job Info ----------
                  AppCustomContainer(
                    borderradius: 10,
                    widthColor: AppColors.dividercolor,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle("Job Information"),
                          SizedBox(height: mediaQuery.size.height * 0.02),

                          CustomInputField(
                            controller: controller.jobTitleController,
                            label: "Job Title",
                            hint: "e.g., Software Engineer",
                            icon: Icons.work,
                            onChanged: (v) => controller.jobTitle.value = v,
                          ),
                          SizedBox(height: 14),

                          Obx(
                                () => CustomDropdownField(

                              label: "Job Type",
                              value: controller.selectedJobType.value,
                              items: controller.jobTypes,
                              icon: Icons.category,
                              onChanged: (value) =>
                              controller.selectedJobType.value = value ?? '',
                            ),
                          ),
                          SizedBox(height: 14),

                          CustomInputField(
                            controller: controller.jobDescriptionController,
                            label: "Job Description",
                            hint: "Job responsibilities, requirements, etc.",
                            icon: Icons.description,
                            maxLines: 5,
                            onChanged: (v) => controller.description.value = v,
                          ),
                          SizedBox(height: 14),

                          CustomInputField(
                            controller: controller.salaryRangeController,
                            label: "Salary Range",
                            hint: "e.g., ₹8,00,000 - ₹12,00,000",
                            icon: Icons.attach_money,
                            onChanged: (v) => controller.salary.value = v,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: mediaQuery.size.height * 0.01),

                  // ---------- Location ----------
                 LocationPicker(controller: locationController ,  ),

                  SizedBox(height: mediaQuery.size.height * 0.01),

                  // ---------- Application ----------
                  AppCustomContainer(
                    borderradius: 10,
                    widthColor: AppColors.dividercolor,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle("Application"),
                          SizedBox(height: mediaQuery.size.height * 0.02),

                          CustomInputField(
                            controller: controller.applicationController,
                            label: "Application Link",
                            hint: "https://example.com/apply",
                            icon: Icons.link,
                            onChanged: (v) =>
                            controller.applicationLink.value = v,
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
                          SizedBox(height: mediaQuery.size.height * 0.02),

                          CustomInputField(
                            controller: controller.mobileVerificationController,
                            label: "Contact Number for Verification",
                            hint: "Recruiter's Contact Number",
                            icon: Icons.link,
                            onChanged: (v) =>
                            controller.applicationLink.value = v,
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
                    if (!sub.access.jobAdd) {
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
                        action: () => controller.submitJob(),
                        borderradius: 14,
                        width: double.infinity,
                        ButtonName: "Submit Job Posting",
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
