import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/card_master_model.dart';
import '../repositories/card_master_repository.dart';

final scrollCardMasterViewModelProvider = StateNotifierProvider<ScrollCardMasterViewModel, List<CardMasterModel>>
  ((ref) => ScrollCardMasterViewModel(ref));

class ScrollCardMasterViewModel extends StateNotifier<List<CardMasterModel>> {
  final Ref ref;
  ScrollCardMasterViewModel(this.ref) : super([]);

  CardMasterRepository repository = CardMasterRepository();

  Future<void> add() async {
    List<CardMasterModel>? list = state;

    List<CardMasterModel>? newList = await repository.getLimitCountCardMasters();
    state = [... list, ... newList];
    print("ロードした最後のカード番号${state.last.serialNumber}");
  }
}
