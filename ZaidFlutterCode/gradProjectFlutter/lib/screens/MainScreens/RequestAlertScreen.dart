import 'package:blood_bank/models/users.dart';
import 'package:blood_bank/shared/network/AuthService.dart';
import 'package:blood_bank/shared/styles/components.dart';
import 'package:blood_bank/shared/styles/constants.dart';
import 'package:blood_bank/shared/styles/responsive_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RequestAlertScreen extends StatefulWidget {
  const RequestAlertScreen({super.key});

  @override
  State<RequestAlertScreen> createState() => _RequestAlertScreenState();
}

class _RequestAlertScreenState extends State<RequestAlertScreen> {
  MapController mapController = MapController();

  late final Stream<List<Users>> donorsLocation;

  @override
  void initState() {
    super.initState();
    donorsLocation = fetchUsersPeriodically();
  }

  Stream<List<Users>> fetchUsersPeriodically() async* {
    while (true) {
      try {
        yield await fetchUsers();
      } catch (e) {
        debugPrint('Failed to fetch donor locations: $e');
      }

      await Future.delayed(const Duration(seconds: 5));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text("Request Alert", style: TextStyle(color: Colors.white)),
        leading: Icon(Icons.arrow_back, color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: DefaultCard(
          color: mainColor,
          padding: EdgeInsets.all(context.resWidth(0.03)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(context.resWidth(0.01)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        context.resWidth(0.03),
                      ),
                    ),
                    child: Text(
                      "URGENT:",
                      style: TextStyle(
                        background: Paint()..color = Colors.white,
                        color: mainColor,
                        fontSize: context.resWidth(0.08),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Spacer(),
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: context.resWidth(0.08),
                  ),
                ],
              ),
              SizedBox(height: context.resHeight(0.04)),
              Text(
                "A patient in need of X blood units of type Y in [Hospital Name]",
                style: TextStyle(
                  background: Paint()..color = mainColor,
                  color: Colors.white,
                  fontSize: context.resWidth(0.05),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.resHeight(0.02)),
              Text(
                "Broadcasted to all donors in the [distance] km radius.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: context.resWidth(0.03),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: const Column(
                        children: [
                          Text(
                            '#of responders:',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          Text(
                            '[# of responders]',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(width: 1, height: 60, color: Colors.grey),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: const Column(
                        children: [
                          Text(
                            'donors arrived at donation center:',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          Text(
                            '[# of donors]',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(width: 1, height: 60, color: Colors.grey),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: const Column(
                        children: [
                          Text(
                            'fit donors:',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          Text(
                            '[# of donors]',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              //EDIT NEEDED: Add a accept request button to accept the request and navigate to the map screen to show the location of the donation center and the donors who have responded to the request.
              //EDIT NEEDED: Add a reject request button to reject the request and navigate back to the home screen.
              //EDIT NEEDED: add firebase messaging to send a notification to the donors who have responded to the request when the request is accepted or rejected.
              //EDIT NEEDED: force the user to the request alert screen when a new request is received and the user is not on the request alert screen.
              Container(
                padding: EdgeInsets.fromLTRB(
                  context.resWidth(0.05),
                  context.resHeight(0.05),
                  0,
                  context.resHeight(0.05),
                ),
                child: StreamBuilder(
                  stream: donorsLocation,
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.hasError) {
                      return Text("error: $asyncSnapshot.error");
                    }
                    if (asyncSnapshot.connectionState ==
                            ConnectionState.waiting &&
                        !asyncSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final donors = asyncSnapshot.data!;
                    return SizedBox(
                      height: context.resHeight(0.45),
                      width: context.resWidth(0.9),
                      child: Stack(
                        children: [
                          FlutterMap(
                            mapController: mapController,
                            options: MapOptions(
                              initialCenter: LatLng(31.9522, 35.9154),
                              initialZoom: 11.0,
                              onTap:
                                  null, //EDIT: Add your onTap callback here if needed
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                subdomains: const ['a', 'b', 'c'],
                                userAgentPackageName: 'com.example.blood_bank',
                              ),
                              MarkerLayer(
                                markers: donors.map((donor) {
                                  return Marker(
                                    point: LatLng(
                                      donor.latitude,
                                      donor.longitude,
                                    ),
                                    width: 40,
                                    height: 40,
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
                              "Live view updates in 10 sec",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add, color: Colors.white),
        backgroundColor: mainColor,
        onPressed: () {
          debugPrint("respond yes or no tab");
        },
        label: Text(
          "respond to request",
          style: TextStyle(
            fontSize: context.resWidth(0.04),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
