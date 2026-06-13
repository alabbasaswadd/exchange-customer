class CreateExchangeRequestModel {
  final String fromCurrencyId;
  final String toCurrencyId;
  final double amount;
  final String? notes;

  const CreateExchangeRequestModel({
    required this.fromCurrencyId,
    required this.toCurrencyId,
    required this.amount,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'fromCurrencyId': fromCurrencyId,
    'toCurrencyId': toCurrencyId,
    'amount': amount,
    if (notes != null && notes!.isNotEmpty) 'notes': notes,
  };
}
