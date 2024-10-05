// exchange_setting.dart

class ExchangeSetting {
  String? bybitApiKey;
  String? bybitSecretKey;

  ExchangeSetting({
    required this.bybitApiKey,
    required this.bybitSecretKey,
  });

  ExchangeSetting copyWith({
    String? bybitApiKey,
    String? bybitSecretKey,
  }) {
    return ExchangeSetting(
      bybitApiKey: bybitApiKey ?? this.bybitApiKey,
      bybitSecretKey: bybitSecretKey ?? this.bybitSecretKey,
    );
  }
}
