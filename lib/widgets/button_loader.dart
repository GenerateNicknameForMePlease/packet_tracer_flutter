import 'package:flutter/material.dart';

class ButtonLoader extends StatelessWidget {
  const ButtonLoader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
      ),
    );
  }
}
