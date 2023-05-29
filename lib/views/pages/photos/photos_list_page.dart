import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../handlers/padding_handler.dart';

class PhotosListPage extends StatelessWidget {
  const PhotosListPage({super.key});

  @override
  Widget build(BuildContext context) {

    Widget photoContainer(image) {
      return Container(
        width: getW(context, 49.6),
        margin: EdgeInsets.all(getW(context, 0.2)),
        child: Image.network(image),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(  // 幅を設定しないとcenterにならない
          width: getW(context, 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,  // アイコンと文字列セットでセンターに配置
            children: [
              Image.asset(
                width: getW(context, 10),
                height: getH(context, 10),
                'images/AppBar_logo.png'
              ),
              const Text("写真"),
            ]
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/settings/setting_page');
            },
            icon: const Icon(Icons.settings_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Row(
                children: [
                  photoContainer('https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1'),
                  photoContainer('https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1'),
                ],
              ),
              Row(
                children: [
                  photoContainer('https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1'),
                  photoContainer('https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1'),
                ],
              ),
              Row(
                children: [
                  photoContainer('https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1'),
                  photoContainer('https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1'),
                ],
              ),
              Row(
                children: [
                  photoContainer('https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1'),
                  photoContainer('https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1'),
                ],
              ),
              Row(
                children: [
                  photoContainer('https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1'),
                  photoContainer('https://i0.wp.com/kagohara.net/wp-content/uploads/2022/11/manholecard09.jpg?w=1500&ssl=1'),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}