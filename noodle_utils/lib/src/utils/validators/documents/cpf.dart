class CPF {
  // Formatar número de CPF
  static String? format(String? cpf) {
    if (cpf == null) return null;

    // Obter somente os números do CPF
    final numbers = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    // Testar se o CPF possui 11 dígitos
    if (numbers.length != 11) return cpf;

    // Retornar CPF formatado
    return '${numbers.substring(0, 3)}.${numbers.substring(3, 6)}.${numbers.substring(6, 9)}-${numbers.substring(9)}';
  }

  static String? maskedPix(String? cpf) {
    if (cpf == null) return null;

    // Obter somente os números do CPF
    final numbers = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    // Testar se o CPF possui 11 dígitos
    if (numbers.length != 11) return cpf;

    // Retornar CPF formatado
    return '***.${numbers.substring(3, 6)}.${numbers.substring(6, 9)}-**';
  }

  // Validar número de CPF
  static bool isValid(String? cpf) {
    if (cpf == null) return false;

    // Obter somente os números do CPF
    final numbers = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    // Testar se o CPF possui 11 dígitos
    if (numbers.length != 11) return false;

    // Testar se todos os dígitos do CPF são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(numbers)) return false;

    // Dividir dígitos
    final List<int> digits =
        numbers.split('').map((String d) => int.parse(d)).toList();

    // Calcular o primeiro dígito verificador
    var calcDv1 = 0;
    for (var i in Iterable<int>.generate(9, (i) => 10 - i)) {
      calcDv1 += digits[10 - i] * i;
    }
    calcDv1 %= 11;
    final dv1 = calcDv1 < 2 ? 0 : 11 - calcDv1;

    // Testar o primeiro dígito verificado
    if (digits[9] != dv1) return false;

    // Calcular o segundo dígito verificador
    var calcDv2 = 0;
    for (var i in Iterable<int>.generate(10, (i) => 11 - i)) {
      calcDv2 += digits[11 - i] * i;
    }
    calcDv2 %= 11;
    final dv2 = calcDv2 < 2 ? 0 : 11 - calcDv2;

    // Testar o segundo dígito verificador
    if (digits[10] != dv2) return false;

    return true;
  }
}
