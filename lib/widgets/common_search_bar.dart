import 'package:flutter/material.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/constants/themes.dart';

class CommonSearchBar extends StatelessWidget {
  final String? text;
  final bool enabled, ishsow;
  final double height;
  final IconData? iconData;
  final Function? onchanged;
 final TextEditingController? controller;
  const CommonSearchBar(
      {Key? key,
      this.text,
        this.onchanged,
      this.enabled = false,
      this.height = 48,
      this.iconData,
        this.controller,
      this.ishsow = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Container(
        height: height,
        child: Center(
          child: Row(
            children: <Widget>[
              ishsow == true
                  ? Icon(
                      iconData,
                      // FontAwesomeIcons.search,
                      size: 18,
                      color: Theme.of(context).primaryColor,
                    )
                  : SizedBox(),
              ishsow == true
                  ? SizedBox(
                      width: 8,
                    )
                  : SizedBox(),
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: 1,
                  enabled: enabled,
                  cursorColor: Theme.of(context).primaryColor,
                  onChanged: (String text){
                    onchanged!(text);
                  },
                  decoration: new InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      errorText: null,
                      border: InputBorder.none,
                      hintText: text,
                      hintStyle: TextStyles(context)
                          .getDescriptionStyle()
                          .copyWith(
                              color: AppTheme.secondaryTextColor,
                              fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
