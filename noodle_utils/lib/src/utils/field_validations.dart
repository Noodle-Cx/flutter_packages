import 'package:noodle_utils/noodle_utils.dart';

class FieldValidations {
  FieldValidations._();

  static Future<bool> validateFullName(String name) async {
    return name.trim().length > 4 &&
        name.trim().contains(' ') &&
        !name.trim().contains('  ');
  }

  static Future<bool> validatePhone(String phone) async {
    return phone.isValidPhone();
  }

  static Future<bool> validateDate(String birthdate) async {
    return birthdate.isValidDate(pastDate: true);
  }

  static Future<bool> validateName(String name) async {
    return name.isNotEmpty;
  }

  static Future<bool> validateEmail(String email) async {
    return email.isValidEmail();
  }

  static Future<bool> validateCpf(String cpf) async {
    return cpf.isValidCpf();
  }

  static Future<bool> validateCnpj(String cnpj) async {
    return cnpj.isValidCnpj();
  }

  static Future<bool> validateCpfCnpj(String cnpj) async {
    return cnpj.isValidCpfOrCnpj();
  }

  static Future<bool> validateCep(String cep) async {
    return cep.isValidCEP();
  }

  static Future<bool> validateAmount(String value,
      {double? minValue, double? maxValue}) async {
    bool valid = true;

    if (maxValue != null) {
      valid = valid && value.toDouble() <= maxValue;
    }

    if (minValue != null) {
      valid = valid && value.toDouble() >= minValue;
    }

    return valid && value.toDouble() > 0;
  }

  static Future<bool> validateBankAgency(String agency) async {
    return agency.length == 4 || agency.length == 5;
  }

  static Future<bool> validateBankAccount(String account) async {
    return account.length <= 11;
  }
}
