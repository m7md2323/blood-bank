import 'package:blood_bank/shared/network/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:blood_bank/models/banks_detail.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Location? currentLocation = Location();
  MapController mapController = MapController();
  Future<List<BanksDetails>> jordanBanks = fetchBanks();
  bool isLoading = true;
  final PopupController popupLayerController = PopupController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: FutureBuilder(
        future: jordanBanks,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (asyncSnapshot.hasError) {
            return Center(child: Text('Error: ${asyncSnapshot.error}'));
          } else if (!asyncSnapshot.hasData) {
            return FlutterMap(
              mapController: mapController,
              options: const MapOptions(
                initialZoom: 11,
                initialCenter: LatLng(31.9522, 35.9154),
                onTap: null, //EDIT: Add your onTap callback here if needed
              ),

              children: [
                Column(
                  children: [Text("Banks in Jordan${jordanBanks.toString()}")],
                ),
              ],
            );
          } else if (asyncSnapshot.data!.isEmpty) {
            return Text("No Banks Found");
          } else {
            throw UnimplementedError();
          }
        },
      ),
    );
  }
}

/*class BanksDetail {
  final String name;
  final double latitude;
  final double longitude;
  final String workingHours;
  final String description;
 */
