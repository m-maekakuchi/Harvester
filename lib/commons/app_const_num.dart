import 'card_master_option_list.dart';

// カード１枚あたりに登録できる写真数
const imageNumPerCard = 4;

// マイカード一覧画面　AppBarのbottomのTabの横幅
const myCardAppBarTabWidth = 25;

// 全てのカード一覧画面　AppBarのbottomのTabの横幅
const allCardAppBarTabWidth = 50;

// カード一覧画面のローディング数
const loadingNum = 30;

// マスターカードの枚数
final cardMasterNum = getListNum();

int getListNum () {
  int num = 0;
  for (List<String>list in cardMasterOptionStrList) {
    num += list.length;
  }
  return num;
}