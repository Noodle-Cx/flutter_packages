import 'package:decimal/decimal.dart';
import 'formatters.dart';
import 'validators.dart';

const brDateFormat = "dd/MM/yyyy";
const usDateFormat = "yyyy-MM-dd";
String dayMonthExtended(String of) => "dd $of MMMM";

extension StringFormaters on String {
  String? toCpfCnpj() => stringToCpfCnpj(this);
  String? toMaskedCpfCnpj() => stringToMaskedCpfCnpj(this);
  String toPhone() => stringToCellPhone(this);
  Decimal toDecimal() => stringToDecimal(this);
  double toDouble({String symbol = 'R\$'}) =>
      stringToDouble(this, symbol: symbol);
  String toInitials() => stringToInitials(this);
  String toNumber() => stringToNumbers(this);
  DateTime? toDate() => stringToDate(this);
  String toNormalizeAgency() => stringToNormalizeAgency(this);
  String toPixKey() => stringToPixKey(this);
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

extension StringValidators on String {
  bool isValidCpf() => validateCpf(this);
  bool isValidCnpj() => validateCnpj(this);
  bool isValidCpfOrCnpj() => validateCpfOrCnpj(this);
  bool isValidPhone() => validatePhone(this);
  bool isValidEmail() => validateEmail(this);
  bool isValidCEP() => validateCEP(this);
  bool isValidDate({bool pastDate = false}) =>
      validateDate(this, pastDate: pastDate);
  bool isValidPixKey() => validatePixKey(this);
  bool isValidPixQrCode() => validatePixQrCode(this);
}

extension DecimalFormaters on Decimal {
  String? toReais() => decimalToReais(this);
  String? toMoney() => decimalToMoney(this);
  String? toPercent() => decimalToPercent(this);
}

extension DoubleFormaters on double {
  String toReais({bool withCents = true}) =>
      doubleToReais(this, withCents: withCents);
  String toMoney({String cypher = '', bool withCents = true}) =>
      doubleToMoney(this, cypher: cypher, withCents: withCents);
  String toPercent() => doubleToPercent(this);
}

extension DateFormaters on DateTime {
  String toSimpleString({String format = brDateFormat}) =>
      dateToString(this, format: format) ?? '';

  String? toDayMonth(String at) {
    return '${toSimpleString(format: 'dd')} $at ${toSimpleString(format: 'MMMM').capitalize()}';
  }

  String? toDateString({String format = usDateFormat}) =>
      dateToString(this, format: format);
  String? toStringDateHour() => dateToStringDateHour(this);
  String? toExtendedString() => dateToExtendedString(this);

  DateTime get dateOnly => DateTime(year, month, day);

  String get monthName => dateToString(this, format: 'MMMM') ?? '';
  String get shortMonthName => dateToString(this, format: 'MMM') ?? '';

  String getRelativeDate(
      {String today = 'Hoje', String yesterdayLabel = 'Ontem'}) {
    final now = DateTime.now();
    final paymentDay = dateOnly;
    final today = now.dateOnly;
    final yesterday = now.subtract(const Duration(days: 1)).dateOnly;

    if (paymentDay == today) {
      return '$today $hour:${minute.toString().padLeft(2, '0')}';
    } else if (paymentDay == yesterday) {
      return yesterdayLabel;
    } else {
      return dateToString(this, format: 'dd MMMM') ?? '';
    }
  }
}
