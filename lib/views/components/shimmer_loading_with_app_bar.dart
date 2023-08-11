import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../commons/app_bar_contents.dart';

class ShimmerLoadingWithAppBar extends StatelessWidget {
  const ShimmerLoadingWithAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleBox('Manhole Card', context),
        actions: actionList(context),
      ),
      body: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: const Center(
            child: Text("後で実装"),
          )
      ),
    );
  }
}
