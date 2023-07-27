import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/commons/app_color.dart';
import 'package:harvester/handlers/padding_handler.dart';
import 'package:harvester/viewModels/auth_view_model.dart';

import '../../repositories/image_repository.dart';


final imageUrlProvider = StateProvider((ref) => ["", ""]);

class TestPage extends ConsumerWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = ref.watch(imageUrlProvider);

    return Scaffold(
      body: Center(
        child: Container(
          width: getW(context, 50),
          height: getH(context, 50),
          color: Colors.red,
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl[0],
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              CachedNetworkImage(
                imageUrl: imageUrl[1],
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ],)
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // ref.read(imageUrlProvider.notifier).state =
           // await ImageRepository().downloadImageFromFireStore(ref);

          // String uid = ref.read(authViewModelProvider.notifier).getUid();
          // String dir = "02-201-A001";
          // // String img = "image_cropper_1689917623433.jpg";
          // String fileFullPath = "$uid/$dir";
          //
          // final storageRef = FirebaseStorage.instance.ref();
          // final pathReference = storageRef.child(fileFullPath);
          // final listResult = await pathReference.listAll();
          //
          // for (var result in listResult.items) {
          //   print(await result.getDownloadURL());
          // }

        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.navigation),
      ),
    );
  }
}