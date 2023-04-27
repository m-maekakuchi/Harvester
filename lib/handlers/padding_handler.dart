import 'package:flutter/material.dart';

// 縦比率
double getH(BuildContext context, int height) {
  final basicHieght = MediaQuery.of(context).size.height;
  return basicHieght * (height / 100);
}
// 横比率
double getW(BuildContext context, int width) {
  final basicHieght = MediaQuery.of(context).size.width;
  return basicHieght * (width / 100);
}