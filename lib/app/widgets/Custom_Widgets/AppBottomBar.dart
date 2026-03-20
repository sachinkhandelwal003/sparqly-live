import 'package:flutter/material.dart';


class Appbottombar extends StatelessWidget {
  const Appbottombar({super.key});

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
      onTap: (index)
      {

      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school_outlined),
          label: 'Career',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book),
          label: 'Learn',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_outlined),
          label: 'Profile',
        ),
      ],
    );
  }
}
