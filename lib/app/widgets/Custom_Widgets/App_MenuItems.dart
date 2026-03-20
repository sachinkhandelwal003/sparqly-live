import 'package:flutter/material.dart';
import 'package:sparqly/app/constants/App_Colors.dart';

class AppMenuItemButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onProfileTap;


  const AppMenuItemButton({
    Key? key,
    required this.icon,
    required this.onProfileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(

      color: AppColors.white,
      icon: Icon(icon, color: Colors.black),
      onSelected: (value) {
        if (value == 0) {
          onProfileTap?.call();
        } else if (value == 1) {
          // Logout tapped
          print("Logout clicked");
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Row(
            children: const [
              Icon(Icons.person, color: Colors.black),
              SizedBox(width: 8),
              Text("Profile"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: const [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 8),
              Text("Logout"),
            ],
          ),
        ),
      ],
    );
  }
}
