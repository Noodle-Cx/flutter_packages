import 'documents/cnpj.dart';
import 'documents/cpf.dart';
import 'formatters.dart';
import 'extensions.dart';

bool validateCpf(String? cpf) {
  return CPF.isValid(cpf);
}

bool validateCnpj(String? cnpj) {
  return CNPJ.isValid(cnpj);
}

bool validateCpfOrCnpj(String? value) {
  if (validateCpf(value)) {
    return true;
  }
  return validateCnpj(value);
}

bool validateDate(String date, {bool pastDate = false}) {
  final dateRegex = RegExp(
      r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$');
  return dateRegex.hasMatch(date) &&
      date.toDate()?.isAfter(DateTime(1920, 01, 01)) == true &&
      (!pastDate || date.toDate()?.isBefore(DateTime.now()) == true);
}

bool validatePhone(String? phone) {
  if (phone != null) {
    final value = stringToCellPhone(phone);
    final ddiRegex = RegExp(r'^(?:\+?)\d{2}?\s?\(?\d{2}\)?[\s-]?\d{5}-?\d{4}$');
    final dddRegex = RegExp(r'^\(?\d{2}\)?[\s-]?\d{5}-?\d{4}$');
    return ddiRegex.hasMatch(value) || dddRegex.hasMatch(value);
  }
  return false;
}

bool validateEmail(String? email) {
  if (email != null) {
    return RegExp(r'^[\w-.+]+@([\w-]+\.)+[\w-.]+$').hasMatch(email);
  }
  return false;
}

bool validateCEP(String cep) {
  return RegExp(r'^[0-9]{5}-[0-9]{3}').hasMatch(cep);
}

int getBankAgencySize(String bankNumber) {
  switch (bankNumber) {
    case '001':
      return 5;
    default:
      return 4;
  }
}

int? getExactBankAccountLength(String bankNumber) {
  switch (bankNumber) {
    case '033':
      return 9;
    default:
      return null;
  }
}

int getMaxBankAccountLength(String bankNumber) {
  switch (bankNumber) {
    case '237':
      return 8;
    case '323':
      return 11;
    default:
      return 10;
  }
}

bool validatePixKey(String? key) {
  if (validateCpfOrCnpj(key)) {
    return true;
  }

  if (validatePhone(key)) {
    return true;
  }

  if (validateEmail(key)) {
    return true;
  }

  if (validateEvpKey(key)) {
    return true;
  }

  return false;
}

bool validatePixQrCode(String? qrCode) {
  return (qrCode?.length ?? 0) > 99;
}

bool validateEvpKey(String? key) {
  if (key != null) {
    if (key.length == 36) {
      return true;
    }

    if (key.length == 32 && !key.contains('@')) {
      return true;
    }
  }
  return false;
}
