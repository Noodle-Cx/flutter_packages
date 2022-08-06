import 'package:rxdart/rxdart.dart';

import '../domain/interactor/use_case.dart';

extension NoodleStreams<T> on Subject<T?> {
  Future<void> addUseCase(UseCase<dynamic, dynamic> useCase,
      {Function(T)? runOnSuccess}) async {
    add(null);
    useCase.onSuccess((data) {
      runOnSuccess?.call(data);
      add(data);
    }).onError(addError);
  }
}
