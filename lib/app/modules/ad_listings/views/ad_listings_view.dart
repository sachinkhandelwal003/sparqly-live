import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Button_Listing.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Texts.dart';
import '../../../constants/App_Colors.dart';
import '../../../services/location services/Location.dart';
import '../../../services/location services/MapReusableCodeListing.dart';
import '../../../widgets/Custom_Widgets/AppCustomScaffold.dart';
import '../../../widgets/Custom_Widgets/App_AppResponsive.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Button.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Scaffold.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Container.dart';
import '../../../widgets/Custom_Widgets/Custom_Input_Decoration_Helper.dart';
import '../../../widgets/Custom_Widgets/Custom_Input_Field.dart';
import '../../../widgets/Custom_Widgets/Custom_Dropdown_Field.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/ad_listings_controller.dart';

class AdListingsView extends GetView<AdListingsController> {
  AdListingsView({super.key});

  final AdListingsController controller = Get.put(AdListingsController());
  final LocationAccesss locationController = Get.put(LocationAccesss());
  final DashboardController dashboardController = Get.find<DashboardController>();

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

  Widget sectionSubTitle(String title) {
    return AppCustomTexts(
      TextName: title,
      textStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        fontFamily: "Times New Roman",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCustomScaffold(
      customAppBar: AppCustomAppBar(title: "Ads Listings"),
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
                  SizedBox(height: mediaQuery.size.height * 0.01),

                  AppCustomContainer(
                    widthColor: AppColors.dividercolor,
                    borderradius: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle("Campaign Type"),
                          SizedBox(height: mediaQuery.size.height * 0.015),
                      Obx(() => CustomDropdownField(
                        label: "Ad Type",
                        value: controller.campaignType.value,
                        items: controller.campaignTypes,
                        onChanged: (v) => controller.campaignType.value = v ?? "",
                        icon: Icons.campaign,
                      ))

                      ],
                      ),
                    ),
                  ),

                  SizedBox(height:mediaQuery.size.height * 0.02),

