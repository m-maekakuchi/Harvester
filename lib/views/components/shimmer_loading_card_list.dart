import 'package:flutter/material.dart';

import '../../handlers/padding_handler.dart';
import '../widgets/shimmer.dart';

class ShimmerLoadingCardList extends StatelessWidget {
  const ShimmerLoadingCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              for (int i = 0; i < 5; i++) ... {
                const SizedBox(height: 10),
                ShimmerWidget.roundedRectangular(
                  width: getW(context, 96),
                  height: getH(context, 16),
                  borderRadius: 20,
                ),
              }
            ],
          ),
        ),
      ),
    );
  }
}
