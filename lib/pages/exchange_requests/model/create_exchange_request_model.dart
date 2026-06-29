class CreateExchangeRequestModel {
  final String fromCurrencyId;
  final String toCurrencyId;
  final double amount;

  const CreateExchangeRequestModel({
    required this.fromCurrencyId,
    required this.toCurrencyId,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
    'fromCurrencyId': fromCurrencyId,
    'toCurrencyId': toCurrencyId,
    'amount': amount,
  };
}
