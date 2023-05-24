import 'package:flutter/material.dart';

// 縦比率
double getH(BuildContext context, double height) {
  final basicHeight = MediaQuery.of(context).size.height;
  return basicHeight * (height / 100);
}
// 横比率
double getW(BuildContext context, double width) {
  final basicHeight = MediaQuery.of(context).size.width;
  return basicHeight * (width / 100);
}