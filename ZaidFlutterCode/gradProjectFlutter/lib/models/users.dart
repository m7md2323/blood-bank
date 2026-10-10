class Users {
  final String Fname;
  final String Lname;
  final double latitude;
  final double longitude;
  final String id;

  Users({
    required this.Fname,
    required this.Lname,
    required this.latitude,
    required this.longitude,
    required this.id,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      Fname: json['Fname'] as String,
      Lname: json['Lname'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      id: json['id'].toString(),
    );
  }
}