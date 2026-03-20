import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/App_Colors.dart';
import '../../../widgets/Custom_Widgets/App_AppResponsive.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Button.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Container.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Scaffold.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Texts.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  EditProfileView({super.key});
  final EditProfileController controller = Get.put(EditProfileController());

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

  Widget _buildTextField(
      BuildContext context,
      String label,
      TextEditingController textController, {
        TextInputType keyboardType = TextInputType.text,
        int maxLines = 1,
        IconData? icon,
      }) {
    return AppCustomContainer(
      borderradius: 12,
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.black, size: 22),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: TextField(
                controller: textController,
                keyboardType: keyboardType,
                maxLines: maxLines,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: label,
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade700,
                    fontFamily: "Times New Roman",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable input block with title + field
  Widget inputBlock(
      BuildContext context, {
        required String title,
        required String hint,
        required TextEditingController controller,
        IconData? icon,
        TextInputType keyboardType = TextInputType.text,
        int maxLines = 1,
        double spacing = 0.02,
      }) {
    final height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(title),
        SizedBox(height: height * 0.01),
        _buildTextField(
          context,
          hint,
          controller,
          icon: icon,
          keyboardType: keyboardType,
          maxLines: maxLines,
        ),
        SizedBox(height: height * spacing),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    return AppCustomScaffold(
      scaffoldbackgroundColor: AppColors.white,
      BodyWidget: AppResponsive(
        builder: (context, constraints, mediaQuery) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              color: AppColors.white,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.06,
                    vertical: height * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      AppCustomTexts(
                        TextName: "Edit Profile",
                        textStyle: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                          fontFamily: "Times New Roman",
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Update your essential information to keep your profile up to date.",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.grey.shade600,fontFamily: "Times New Roman",),
                      ),
                      SizedBox(height: height * 0.025),

                      // Progress
                      Obx(
                            () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LinearProgressIndicator(
                              value: controller.progress.value,
                              minHeight: 10,
                              borderRadius: BorderRadius.circular(10),
                              backgroundColor: Colors.grey.shade200,
                              color: AppColors.buttonColor,
                            ),
                            SizedBox(height: height * 0.01),
                            Text(
                              "${(controller.progress.value * 100).toStringAsFixed(0)} % Completed",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                color: AppColors.buttonColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Times New Roman",
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.035),

                      // Business Details Section
                      sectionTitle("Profile Details"),
                      SizedBox(height: mediaQuery.size.height * 0.02),

                      // Profile Picture Upload
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() =>
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
                                    image: controller.profilePic.value != null
                                    // show picked image
                                        ? DecorationImage(
                                      image: FileImage(controller.profilePic.value!),
                                      fit: BoxFit.cover,
                                    )
                                        : (controller.profileImageUrl.value.isNotEmpty
                                    // show uploaded server image
                                        ? DecorationImage(
                                      image: NetworkImage(controller.profileImageUrl.value),
                                      fit: BoxFit.cover,
                                    )
                                        : null),
                                  ),
                                  child: (controller.profilePic.value == null &&
                                      controller.profileImageUrl.value.isEmpty)
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
                            width: constraints.maxWidth * 0.35,
                            borderradius: 12,
                            ButtonName: "Upload Picture",
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.04),

                      // Reusable input fields
                      inputBlock(
                        context,
                        title: "Display Name",
                        hint: "Your display name",
                        controller: controller.businessNameController,
                        icon: Icons.person_outline,
                      ),
                      inputBlock(
                        context,
                        title: "Profession",
                        hint: "Content Creator",
                        controller: controller.professionController,
                        icon: Icons.work_outline,
                      ),
                      genderDropdown(context),

                      inputBlock(
                        context,
                        title: "Bio",
                        hint: "About yourself",
                        controller: controller.bioController,
                        keyboardType: TextInputType.text,
                        icon: Icons.description,
                        maxLines: 3,
                      ),

                      // State Dropdown
                      dropdownBlock(
                        context: context,
                        title: "State",
                        selectedValue: controller.selectedStateId,
                        items: controller.states,
                        labelKey: "name",
                        onChanged: (value) {
                          controller.selectedStateId.value = value;
                          if (value != null) {
                            controller.loadDistricts(value);
                          }
                        },
                      ),

// District Dropdown
                      dropdownBlock(
                        context: context,
                        title: "District",
                        selectedValue: controller.selectedDistrictId,
                        items: controller.districts,
                        labelKey: "name",
                        onChanged: (value) {
                          controller.selectedDistrictId.value = value;
                        },
                      ),

                      inputBlock(
                        context,
                        title: "Taluka",
                        hint: "Street",
                        controller: controller.talukaController,
                        icon: Icons.location_on_outlined,
                      ),


                      inputBlock(
                        context,
                        title: "Website",
                        hint: "https://example.com",
                        controller: controller.websiteController,
                        icon: Icons.link,
                      ),
                      inputBlock(
                        context,
                        title: "Mobile Number",
                        hint: "9876543210",
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        icon: Icons.phone,
                      ),
                      inputBlock(
                        context,
                        title: "Email",
                        hint: "JhonDoe@gmail.com",
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        icon: Icons.email_outlined,
                      ),


                      SizedBox(height: height * 0.05),

                      // Save button
                      Obx(
                        () => Align(
                          alignment: Alignment.centerRight,
                          child: IntrinsicWidth(
                            child: AppCustomButton(
                              height: height * 0.05,
                              borderradius: 14,
                              color: AppColors.buttonColor,
                              action: () => controller.saveProfile(),
                              CustomName: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: controller.isLoading.value ? CupertinoActivityIndicator(color: AppColors.white,) : AppCustomTexts(
                                  TextName: "Save Changes",
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Times New Roman",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget dropdownBlock({
    required String title,
    required RxnInt selectedValue,
    required List<dynamic> items,
    required String labelKey,
    required Function(int?) onChanged,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(title),
        const SizedBox(height: 8),
        AppCustomContainer(
          borderradius: 12,
          color: Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Obx(
                  () => DropdownButton<int>(

                value: selectedValue.value,
                isExpanded: true,
                underline: const SizedBox(),
                hint: Text("Select $title",style: TextStyle(fontSize: 13),),
                items: items.map((item) {
                  return DropdownMenuItem<int>(
                    value: item['id'],
                    child: Text(item[labelKey].toString(),style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade700,
                      fontFamily: "Times New Roman",
                    ),),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget genderDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle("Gender"),
        const SizedBox(height: 8),
        AppCustomContainer(
          borderradius: 12,
          color: Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Obx(
                  () => DropdownButton<String>(
                value: controller.selectedGender.value,
                isExpanded: true,
                underline: const SizedBox(),
                hint: Text(
                  "Select Gender",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade700,
                    fontFamily: "Times New Roman",
                  ),
                ),
                items: controller.genderList.map((gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(
                      gender,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade700,
                        fontFamily: "Times New Roman",
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  controller.selectedGender.value = value;
                  controller.updateProgress();
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }


}
