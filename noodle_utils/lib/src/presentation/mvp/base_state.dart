import 'package:noodle_utils/noodle_utils.dart';
import 'package:flutter/material.dart';
import 'package:stark/stark.dart';
import 'base_presenter.dart';

abstract class BaseState<T extends StatefulWidget,
    Presenter extends BasePresenter> extends InjectableState<T> {
  late Presenter presenter;

  @override
  @mustCallSuper
  void initState() {
    presenter = get();
    presenter.view = this;
    super.initState();
    presenter.init();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    presenter.update();
  }
}
