import 'package:flutter/material.dart';

import 'App_Custom_Container.dart';

class AppCustomStack extends StatelessWidget {
  final Widget UpperStack;
  final Widget LowerStack;

  const AppCustomStack({
    super.key,
    required this.UpperStack,
    required this.LowerStack,
  });
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
          builder: (Context, contraints) {
            return SizedBox(
              height: contraints.maxHeight,
              width: contraints.maxWidth,
              child: Stack(
                children: [
                  AppCustomContainer(
                    height:  contraints.maxHeight * 0.37,
                    width: contraints.maxWidth,
                    color: Color(0xFFfefcf0),
                    child: UpperStack,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: AppCustomContainerStack(
                      borderradiusleft: 25,
                      borderradiusright: 25,
                      hieght: contraints.maxHeight * 0.65,
                      width: contraints.maxWidth,
                     // original color
                      color:Color(0xFF8dc63f),
                     // color:Colors.black,
                      child: LowerStack,
                    ),
                  ),
                ],
              ),
            );
          },

    );
  }
}
