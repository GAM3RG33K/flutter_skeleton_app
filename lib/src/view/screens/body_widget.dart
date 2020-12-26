import 'package:flutter/material.dart';

class BodyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'Welcome Home!!',
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ),
    );
  }
}
