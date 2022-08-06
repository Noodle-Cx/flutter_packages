import 'package:flutter/material.dart';

class NoodleTextController extends TextEditingController {
  NoodleTextController({
    String? text,
    required this.mask,
    Map<String, RegExp>? translator,
  })  : this.translator =
            translator ?? NoodleTextController.getDefaultTranslator(),
        super(text: text) {
    this.addListener(() {
      var previous = this._lastUpdatedText;
      if (this.beforeChange(previous, this.text)) {
        this.updateText(this.text);
        this.afterChange(previous, this.text);
      } else {
        this.updateText(this._lastUpdatedText);
      }
    });
    this.updateText(this.text);
  }

  NoodleTextController.text({String? text}) : this(mask: TEXT, text: text);
  NoodleTextController.phone({String? text})
      : this(mask: PHONE_MASK, text: text);
  NoodleTextController.cpf({String? text}) : this(mask: CPF_MASK, text: text);
  NoodleTextController.cnpj({String? text}) : this(mask: CNPJ_MASK, text: text);
  NoodleTextController.document({String? text})
      : this(mask: DOCUMENT_MASK, text: text);
  NoodleTextController.cep({String? text}) : this(mask: CEP, text: text);
  NoodleTextController.date({String? text}) : this(mask: DATE, text: text);
  NoodleTextController.cnae({String? text}) : this(mask: CNAE, text: text);
  NoodleTextController.password({String? text})
      : this(mask: PASSWORD, text: text);
  NoodleTextController.invite({String? text}) : this(mask: INVITE, text: text);

  static const HOME_PHONE_MASK = '(00) 0000-0000';
  static const CELLPHONE_MASK = '(00) 00000-0000';
  static const CPF_MASK = '000.000.000-00';
  static const CNPJ_MASK = '00.000.000/0000-00';
  static const DOCUMENT_MASK = 'DOCUMENT_MASK';
  static const PHONE_MASK = 'PHONE_MASK';
  static const CEP = '00000-000';
  static const DATE = '00/00/0000';
  static const CNAE = '0000-0/00';
  static const PASSWORD = '000000';
  static const INVITE = '@@@@@@@';
  static const TEXT = '';

  String? mask;
  Map<String, RegExp> translator;
  Function afterChange = (String previous, String next) {};
  Function beforeChange = (String previous, String next) {
    return true;
  };

  String _lastUpdatedText = '';

  void updateText(String? text) {
    if (text != null) {
      if (mask == DOCUMENT_MASK) {
        if (text.length <= 14) {
          this.text = _applyMask(CPF_MASK, text);
        } else {
          this.text = _applyMask(CNPJ_MASK, text);
        }
      } else if (mask == PHONE_MASK) {
        if (text.length <= 14) {
          this.text = _applyMask(HOME_PHONE_MASK, text);
        } else {
          this.text = _applyMask(CELLPHONE_MASK, text);
        }
      } else {
        this.text = _applyMask(mask, text);
      }
    } else {
      this.text = '';
    }
    this._lastUpdatedText = this.text;
    moveCursorToEnd();
  }

  void updateMask(String mask) {
    this.mask = mask;
    this.updateText(this.text);
  }

  void moveCursorToEnd() {
    var text = this._lastUpdatedText;
    this.selection =
        TextSelection.fromPosition(TextPosition(offset: (text).length));
  }

  @override
  set text(String newText) {
    if (super.text != newText) {
      super.text = newText;
    }
  }

  static Map<String, RegExp> getDefaultTranslator() {
    return {
      'A': RegExp(r'[A-Za-z]'),
      '0': RegExp(r'[0-9]'),
      '@': RegExp(r'[A-Za-z0-9]'),
      '*': RegExp(r'.*')
    };
  }

  String _applyMask(String? mask, String value) {
    if (mask == null || mask == TEXT) {
      return value;
    }

    String result = '';

    var maskCharIndex = 0;
    var valueCharIndex = 0;

    while (true) {
      // if mask is ended, break.
      if (maskCharIndex == mask.length) {
        break;
      }

      // if value is ended, break.
      if (valueCharIndex == value.length) {
        break;
      }

      var maskChar = mask[maskCharIndex];
      var valueChar = value[valueCharIndex];

      // value equals mask, just set
      if (maskChar == valueChar) {
        result += maskChar;
        valueCharIndex += 1;
        maskCharIndex += 1;
        continue;
      }

      // apply translator if match
      if (this.translator.containsKey(maskChar)) {
        if (this.translator[maskChar]!.hasMatch(valueChar)) {
          result += valueChar;
          maskCharIndex += 1;
        }

        valueCharIndex += 1;
        continue;
      }

      // not masked value, fixed char on mask
      result += maskChar;
      maskCharIndex += 1;
      continue;
    }

    return result;
  }
}

/// Mask for monetary values.
class MoneyMaskedTextController extends TextEditingController {
  MoneyMaskedTextController(
      {double initialValue = 0.0,
      this.decimalSeparator = ',',
      this.thousandSeparator = '.',
      this.rightSymbol = '',
      this.leftSymbol = '',
      this.precision = 2}) {
    _validateConfig();

    addListener(() {
      updateValue(numberValue);
      afterChange(text, numberValue);
    });

    updateValue(initialValue);
  }

  final String decimalSeparator;
  final String thousandSeparator;
  final String rightSymbol;
  final String leftSymbol;
  final int precision;

  Function afterChange = (String maskedValue, double rawValue) {};

  double _lastValue = 0.0;

  void updateValue(double value) {
    double valueToUse = value;

    if (value.toStringAsFixed(0).length > 12) {
      valueToUse = _lastValue;
    } else {
      _lastValue = value;
    }

    String masked = this._applyMask(valueToUse);

    if (rightSymbol.length > 0) {
      masked += rightSymbol;
    }

    if (leftSymbol.length > 0) {
      masked = leftSymbol + masked;
    }

    if (masked != this.text) {
      this.text = masked;

      var cursorPosition = super.text.length - this.rightSymbol.length;
      this.selection =
          TextSelection.fromPosition(TextPosition(offset: cursorPosition));
    }
  }

  double get numberValue {
    try {
      final List<String> parts =
          _getOnlyNumbers(text).split('').toList(growable: true);

      parts.insert(parts.length - precision, '.');

      return double.parse(parts.join());
    } catch (e) {
      return 0.0;
    }
  }

  void _validateConfig() {
    final bool rightSymbolHasNumbers = _getOnlyNumbers(rightSymbol).isNotEmpty;

    if (rightSymbolHasNumbers) {
      throw ArgumentError('rightSymbol must not have numbers.');
    }
  }

  String _getOnlyNumbers(String text) {
    String cleanedText = text;

    final onlyNumbersRegex = RegExp(r'[^\d]');

    cleanedText = cleanedText.replaceAll(onlyNumbersRegex, '');

    return cleanedText;
  }

  String _applyMask(double value) {
    final List<String> textRepresentation = value
        .toStringAsFixed(precision)
        .replaceAll('.', '')
        .split('')
        .reversed
        .toList(growable: true);

    textRepresentation.insert(precision, decimalSeparator);

    for (var i = precision + 4; true; i = i + 4) {
      if (textRepresentation.length > i) {
        textRepresentation.insert(i, thousandSeparator);
      } else {
        break;
      }
    }

    return textRepresentation.reversed.join('');
  }
}
