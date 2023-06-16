import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/card_master_model.dart';
import '../repositories/card_master_repository.dart';

final cardMasterListProvider = StateNotifierProvider<CardMasterViewModel, List<CardMasterModel>>
  ((ref) => CardMasterViewModel());

class CardMasterViewModel extends StateNotifier<List<CardMasterModel>> {
  CardMasterViewModel() : super([]);

  CardMasterRepository repository = CardMasterRepository();

  Future<void> getAllCardMasters() async {
    state = await repository.getAllCardMasters();
  }
}
