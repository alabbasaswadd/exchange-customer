import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import 'app_animation.dart';
import 'app_text.dart';

class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    super.key,
    required this.onOk,
    required this.onNo,
    required this.title,
    required this.content,
  });
  final Function() onOk;
  final Function() onNo;
  final String title;
  final String content;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        AppAnimation(
          scale: 0.85,
          child: MaterialButton(
            onPressed: onOk,
            color: AppColors.kPrimaryColor,
            textColor: AppColors.kWhiteColor,
            child: AppText("yes".tr, color: Colors.white),
          ),
        ),
        AppAnimation(
          scale: 0.85,
          child: MaterialButton(
            onPressed: onNo,
            color: Colors.red,
            textColor: AppColors.kWhiteColor,
            child: AppText("no".tr, color: Colors.white),
          ),
        ),
      ],
      title: AppText(title),
      content: AppText(
        maxLines: 3,
        content,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
    );
  }
}
