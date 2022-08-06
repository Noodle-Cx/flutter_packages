import 'package:stark/stark.dart';

abstract class BasePresenter<ViewContract> implements Disposable {
  late ViewContract view;

  void init() {}
  void update() {}

  @override
  void dispose() {}
}
