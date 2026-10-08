import 'package:blood_bank/shared/network/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:blood_bank/models/banks_detail.dart';
import 'package:blood_bank/shared/styles/responsive_methods.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Location? currentLocation = Location();
  MapController mapController = MapController();
  SearchController searchController = SearchController();
  Future<List<BanksDetails>> jordanBanks = fetchBanks();
  Future<void> moveToCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled.')),
        );
      }
      return;
    }

    // Check and request permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')),
          );
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permissions are permanently denied.'),
          ),
        );
      }
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    // 2. Use the controller to center the map on the fetched coordinates
    mapController.move(
      LatLng(position.latitude, position.longitude),
      15.0, // Desired zoom level
    );
  }

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
          } //else if (asyncSnapshot.data!.isEmpty) {return Text("No Banks Found"); } EDIT: Add a check for empty data
          else if (asyncSnapshot.hasData) {
            print('Number of banks: ${asyncSnapshot.data?.length}');
            return Stack(
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: const MapOptions(
                    initialZoom:
                        11, //32.551445, 35.851479 for irbid فيش بعد اربد
                    initialCenter: LatLng(31.9522, 35.9154),
                    onTap: null, //EDIT: Add your onTap callback here if needed
                  ),

                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                      userAgentPackageName: 'com.example.blood_bank',
                    ),
                    MarkerLayer(
                      markers: asyncSnapshot.data!.map((bank) {
                        return Marker(
                          point: LatLng(bank.latitude, bank.longitude),
                          width: 80,
                          height: 80,
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => SizedBox(
                                  height: 200,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        //EDIT: Add more details about the bank here
                                        Text('Bank Details'),
                                        Text('Name: ${bank.name}'),
                                        Text(
                                          'Address: ${bank.latitude}, ${bank.longitude}',
                                        ),
                                        Text(
                                          'Working Hours: ${bank.workingHours}',
                                        ),
                                        Text(
                                          'Description: ${bank.description}',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: bank.name == "Bank 1"
                                ? const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                  )
                                : const Icon(
                                    Icons.location_on,
                                    color: Colors.blue,
                                  ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SearchBar(
                  leading: const Icon(Icons.search),
                  trailing: [
                    IconButton(
                      icon: const Icon(Icons.tune),
                      onPressed: () {
                        //EDIT: Implement filter functionality here
                        searchController.clear();
                      },
                    ),
                  ],
                  controller: searchController,
                  smartDashesType: SmartDashesType.enabled,
                  autoFocus: true,
                  contextMenuBuilder: (context, editableTextState) {
                    return AdaptiveTextSelectionToolbar.editableText(
                      editableTextState: editableTextState,
                    );
                  },
                  constraints: BoxConstraints(
                    minHeight: context.resHeight(0.06),
                    minWidth: context.resWidth(0.7),
                    maxWidth: context.resWidth(0.8),
                    maxHeight: context.resHeight(0.1),
                  ),
                  hintText: "Search for banks...",
                  onChanged: (value) {
                    // Implement search functionality here
                  },
                ),

                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: moveToCurrentLocation,
                    child: const Icon(Icons.my_location),
                  ),
                ),
              ],
            );
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
 
 Column(
                      children: [
                        Text(
                          "Banks in Jordan${asyncSnapshot.data![1].name.toString()}",
                        ),
                      ],
                    ),
*/
