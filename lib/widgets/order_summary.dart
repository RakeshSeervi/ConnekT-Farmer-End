import 'package:flutter/material.dart';

class OrderSummary extends StatelessWidget {
  final List<String> names;

  OrderSummary({this.names});

  @override
  Widget build(BuildContext context) {
    switch (names.length) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(names[0]),
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(names[0] + ' and'),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(names[1]),
            ),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(names[0] + ', ' + names[1]),
            ),
            FittedBox(fit: BoxFit.scaleDown, child: Text('and ' + names[2])),
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(names[0] + ', ' + names[1]),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(names[2] +
                  ' and ' +
                  (names.length - 3).toString() +
                  ' others'),
            )
          ],
        );
    }
  }
}
