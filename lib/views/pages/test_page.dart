import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvester/commons/app_color.dart';

final buttonProvider = StateNotifierProvider<ButtonNotifier, AsyncValue<bool>>((ref) {
  return ButtonNotifier();
});

class ButtonNotifier extends StateNotifier<AsyncValue<bool>> {
  ButtonNotifier() : super(const AsyncValue.data(false));

  Future<void> getNewNumber() async {
    try {
      state = const AsyncValue.loading();
      await Future.delayed(const Duration(seconds: 2));
      throw Exception('エラーメッセージ');
      state = const AsyncValue.data(true);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

class TestPage extends ConsumerWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final randomNumberNotifier = ref.watch(buttonProvider);

    Widget button = ElevatedButton(
      child: const Text("テスト"),
      onPressed: () async {
        await ref.read(buttonProvider.notifier).getNewNumber();
        if (randomNumberNotifier.value == false) {
          return;
        } else {
          Future.delayed(
            const Duration(seconds: 1),
            () => context.pop(),
          );
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  title: Icon(
                    Icons.done_rounded, size: 80, color: textIconColor),
                  content: Text("登録が完了しました", textAlign: TextAlign.center),
                );
              }
            );
          }
        }
      }
    );

    return Scaffold(
      body: randomNumberNotifier.when(
        data: (value) {
          return button;
        },
        error: (err, _) {
          return Text(err.toString());
        },
        loading: () {
          return Stack(
            children: [
              button,
              const ColoredBox(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ]
          );
        },
      ),
    );
  }
}