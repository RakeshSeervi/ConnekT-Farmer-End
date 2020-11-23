import 'package:agri_com/constants.dart';
import 'package:flutter/material.dart';

class CustomActionBar extends StatelessWidget {
  final String title;
  final bool hasBackArrrow;
  final bool hasBackground;

  CustomActionBar({
    this.title,
    this.hasBackArrrow,
    this.hasBackground,
  });

  @override
  Widget build(BuildContext context) {
    bool _hasBackArrow = hasBackArrrow ?? false;
    bool _hasBackground = hasBackground ?? true;

    return Container(
      decoration: BoxDecoration(
          gradient: _hasBackground
              ? LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0),
                  ],
                  begin: Alignment(0, 0),
                  end: Alignment(0, 1),
                )
              : null),
      padding: EdgeInsets.only(
        top: 56.0,
        left: 16.0,
        right: 12.0,
        bottom: 42.0,
      ),
      child: Row(
        children: [
          if (_hasBackArrow)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: _hasBackArrow ? 16 : 0),
            child: Text(
              title ?? "",
              style: Constants.boldHeading,
            ),
          ),
        ],
      ),
    );
  }
}
