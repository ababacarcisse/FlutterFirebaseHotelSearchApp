import 'package:flutter/material.dart';
import 'package:travel_app/Function/function.dart';
import 'package:travel_app/widgets/app_text.dart';

import '../misc/colors.dart';
import '../pages/ScreenPage.dart';

class ResponsiveButton extends StatelessWidget {
  bool? isResponsive;
  double? width;
  ResponsiveButton({super.key, this.isResponsive = false, this.width = 120});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          navigateTo(context, ScreenPage());
        },
        child: Container(
          width: isResponsive == true ? double.maxFinite : width,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.mainColor,
          ),
          child: Row(
            mainAxisAlignment: isResponsive == true
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              isResponsive == true
                  ? Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: const AppText(
                          size: 15, text: 'Book Trip Now', color: Colors.white),
                    )
                  : Container(),
              Image.asset("images/button-one.png"),
            ],
          ),
        ),
      ),
    );
  }
}
