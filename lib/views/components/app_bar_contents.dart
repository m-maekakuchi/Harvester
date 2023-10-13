import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../handlers/padding_handler.dart';

// AppBarのアイコンとタイトルを組み合わせたWidget
SizedBox titleBox(String title, BuildContext context) {
  final height = AppBar().preferredSize.height;

  return SizedBox(
    width: getW(context, 60),
    height: height,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center, // アイコンと文字列セットでセンターに配置
      children: [
        Image.asset(
          height: height * 0.6,
          'images/AppBar_logo.png'
        ),
        Flexible(
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        )
      ]
    ),
  );
}

// AppBarのアクションボタンのリスト
List<Widget> actionList(BuildContext context) {
  return [
    IconButton(
      onPressed: () {
        context.push('/settings/setting_page');
      },
      icon: const Icon(Icons.settings_rounded),
    ),
  ];
}