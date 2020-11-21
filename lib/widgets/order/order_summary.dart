import 'package:flutter/material.dart';

class OrderSummary extends StatelessWidget {
  final List<String> names;

  OrderSummary({this.names});

  @override
  Widget build(BuildContext context) {
    String line1;
    String line2;
    int count = names.length;

    if (count < 3) {
      line1 = count == 1 ? names[0] : names[0] + ' and ' + names[1];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(line1),
          ),
        ],
      );
    } else {
      line1 = names[0] + ', ' + names[1];
      line2 = count == 3
          ? 'and ' + names[2]
          : names[2] + ' and ' + (count - 3).toString() + ' others';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(line1),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(line2),
          ),
        ],
      );
    }
  }
}
