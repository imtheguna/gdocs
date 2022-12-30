import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateNotifierProvider<Counter, String>((ref) {
  return Counter();
});

class Counter extends StateNotifier<String> {
  String id = '';
  Counter() : super('');
  void increment(id) => state = id;
  String getId() {
    return id;
  }
}

class PreViewModel {
  final bool? isFromList;
  final String? id;
  PreViewModel({
    this.isFromList,
    this.id,
  });
}

// final previewRepositoryProvider = Provider((_) =>
//     PreViewModelProvider(preViewModel: preViewProvider.read(preViewProvider)));

final preViewProvider = StateProvider<PreViewModel>(
    (ref) => PreViewModel(id: '', isFromList: false));

class PreViewModelProvider {
  final PreViewModel _preViewModel;
  PreViewModelProvider({
    required PreViewModel preViewModel,
  }) : _preViewModel = preViewModel;

  Future<PreViewModel> getPreviewId() async {
    return await _preViewModel;
  }
}
