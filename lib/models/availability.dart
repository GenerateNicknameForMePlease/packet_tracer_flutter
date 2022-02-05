class Availability {
  final num maxAvailability;
  final num minAvailability;

  const Availability({
    this.maxAvailability,
    this.minAvailability,
  });

  factory Availability.fromJson(Map<String, dynamic> json) {
    print(json);
    return Availability(
      maxAvailability: ((json['max_availability'] as num) * 100).toInt(),
      minAvailability: ((json['min_availability'] as num) * 100).toInt(),
    );
  }
}
