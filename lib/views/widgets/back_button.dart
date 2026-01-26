import 'package:flutter/material.dart';
import 'package:hamsa_flutter/constants/app_constants.dart';

class AppBackButton extends Padding {
  AppBackButton({super.key})
    : super(
        padding: const EdgeInsets.only(bottom: 12),
        child: Builder(
          builder: (context) {
            return InkWell(
              onTap: () => Navigator.pop(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.arrow_back, size: 20),
                  SizedBox(width: 6),
                  Text(AppStrings.goBackTitle, style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          },
        ),
      );
}
