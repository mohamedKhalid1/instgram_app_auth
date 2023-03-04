import 'package:flutter/material.dart';
import 'package:instgram_clone/utils/constants.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key, required this.mobileScreenLayout,required this.webScreenLayout});
  final Widget mobileScreenLayout;
  final Widget webScreenLayout;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constrains){
      if(constrains.maxWidth>Constants.screenWebSize){
        return webScreenLayout;
      }
      return mobileScreenLayout;
    });
  }
}
