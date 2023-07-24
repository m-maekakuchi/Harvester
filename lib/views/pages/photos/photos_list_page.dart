import 'package:flutter/material.dart';

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