import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:blood_bank/shared/styles/components.dart';
import 'package:blood_bank/shared/styles/responsive_methods.dart';

// Import the file containing your Users model.
import 'package:blood_bank/models/users.dart';

class DonorProximityMap extends StatelessWidget {
  final List<Users> donors;
  final MapController mapController;

  const DonorProximityMap({
    super.key,
    required this.donors,
    required this.mapController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.resHeight(0.45),
      width: context.resWidth(0.9),
      child: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: LatLng(31.9522, 35.9154),
              initialZoom: 10.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.blood_bank',
              ),
              MarkerLayer(
                markers: donors.map((donor) {
                  return Marker(
                    point: LatLng(donor.latitude, donor.longitude),
                    width: context.resWidth(0.02),
                    height: context.resHeight(0.04),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          DefaultCard(
            color: Colors.green,
            child: Text(
              'Live view updates in 10 sec',
              style: TextStyle(
                fontSize: context.resWidth(0.03),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
