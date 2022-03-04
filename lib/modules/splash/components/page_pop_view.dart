import 'package:flutter/material.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/language/appLocalizations.dart';

class PagePopup extends StatelessWidget {
  final PageViewData imageData;

  const PagePopup({Key? key, required this.imageData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 10,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Container(
                width: MediaQuery.of(context).size.width - 90,
                height: MediaQuery.of(context).size.height * 0.75,
                child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(
                      imageData.assetsImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
              child: Text(
                AppLocalizations(context).of(imageData.titleText),
                textAlign: TextAlign.center,
                style: TextStyles(context).getIntroTitleStyle().copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: Text(
              AppLocalizations(context).of(imageData.subText),
              textAlign: TextAlign.center,
              style: TextStyles(context)
                  .getIntroDescriptionStyle()
                  .copyWith(fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}

class PageViewData {
  final String titleText;
  final String subText;
  final String assetsImage;

  PageViewData({
    required this.titleText,
    required this.subText,
    required this.assetsImage,
  });
}
