class Visit {
  final String id;
  final DateTime visitDate;
  final String visitType;
  final String? visitLocation; // Optional field for visit location
  final String? visitStatus;
  final num? units;

  Visit({
    required this.id,
    required this.visitDate,
    required this.visitType,
    required this.visitLocation,
    required this.visitStatus,
    this.units,
  });
  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      visitDate: json['date'],
      visitType: json['visitType'],
      id: json['id'],
      visitLocation: json['visitLocation'],
      visitStatus: json['visitStatus'],
      units: json['units'] as num?,
    );
  }
}
