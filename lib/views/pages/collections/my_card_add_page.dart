import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../commons/app_color.dart';
import '../../../commons/image_num_per_card.dart';
import '../../../commons/message.dart';
import '../../../commons/message_dialog.dart';
import '../../../handlers/convert_data_type_handler.dart';
import '../../../handlers/padding_handler.dart';
import '../../../models/card_model.dart';
import '../../../models/image_model.dart';
import '../../../models/user_info_model.dart';
import '../../../repositories/card_master_repository.dart';
import '../../../repositories/card_repository.dart';
import '../../../repositories/photo_repository.dart';
import '../../../viewModels/auth_view_model.dart';
import '../../../viewModels/image_view_model.dart';
import '../../../viewModels/user_view_model.dart';
import '../../components/accordion_card_masters.dart';
import '../../components/pick_and_crop_image_container.dart';
import '../../components/title_container.dart';
import '../../widgets/bookmark_button.dart';
import '../../widgets/green_button.dart';
import '../../components/user_select_item_container.dart';
import '../../components/white_show_modal_bottom_sheet.dart';

final cardProvider = StateProvider((ref) => noSelectOptionMessage);
final dateProvider = StateProvider((ref) => DateTime.now());
// trueならお気に入り登録する
final bookmarkProvider = StateProvider((ref) => false);

class MyCardAddPage extends ConsumerWidget {
  const MyCardAddPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final selectCard = ref.watch(cardProvider);
    final selectedDate = ref.watch(dateProvider);
    final selectedImageList = ref.watch(imageListProvider);

    // 日付のPickerを表示
    Future<DateTime?> showDate(date) {
      return showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: themeColor,      // ヘッダー背景色
                onPrimary: textIconColor, // ヘッダーテキストカラー
                onSurface: textIconColor, // カレンダーのテキストカラー
              ),
              textButtonTheme: const TextButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(textIconColor), // ボタンの色
                ),
              ),
            ),
            child: child!,
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
          title: SizedBox(
            width: getW(context, 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,  // アイコンと文字列セットでセンターに配置
              children: [
                Image.asset(
                  width: getW(context, 10),
                  height: getH(context, 10),
                  'images/AppBar_logo.png'
                ),
                const Text("My Card 追加"),
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
        child: Column(
          children: [
            SizedBox(height: getH(context, 3)),
            // 写真選択欄
            for (var i = 0; i < imageNumPerCard / 2; i++) ... {
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var j = 0; j < 2; j++) ... {
                    PickAndCropImageContainer(index: i * 2 + j),
                  },
                ]
              ),
            },
            const TitleContainer(titleStr: 'カード'),
            // カード選択欄
            UserSelectItemContainer(
              text: selectCard,
              onPressed: () {
                whiteShowModalBottomSheet(
                  context: context,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                    ),
                    height: getH(context, 90),
                    child: AccordionCardMasters(
                      provider: cardProvider,
                    ),
                  ),
                );
              },
            ),
            const TitleContainer(titleStr: '収集日'),
            // 収集日選択欄
            UserSelectItemContainer(
              text: '${selectedDate.year}/${selectedDate.month}/${selectedDate.day}',
              onPressed: () async {
                final selectedDayFromCalendar = await showDate(selectedDate);
                // 日付が選択された場合
                if (selectedDayFromCalendar != null) {
                  final notifier = ref.read(dateProvider.notifier);
                  notifier.state = selectedDayFromCalendar;
                }
              },
            ),
            SizedBox(height: getH(context, 2)),
            // お気に入り選択
            BookMarkButton(provider: bookmarkProvider),
            SizedBox(height: getH(context, 2),),
            GreenButton(
              text: '登録',
              fontSize: 18,
              onPressed: selectedImageList.isEmpty || selectCard == noSelectOptionMessage
                ? null
                : () async {
                // 選択されたカード番号取得
                RegExp regex = RegExp(r'\s');
                String selectedCardMasterNumber = selectCard.split(regex)[0];

                // imageListProviderの各imageModelのfilePathを設定
                final uid = ref.read(authViewModelProvider.notifier).getUid();
                for(ImageModel model in selectedImageList) {
                  model.filePath = "$uid/$selectedCardMasterNumber";
                }

                // 画像をstorageに登録
                await ref.read(imageListProvider.notifier).uploadImageToFirebase();

                // photoモデルリストの作成
                final photoModelList = convertListData(ref.read(imageListProvider), ref);

                // photosコレクションに登録（戻り値：ドキュメント参照の配列）
                // --------ここで失敗したらstorageに登録したやつ削除-----------------
                List<DocumentReference> photoDocRefList = await PhotoRepository().setToFireStore(photoModelList);

                //　選択したマスターカードのドキュメント参照を取得
                final cardMasterDocRef = await CardMasterRepository().getCardMasterRef(selectedCardMasterNumber);
                final now = DateTime.now();
                // cardモデルの作成
                final cardModel = CardModel(
                  cardMaster: cardMasterDocRef,
                  photos: photoDocRefList,
                  favorite: ref.read(bookmarkProvider),
                  collectDay: selectedDate,
                  createdAt: now,
                  updatedAt: now,
                );
                // cardsコレクションに登録（戻り値：ドキュメント参照）
                // -------------ここで失敗したらstorageとphotoコレクションに登録したやつ削除--------------------
                final cardDocRef = await CardRepository().setToFireStore(cardModel, "$uid$selectedCardMasterNumber");

                // userモデルの作成
                final userModel = UserInfoModel(
                  firebaseAuthUid: uid,
                  cards: [cardDocRef],
                );
                await ref.read(userViewModelProvider.notifier).setState(userModel);
                // cardの情報をFireStoreに登録
                // -------------ここで失敗したらstorageとphotoコレクションとcardsコレクションに登録したやつ削除--------------------
                await ref.read(userViewModelProvider.notifier).updateCardsFireStore();

                // プロバイダをリセット
                await ref.read(imageListProvider.notifier).init();
                ref.read(cardProvider.notifier).state = noSelectOptionMessage;
                ref.read(dateProvider.notifier).state = DateTime.now();
                ref.read(bookmarkProvider.notifier).state = false;

                // 登録完了のダイアログを表示
                if (context.mounted) await messageDialog(context, registerCompleteMessage);
              },
            ),
          ]
        ),
      ),
    );
  }

}