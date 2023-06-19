class Dollar {
  final double value;

  Dollar(
    this.value,
  );

  Map<String, dynamic> toJson() => {
        'value': value,
      };
}
