import 'dart:math';

class FinanceUtils {
  FinanceUtils._();

  ///Calcula o pagamento periódico de um investimento anual,
  ///com base em pagamentos periódicos e constantes
  ///e em uma taxa de juros constante.
  static double calcPmt({
    required double amount,
    required double fee,
    required int period,
  }) {
    if (fee == 0) {
      return amount / period;
    }
    final fv = amount * pow((1 + (fee / 100)), period);
    final pmt = (fv * (fee / 100)) / (pow((1 + (fee / 100)), period) - 1);
    return pmt;
  }

  ///Calculo de juros compostos simples
  static double compoundInterest({
    required double amount,
    required double fee,
    required int period,
  }) {
    return amount * pow((1 + (fee / 100)), period);
  }

  ///Calculo de valor final de um financiamento com possibilidade de carencia
  static double totalFinancingValue({
    required double amount,
    required double fee,
    required int period,
    int lack = 0,
  }) {
    final valueWithLack = compoundInterest(
      amount: amount,
      fee: fee,
      period: lack,
    );
    return calcPmt(amount: valueWithLack, period: period, fee: fee) * period;
  }
}
