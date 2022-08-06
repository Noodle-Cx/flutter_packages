import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:noodle_utils/noodle_utils.dart';
import 'package:stark/stark.dart';

import '../exception/error_handler.dart';
import '../exception/noodle_exception.dart';

/// Abstract class for a UseCase
abstract class UseCase<Type, Params> {
  @protected
  Future<Type> run(Params params);

  // ignore: prefer_function_declarations_over_variables
  Function(Type) _onSuccess = (_) {};

  // ignore: prefer_function_declarations_over_variables
  Function(NoodleException) _onError = (_) {};

  final ErrorHandler _errorHandler = Stark.get();
  final AnalyticsProvider _noodleAnalytics = Stark.get();

  UseCase<Type, Params> execute({
    Params? params,
    bool withLoading = false,
    bool withError = false,
  }) {
    _tryExecute(
      params ?? None() as Params,
      withLoading: withLoading,
      withError: withError,
    );
    return this;
  }

  @protected
  NoodleException handleError(NoodleException exception) {
    return exception;
  }

  UseCase<Type, Params> onError(Function(NoodleException) action) {
    _onError = action;
    return this;
  }

  UseCase<Type, Params> onSuccess(Function(Type) action) {
    _onSuccess = action;
    return this;
  }

  Future<Type> asFuture({
    Type Function(NoodleException)? errorParser,
  }) {
    final Completer<Type> completer = Completer();
    onSuccess((data) {
      completer.complete(data);
    }).onError((e) {
      if (errorParser != null) {
        completer.complete(errorParser(e));
      } else {
        completer.completeError(e);
      }
    });
    return completer.future;
  }

  Stream<Type> asStream({
    Type Function(NoodleException)? errorParser,
  }) {
    return Stream.fromFuture(asFuture(errorParser: errorParser));
  }

  Future _tryExecute(
    Params params, {
    bool withLoading = false,
    bool withError = false,
  }) async {
    try {
      final result = await run(params);
      _onSuccess(result);
    } on Exception catch (e) {
      final error = _errorHandler.handle(e);
      _noodleAnalytics.logException(error);
      _onError(handleError(error));
    } catch (e) {
      var error = e;
      if (error is! NoodleException) {
        error = UnexpectedException();
      }

      _noodleAnalytics.logException(error);
      _onError(handleError(error));
    }
  }
}

class None {}
