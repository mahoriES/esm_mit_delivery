import 'package:esamudaayapp/themes/custom_theme.dart';
import 'package:flutter/material.dart';

import 'app_update_service.dart';

class AppUpdateBanner extends StatelessWidget {
  final String updateMessage;
  final String updateButtonText;
  const AppUpdateBanner({
    @required this.updateMessage,
    @required this.updateButtonText,
    Key key,
  })  : assert(
          updateMessage != null && updateButtonText != null,
          "updateMessage and updateButtonText cannot be null",
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomTheme.of(context).colors.secondaryColor,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          SizedBox(width: 20),
          Expanded(
            child: Text(
              updateMessage,
              style: CustomTheme.of(context).textStyles.body1.copyWith(
                    color: CustomTheme.of(context).colors.backgroundColor,
                  ),
            ),
          ),
          SizedBox(width: 20),
          InkWell(
            onTap: AppUpdateService.updateApp,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 23, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(
                    color: CustomTheme.of(context).colors.backgroundColor),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                updateButtonText,
                style:
                    CustomTheme.of(context).textStyles.sectionHeading2.copyWith(
                          color: CustomTheme.of(context).colors.backgroundColor,
                        ),
              ),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}
