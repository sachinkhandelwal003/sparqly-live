import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Container.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Texts.dart';
import '../../../constants/App_Colors.dart';
import '../../../widgets/Custom_Widgets/AppCustomScaffold.dart';
import '../../../widgets/Custom_Widgets/App_AppResponsive.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Button.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Button_Listing.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Scaffold.dart';
import '../../../widgets/Custom_Widgets/Custom_Input_Field.dart';
import '../../../widgets/Custom_Widgets/Custom_Dropdown_Field.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/course_listings_controller.dart';

class CourseListingsView extends GetView<CourseListingsController> {
  CourseListingsView({super.key});
  final DashboardController dashboardController = Get.find<DashboardController>();
  final CourseListingsController controller = Get.put(CourseListingsController());

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
    return AppCustomScaffold(
      customAppBar: AppCustomAppBar(title: "Course Listings"),
      BodyWidget: AppResponsive(builder: (context, constraints, mediaQuery) {
        return Card(
          color: AppColors.white,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCustomContainer(
                  widthColor: AppColors.dividercolor,
                  borderradius: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionTitle("Course Details"),
                        SizedBox(height: mediaQuery.size.height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() => DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(16),
                              dashPattern: const [6, 3],
                              color: Colors.grey.shade500,
                              strokeWidth: 1.8,
                              child: Container(
                                height: 90,
                                width: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.grey.shade100,
                                  image: controller.courseImage.value != null
                                      ? DecorationImage(
                                    image: FileImage(controller.courseImage.value!),
                                    fit: BoxFit.cover,
                                  )
                                      : null,
                                ),
                                child: controller.courseImage.value == null
                                    ? const Center(
                                  child: Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 32,
                                    color: Colors.black54,
                                  ),
                                )
                                    : null,
                              ),
                            )),
                            AppCustomButton(
                              action: () => controller.pickCourseImage(),
                              height: constraints.maxHeight * 0.05,
                              width: constraints.maxWidth * 0.40,
                              borderradius: 12,
                              ButtonName: "Upload Image",
                            ),
                          ],
                        ),
                        SizedBox(height: mediaQuery.size.height * 0.02),
                        CustomInputField(
                          label: "Course Title",
                          hint: "e.g., The Complete Web Development Bootcamp",
                          icon: Icons.book,
                          onChanged: (v) => controller.title.value = v,
                        ),
                        CustomInputField(
                          label: "Instructor",
                          hint: "Instructor's name",
                          icon: Icons.person,
                          onChanged: (v) => controller.instructor.value = v,
                        ),
                        CustomInputField(
                          label: "Course Description",
                          hint: "What is this course about?",
                          icon: Icons.description,
                          maxLines: 3,
                          onChanged: (v) => controller.description.value = v,
                        ),
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
                        sectionTitle("Categorization"),
                        SizedBox(height: mediaQuery.size.height * 0.02),
                        Obx(() {
                          if (controller.isLoading.value) {
                            return CustomDropdownField(
                              label: "Category",
                              value: "Loading categories...",
                              items: ["Loading categories..."],
                              onChanged: (value) {},
                              icon: Icons.category,
                            );
                          } else if (controller.categories.isEmpty) {
                            return CustomDropdownField(
                              label: "Category",
                              value: "No categories found",
                              items: ["No categories found"],
                              onChanged: (value) {},
                              icon: Icons.category,
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
                              icon: Icons.category,
                            );
                          }
                        }),
                        CustomDropdownField(
                          label: "Language",
                          value: controller.language.value,
                          items: controller.languages,
                          onChanged: (v) => controller.language.value = v ?? "",
                          icon: Icons.language,
                        ),
                        CustomDropdownField(
                          label: "Level",
                          value: controller.level.value,
                          items: controller.levels,
                          onChanged: (v) => controller.level.value = v ?? "",
                          icon: Icons.bar_chart,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.025),
                AppCustomContainer(
                  widthColor: AppColors.dividercolor,
                  borderradius: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionTitle("Pricing & Duration"),
                        SizedBox(height: mediaQuery.size.height * 0.02),
                        CustomInputField(
                          label: "Duration",
                          hint: "e.g., 12 hours",
                          icon: Icons.access_time,
                          onChanged: (v) => controller.duration.value = v,
                        ),
                        CustomInputField(
                          label: "Price (₹)",
                          hint: "e.g., 499",
                          icon: Icons.currency_rupee,
                          onChanged: (v) => controller.price.value = v,
                        ),
                        CustomDropdownField(
                          label: "Access Duration",
                          value: controller.accessDurationn.value,
                          items: controller.accessDuration,
                          onChanged: (v) => controller.accessDurationn.value = v ?? "",
                          icon: Icons.category,
                        ),
                        Obx(() => Row(
                          children: [
                            Expanded(
                              child: Slider(
                                activeColor: AppColors.buttonColor,
                                value: controller.selectedDays.value.toDouble(),
                                min: 1,
                                max: 365,
                                divisions: 29,
                                label: "${controller.selectedDays.value} Days",
                                onChanged: (val) => controller.setDays(val.toInt()),
                              ),
                            ),
                            Text(
                              "${controller.selectedDays.value} Days",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.025),
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
                            sectionTitle("Curriculum"),
                            AppCustomButton(
                              action: controller.addChapter,
                              height: 40,
                              width: 120,
                              borderradius: 10,
                              ButtonName: "Add Chapter",
                            ),
                          ],
                        ),
                        SizedBox(height: mediaQuery.size.height * 0.02),
                        Obx(() => Column(
                          children: List.generate(controller.chapters.length, (index) {
                            final chapter = controller.chapters[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AppCustomContainer(
                                widthColor: AppColors.dividercolor,
                                borderradius: 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomInputField(
                                              label: "Chapter ${index + 1} Title",
                                              icon: Icons.title,
                                              controller: TextEditingController(
                                                text: chapter.title.value,
                                              )..selection = TextSelection.collapsed(
                                                  offset: chapter.title.value.length),
                                              onChanged: (v) => chapter.title.value = v,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline,
                                                color: Colors.red, size: 25),
                                            onPressed: () => controller.removeChapter(index),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Obx(() => Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ChoiceChip(
                                            backgroundColor: AppColors.white,
                                            label: const Text("Text"),
                                            selected: chapter.selectedModule.value == "text",
                                            onSelected: (_) {
                                              chapter.selectedModule.value = "text";
                                              chapter.addTextModule();
                                            },
                                          ),
                                          ChoiceChip(
                                            backgroundColor: AppColors.white,
                                            label: const Text("Video"),
                                            selected: chapter.selectedModule.value == "video",
                                            onSelected: (_) {
                                              chapter.selectedModule.value = "video";
                                              chapter.addVideoModule();
                                            },
                                          ),
                                          ChoiceChip(
                                            backgroundColor: AppColors.white,
                                            label: const Text("Document"),
                                            selected: chapter.selectedModule.value == "document",
                                            onSelected: (_) {
                                              chapter.selectedModule.value = "document";
                                              chapter.addDocumentModule();
                                            },
                                          ),
                                        ],
                                      )),
                                      const SizedBox(height: 16),
                                      Obx(() {
                                        List<Widget> moduleWidgets = [];
                                        int moduleNumber = 1;
                                        for (var module in chapter.textModules) {
                                          moduleWidgets.add(Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  AppCustomTexts(
                                                    TextName: "Module $moduleNumber: Text",
                                                    textStyle:
                                                    const TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons.delete_outline,
                                                        color: Colors.red),
                                                    onPressed: () => chapter.textModules.remove(module),
                                                  ),
                                                ],
                                              ),
                                              CustomInputField(
                                                label: "Module Title",
                                                hint: "e.g., What you will learn",
                                                icon: Icons.notes,
                                                onChanged: (v) => module["title"] = v,
                                              ),
                                              CustomInputField(
                                                label: "Enter your text content here...",
                                                maxLines: 3,
                                                onChanged: (v) => module["content"] = v,
                                              ),
                                              const Divider(),
                                            ],
                                          ));
                                          moduleNumber++;
                                        }
                                        for (var module in chapter.videoModules) {
                                          moduleWidgets.add(Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  AppCustomTexts(
                                                    TextName: "Module $moduleNumber: Video",
                                                    textStyle:
                                                    const TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons.delete_outline,
                                                        color: Colors.red),
                                                    onPressed: () => chapter.videoModules.remove(module),
                                                  ),
                                                ],
                                              ),
                                              CustomInputField(
                                                label: "Module Title",
                                                icon: Icons.video_label,
                                                onChanged: (v) => module["title"] = v,
                                              ),
                                              CustomInputField(
                                                label: "Enter YouTube or Video link...",
                                                icon: Icons.video_library,
                                                onChanged: (v) => module["link"] = v,
                                              ),
                                              const Divider(),
                                            ],
                                          ));
                                          moduleNumber++;
                                        }
                                        for (var module in chapter.documentModules) {
                                          moduleWidgets.add(Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  AppCustomTexts(
                                                    TextName: "Module $moduleNumber: Document",
                                                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                                                    onPressed: () => chapter.documentModules.remove(module),
                                                  ),
                                                ],
                                              ),
                                              CustomInputField(
                                                label: "Module Title",
                                                icon: Icons.insert_drive_file,
                                                onChanged: (v) => module["title"] = v,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: CustomInputField(
                                                      label: module["file"]?.isNotEmpty == true
                                                          ? module["file"].toString().split('/').last
                                                          : "No file chosen",
                                                      icon: Icons.file_present,
                                                      enable: false,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons.upload_file, color: Colors.blue),
                                                    onPressed: () async {
                                                      final result = await FilePicker.platform.pickFiles(
                                                        type: FileType.custom,
                                                        allowedExtensions: ['pdf', 'doc', 'docx'],
                                                        allowMultiple: false,
                                                        withData: false,
                                                      );

                                                    },
                                                  ),
                                                ],
                                              ),
                                              const Divider(),
                                            ],
                                          ));
                                          moduleNumber++;
                                        }
                                        return Column(children: moduleWidgets);
                                      })
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        )),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.025),
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
                          label: "Contact Number for Verification",
                          hint: "Instructor's Contact Number",
                          icon: Icons.phone,
                          onChanged: (v) => controller.mobile.value = v,
                        ),
                        SizedBox(height: mediaQuery.size.height * 0.01),
                        AppCustomTexts(
                          TextName:
                          "This number is required for verification. If our moderators cannot reach you, your listing may be disapproved. Please provide a working contact number.",
                          textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.grey.shade900,
                            fontFamily: "Times New Roman",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.025),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: Obx(() => AppLoadingButton(
                    isLoading: controller.isLoading.value,
                    onPressed: () => controller.submitCourse(),
                    buttonText: "Create Ad Campaign",
                  )),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
