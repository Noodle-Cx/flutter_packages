import 'package:stark/stark.dart';

abstract class BaseInjectModule {
  Set<Bind> dataBinds();
  Set<Bind> domainBinds();
  Set<Bind> presentationBinds();

  Set<Bind> binds() {
    return <Bind>{}
      ..addAll(dataBinds())
      ..addAll(domainBinds())
      ..addAll(presentationBinds());
  }
}
