import 'package:intl/intl.dart';
import 'package:decimal/decimal.dart';

import 'documents/cnpj.dart';
import 'documents/cpf.dart';
import 'validators.dart';
import 'extensions.dart';

///Document
String? stringToCpfCnpj(String? value) {
  if (validateCpf(value)) {
    return CPF.format(value);
  }

  return CNPJ.format(value);
}

String? stringToMaskedCpfCnpj(String? value) {
  if (validateCpf(value)) {
    return CPF.maskedPix(value);
  }

  //BACEN exige não ter a máscara no CNPJ - CNPJ.maskedPix
  return CNPJ.format(value);
}

String stringToCellPhone(String value) {
  final numbers = value.toNumber();

  if (numbers.length == 10) {
    return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 6)}-${numbers.substring(6, 10)}';
  }

  if (numbers.length == 11) {
    return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 7)}-${numbers.substring(7, 11)}';
  }

  if (numbers.length == 13) {
    return '${numbers.substring(0, 2)} (${numbers.substring(2, 4)}) ${numbers.substring(4, 9)}-${numbers.substring(9, 13)}';
  }

  if (numbers.length == 14) {
    return '${numbers.substring(0, 3)} (${numbers.substring(3, 5)}) ${numbers.substring(5, 9)}-${numbers.substring(9, 14)}';
  }

  return numbers;
}

////Date
String? dateToString(DateTime? date, {String format = 'dd/MM/yyyy'}) {
  return date != null ? DateFormat(format).format(date) : null;
}

String? dateToStringDateHour(DateTime date) {
  return dateToString(date, format: 'dd/MM/yyyy, HH:mm');
}

String? dateToExtendedString(DateTime date) {
  return dateToString(date, format: 'dd MMM yyyy, HH:mm');
}

String stringToNumbers(String value) {
  return value.replaceAll(RegExp(r'[^0-9]'), '');
}

DateTime? stringToDate(String value) {
  final dateFormats = [
    "yyyy-MM-dd'T'HH:mm:ss.SSSz",
    "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
    "yyyy-MM-dd'T'HH:mm:ss'Z'",
    "yyyy-MM-dd'T'HH:mm:ss.SSS",
    "yyyy-MM-dd'T'HH:mm:ss",
    'yyyy-MM-dd HH:mm:ss',
    'yyyy-MM-dd',
    'dd/MM/yyyy',
  ];

  for (var format in dateFormats) {
    try {
      return DateFormat(format).parse(value);
    } catch (e) {
      //nothimg
    }
  }

  return null;
}

String stringToNormalizeAgency(String? value) {
  return value?.toString().padLeft(4, '0') ?? '';
}

///Decimal
String? decimalToReais(Decimal? value) {
  return value != null
      ? NumberFormat.currency(locale: 'pt', decimalDigits: 2, symbol: 'R\$')
          .format(value.toDouble())
      : null;
}

String? decimalToMoney(Decimal? value) {
  return value != null
      ? NumberFormat.currency(locale: 'pt', decimalDigits: 2, symbol: '')
          .format(value.toDouble())
      : null;
}

String? decimalToPercent(Decimal? value) {
  return value != null
      ? NumberFormat.percentPattern().format(value.toDouble())
      : null;
}

Decimal stringToDecimal(String value) {
  final nValue = value.replaceAll('.', '').replaceAll(',', '.');
  return Decimal.parse(nValue);
}

double stringToDouble(String value, {String symbol = ''}) {
  final nValue =
      value.replaceAll(symbol, '').replaceAll('.', '').replaceAll(',', '.');
  return double.tryParse(nValue) ?? 0.0;
}

///Double
String doubleToReais(double value, {bool withCents = true}) {
  var valueFormatted = NumberFormat.currency(
          locale: 'pt', decimalDigits: withCents ? 2 : 0, symbol: 'R\$')
      .format(value);

  return valueFormatted;
}

String doubleToPercent(double value) {
  return '${value.toMoney()}%'.replaceAll(',00', '');
}

String doubleToMoney(double value,
    {String cypher = '', bool withCents = true}) {
  var valueFormatted = NumberFormat.currency(
          locale: 'pt', decimalDigits: withCents ? 2 : 0, symbol: cypher)
      .format(value);
  return valueFormatted;
}

///String
String stringToInitials(String value) {
  if (value.isNotEmpty) {
    final listName = value.split(' ');
    if (listName.length == 1) {
      if (listName.first.length == 1) {
        return listName.first.substring(0, 1);
      }
      return listName.first.substring(0, 2);
    } else {
      return listName.first.substring(0, 1) + listName.last.substring(0, 1);
    }
  }

  return 'UN';
}

String stringToPixKey(String? value) {
  if (value != null) {
    if (value.isValidCpfOrCnpj()) {
      return value.toCpfCnpj() ?? '';
    }

    if (value.isValidPhone()) {
      return value.toPhone();
    }
  }

  return value ?? '';
}
