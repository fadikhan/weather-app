import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class MinMaxText extends StatelessWidget {
  final String text;
  const MinMaxText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text
        ,style: kMinMaxTempTextStyle,
      ),
    );
  }
}
