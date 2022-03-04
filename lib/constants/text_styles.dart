import 'package:flutter/material.dart';
import 'package:new_motel/constants/themes.dart';

class TextStyles {
  final BuildContext context;

  TextStyles(this.context);

  TextStyle getTitleStyle() {
    return Theme.of(context).textTheme.headline6!.copyWith(
          fontSize: 24,
          color: AppTheme.primaryTextColor,
        );
  }

  TextStyle getIntroTitleStyle() {
    return Theme.of(context).textTheme.headline6!.copyWith(
          fontSize: 24,
          color: AppTheme.thirdTextColor,
        );
  }

  TextStyle getTitle2Style() {
    return Theme.of(context).textTheme.headline6!.copyWith(
          fontSize: 20,
          color: AppTheme.primaryTextColor,
        );
  }

  TextStyle getDescriptionStyle() {
    return Theme.of(context).textTheme.bodyText1!.copyWith(
          color: AppTheme.secondaryTextColor,
        );
  }

  TextStyle getIntroDescriptionStyle() {
    return Theme.of(context).textTheme.bodyText1!.copyWith(
          color: AppTheme.thirdTextColor,
        );
  }

  TextStyle getRegularStyle() {
    return Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: 16,
          color: AppTheme.thirdTextColor,
        );
  }

  TextStyle getHintStyle() {
    return Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: 20,
          color: AppTheme.primaryTextColor,
        );
  }

  TextStyle getBoldStyle() {
    return Theme.of(context).textTheme.subtitle1!.copyWith(
          fontSize: 14,
          color: AppTheme.primaryTextColor,
        );
  }
}
