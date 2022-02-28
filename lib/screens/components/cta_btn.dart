import 'package:flutter/material.dart';

import '../../constants.dart';

class CTA_Btn extends StatelessWidget {
  final Function onPressed;
  final String value;
  final BtnStyle style;

  CTA_Btn(this.onPressed, this.value, this.style);

  @override
  Widget build(BuildContext context) {
    var btnStyling = ElevatedButton.styleFrom(primary: kPrimaryColor);
    var textStyling = kPrimaryActionBtnStyle;
    if (this.style == BtnStyle.secondary) {
      btnStyling = ElevatedButton.styleFrom(
        primary: Color(0xFFFFFFFF),
        side: BorderSide(color: kPrimaryColor),
      );
      textStyling = kPrimaryActionBtnStyle.copyWith(color: kPrimaryColor);
    }
    return ElevatedButton(
      onPressed: () => this.onPressed(),
      style: btnStyling,
      child: Container(
        width: double.infinity,
        height: 48,
        child: Center(
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: textStyling,
          ),
        ),
      ),
    );
  }
}
