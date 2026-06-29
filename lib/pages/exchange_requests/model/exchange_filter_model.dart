class ExchangeFilterModel {
  final List<int> statuses;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final double? minAmount;
  final double? maxAmount;

  const ExchangeFilterModel({
    this.statuses = const [],
    this.dateFrom,
    this.dateTo,
    this.minAmount,
    this.maxAmount,
  });

  bool get isActive =>
      statuses.isNotEmpty ||
      dateFrom != null ||
      dateTo != null ||
      minAmount != null ||
      maxAmount != null;

  int get activeCount {
    var n = 0;
    if (statuses.isNotEmpty) n++;
    if (dateFrom != null || dateTo != null) n++;
    if (minAmount != null || maxAmount != null) n++;
    return n;
  }
}