                  Obx(() {
                    if (controller.campaignType.value == "Boosted Ad") {
                      return AppCustomContainer(
                        widthColor: AppColors.dividercolor,
                        borderradius: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              sectionTitle("Select Listing to Boost"),
                              SizedBox(height: mediaQuery.size.height * 0.015),
                              Obx(() {
                                if (controller.isLoadingUserListing.value) {
                                  return const Center(child: CupertinoActivityIndicator());
                                }
                                if (controller.errorMessage.isNotEmpty) {
                                  return Text(controller.errorMessage.value, style: const TextStyle(color: Colors.red));
                                }
                                if (controller.userListingsUserListing.isEmpty) {
                                  return Text("No listings available.", style: TextStyle(color: Colors.grey));
                                }
                                return CustomDropdownField(
                                  label: "Select Listing to Boost",
                                  value: controller.selectedListing.value,
                                  items: controller.userListingsUserListing.map((e) => e.name).toList(),
                                  onChanged: (v) {
                                    final selected = controller.userListingsUserListing.firstWhere((e) => e.name == v);
                                    controller.selectedListingId.value = selected.id;      // Send this to API
                                    controller.selectedListing.value = selected.name;  // Display in dropdown
                                  },
                                  icon: Icons.list,
                                  isExpanded: true,
                                );
                              }),

                              SizedBox(height: 6),
                              Align(
                                alignment: Alignment.center,
                                child: AppCustomTexts(
                                  TextName: "Only your own approved listings can be boosted.",
                                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.grey.shade900,
                                    fontFamily: "Times New Roman",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (controller.campaignType.value == "Sponsored Ad") {

                      return AppCustomContainer(
                        widthColor: AppColors.dividercolor,
                        borderradius: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              sectionTitle("Upload Image / Logo"),
                              SizedBox(height: mediaQuery.size.height * 0.02),

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
                              sectionSubTitle("Ad Title"),
                              SizedBox(height: mediaQuery.size.height * 0.01),
                              CustomInputField(
                                label: "e.g Summer Festival Campaign",
                                controller: controller.adTitleNameController,
                                hint: "",
                                icon: Icons.title,
                              ),

                              sectionSubTitle("Sponsor Name"),
                              SizedBox(height: mediaQuery.size.height * 0.01),
                              CustomInputField(
                                label: "e.g. Awesome Brand Inc.",
                                controller: controller.sponsorNameController,
                                hint: "",
                                icon: Icons.person,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  }),

                  SizedBox(height: mediaQuery.size.height * 0.01),
                  AppCustomContainer(
                    widthColor: AppColors.dividercolor,
                    borderradius: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              sectionTitle("Targeting Type"),
                              IconButton(
                                icon: Icon(Icons.info_outline, color: AppColors.dividercolor,size: 20,),
                                tooltip: "What is Targeting Type?",
                                onPressed: () {
                                  Get.dialog(
                                    AlertDialog(
                                      backgroundColor: AppColors.white,
                                      title: const AppCustomTexts(TextName: "Targeting Type",textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Times New Roman",
                                      ),),
                                      content: const AppCustomTexts(
                                        TextName: "Choose whether you want to target all users or only users in a specific location.\n\n"
                                            "- All Users: Your campaign will reach everyone.\n"
                                            "- Specific Location: Your campaign will only reach users in the chosen location(s).",
                                        textStyle: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Times New Roman",
                                        ),),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Get.back(),
                                          child: const Text("Got it"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          Obx(
                                () => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RadioListTile<String>(
                                  value: "all",
                                  groupValue: controller.targetingTypeLocation.value,
                                  activeColor: AppColors.buttonColor,
                                  title: AppCustomTexts(
                                    TextName: "All Users",
                                    textStyle: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Times New Roman",
                                    ),
                                  ),
                                  dense: true,
                                  onChanged: (val) =>
                                  controller.targetingTypeLocation.value = val!,
                                ),
                                RadioListTile<String>(
                                  value: "specific",
                                  groupValue: controller.targetingTypeLocation.value,
                                  title: AppCustomTexts(
                                    TextName: "Specific Location",
                                    textStyle: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Times New Roman",
                                    ),
                                  ),
                                  dense: true,
                                  onChanged: (val) =>
                                  controller.targetingTypeLocation.value = val!,
                                ),
                              ],
                            ),
                          ),

                          Obx(() {
                            if (controller.targetingTypeLocation.value == "specific") {
                              return LocationPicker(
                                locationTitle: "",
                                widthColor: Colors.transparent,
                                horizontalPadding: 0,
                                verticalPadding: 0,
                                controller: locationController,
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: mediaQuery.size.height * 0.02),

                  AppCustomContainer(
                    widthColor: AppColors.dividercolor,
                    borderradius: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle("Campaign Settings"),
                          SizedBox(height: mediaQuery.size.height * 0.02),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    sectionSubTitle("CTA Link"),
                                    SizedBox( height: mediaQuery.size.height * 0.01),
                                    CustomInputField(
                                      label: "Link", // remove label text
                                      controller: controller.ctaLinkController,
                                      hint: "https://example.com/offer",
                                      icon: Icons.link,
                                    ),

                                  ],
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    sectionSubTitle("CTA Button Text"),
                                    SizedBox( height: mediaQuery.size.height * 0.01),
                                    CustomInputField(
                                      label: "Learn More", // remove label text
                                      controller: controller.ctaButtonController,
                                      hint: "Learn More",
                                      icon: Icons.touch_app,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: mediaQuery.size.height * 0.02),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    sectionSubTitle("Start Date"),
                                    SizedBox(height: mediaQuery.size.height * 0.01),
                                    Obx(
                                          () => TextField(
                                        readOnly: true,
                                        controller: TextEditingController(
                                          text: controller.startDate.value,
                                        ),
                                        decoration: appInputDecoration(
                                          context,
                                          "Pick Date", // no label
                                          prefixIcon: Icons.calendar_today,
                                        ),
                                        onTap: () => controller.pickStartDate(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    sectionSubTitle("End Date"),
                                    SizedBox(height: mediaQuery.size.height * 0.01),
                                    Obx(
                                          () => TextField(
                                        readOnly: true,
                                        controller: TextEditingController(
                                          text: controller.endDate.value,
                                        ),
                                        decoration: appInputDecoration(
                                          context,
                                          "End Date", // no label
                                          prefixIcon: Icons.calendar_today,
                                        ),
                                        onTap: () => controller.pickEndDate(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: mediaQuery.size.height * 0.02),

                          sectionSubTitle("Status"),
                          CustomDropdownField(
                            label: "",
                            value: controller.status.value,
                            items: controller.statuses,
                            onChanged: (v) =>
                            controller.status.value = v ?? "",
                            icon: Icons.toggle_on,
                          ),

                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: mediaQuery.size.height * 0.01),

                  buildPlanCard(context, mediaQuery),

                  SizedBox(height: mediaQuery.size.height * 0.025),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: AppLoadingButton(
                      isLoading: controller.isLoading.value,
                      onPressed: () => controller.submitAd(),
                      buttonText: "Create Ad Campaign",
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

Widget buildPlanCard(context, mediaQuery) {
    return AppCustomContainer(
      widthColor: AppColors.dividercolor,
      borderradius: 10,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(

          children: [
            Align(
              alignment: Alignment.centerLeft,
                child: sectionTitle("Campaign Settings")),
            SizedBox(height: mediaQuery.size.height * 0.02),
            AppCustomTexts(
              TextName: "Select how many days you want to run this ad.",
              textStyle: const TextStyle(
                fontSize: 12.5,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontFamily: "Times New Roman",
              ),
            ),
            SizedBox(height: mediaQuery.size.height * 0.01),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: Slider(
                      activeColor: AppColors.buttonColor,
                      value: controller.selectedDays.value.toDouble(),
                      min: 1,
                      max: 30,
                      divisions: 29,
                      label: "${controller.selectedDays.value} Days",
                      onChanged: (val) {
                        controller.setDays(val.toInt());
                      },
                    ),
                  ),
                  Text(
                    "${controller.selectedDays.value} Days",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Obx(
                  () => AppCustomTexts(
                TextName: "Total Price : ₹${controller.totalPrice.value}",
                textStyle: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontFamily: "Times New Roman"),
              ),
            ),

          ],
        ),
      ),
    );
  }
}


