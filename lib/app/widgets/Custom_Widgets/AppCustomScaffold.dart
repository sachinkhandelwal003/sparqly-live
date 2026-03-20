import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparqly/app/constants/App_Colors.dart';
import '../../modules/dashboard/controllers/dashboard_controller.dart';
import 'App_Custom_Texts.dart';
import 'package:share_plus/share_plus.dart';

class AppCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? type;
  final int? id;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final Color? backgroundColor;
  final Icon? backIcon;
  final Future<void> Function(String type, int id)?
  onBookmark; // Nullable API function
  final bool showShare;
  final bool showBookmark;

  AppCustomAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.centerTitle = true,
    this.backgroundColor,
    this.backIcon,
    this.type,
    this.id,
    this.onBookmark,
    this.showShare = false,
    this.showBookmark = false,
  });

  final DashboardController dashboardController =
      Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    final RxBool _isLoading = false.obs;

    List<Widget> actionsList = [];

    if (showShare && type != null && id != null) {
      actionsList.add(
        IconButton(
          icon: const Icon(Icons.share, color: Colors.black87, size: 20),
          onPressed: () async {
            // Aapka Deep Link URL structure
            final String shareUrl = "https://backend.sparqly.in/$type/$id";

            // Share Sheet open hogi
            await Share.share(
              'Check this out on Sparqly: $shareUrl',
              subject: 'Sparqly $type',
            );
          },
        ),
      );
    }

    if (showBookmark && onBookmark != null && type != null && id != null) {
      actionsList.add(
        Obx(() {
          return IconButton(
            icon: _isLoading.value
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.blue,
                    ),
                  )
                : const Icon(Icons.bookmark_border, color: Colors.black87),
            onPressed: _isLoading.value
                ? null
                : () async {
                    const debugTag = "🔖🟢[Bookmark Button]";
                    print(
                      "$debugTag 🔹 Bookmark clicked for type: $type, id: $id",
                    );

                    try {
                      _isLoading(true);
                      await onBookmark!(type!, id!);
                      print(
                        "$debugTag ✅ Bookmark API call finished for type: $type, id: $id",
                      );
                    } catch (e, stackTrace) {
                      print("$debugTag ⚠️ Error occurred: $e");
                      print("$debugTag StackTrace: $stackTrace");
                    } finally {
                      _isLoading(false);
                    }
                  },
          );
        }),
      );
    }

    return AppBar(
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: backIcon ?? const Icon(Icons.arrow_back, color: AppColors.black),
        onPressed:
            onBackPressed ??
            () {
              dashboardController.goToPage(2);
            },
      ),
      title: AppCustomTexts(
        TextName: title,
        textStyle: Theme.of(
          context,
        ).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w500),
      ),
      actions: actionsList.isEmpty ? null : actionsList,
      centerTitle: centerTitle,
      backgroundColor:
          backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
