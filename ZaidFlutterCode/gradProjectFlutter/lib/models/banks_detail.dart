class BanksDetails {
  final String name;
  final double latitude;
  final double longitude;
  final String workingHours;
  final String description;

  BanksDetails({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.workingHours,
    required this.description,
  });
   factory BanksDetails.fromJson(Map<String, dynamic> json) {
    return BanksDetails(
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      workingHours: json['workingHours'],
      description: json['description'],
    );
  }
}

