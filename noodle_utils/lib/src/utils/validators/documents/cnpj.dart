class CNPJ {
  // Formatar número de CNPJ
  static String? format(String? cnpj) {
    if (cnpj == null) return null;

    // Obter somente os números do CNPJ
    final numbers = cnpj.replaceAll(RegExp(r'[^0-9]'), '');

    // Testar se o CNPJ possui 14 dígitos
    if (numbers.length != 14) return cnpj;

    // Retornar CPF formatado
    return '${numbers.substring(0, 2)}.${numbers.substring(2, 5)}.${numbers.substring(5, 8)}/${numbers.substring(8, 12)}-${numbers.substring(12)}';
  }

  static String? maskedPix(String? cnpj) {
    if (cnpj == null) return null;

    // Obter somente os números do CNPJ
    final numbers = cnpj.replaceAll(RegExp(r'[^0-9]'), '');

    // Testar se o CNPJ possui 14 dígitos
    if (numbers.length != 14) return cnpj;

    // Retornar CPF formatado
    return '**.${numbers.substring(2, 5)}.${numbers.substring(5, 8)}/${numbers.substring(8, 12)}-**';
  }

  // Validar número de CNPJ
  static bool isValid(String? cnpj) {
    if (cnpj == null) return false;

    // Obter somente os números do CNPJ
    final numbers = cnpj.replaceAll(RegExp(r'[^0-9]'), '');

    // Testar se o CNPJ possui 14 dígitos
    if (numbers.length != 14) return false;

    // Testar se todos os dígitos do CNPJ são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(numbers)) return false;

    // Dividir dígitos
    final List<int> digits =
        numbers.split('').map((String d) => int.parse(d)).toList();

    // Calcular o primeiro dígito verificador
    var calcDv1 = 0;
    var j = 0;
    for (var i in Iterable<int>.generate(12, (i) => i < 4 ? 5 - i : 13 - i)) {
      calcDv1 += digits[j++] * i;
    }
    calcDv1 %= 11;
    final dv1 = calcDv1 < 2 ? 0 : 11 - calcDv1;

    // Testar o primeiro dígito verificado
    if (digits[12] != dv1) return false;

    // Calcular o segundo dígito verificador
    var calcDv2 = 0;
    j = 0;
    for (var i in Iterable<int>.generate(13, (i) => i < 5 ? 6 - i : 14 - i)) {
      calcDv2 += digits[j++] * i;
    }
    calcDv2 %= 11;
    final dv2 = calcDv2 < 2 ? 0 : 11 - calcDv2;

    // Testar o segundo dígito verificador
    if (digits[13] != dv2) return false;

    return true;
  }
}
