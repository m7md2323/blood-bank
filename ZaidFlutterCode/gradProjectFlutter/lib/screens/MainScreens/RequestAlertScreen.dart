import 'package:blood_bank/shared/styles/components.dart';
import 'package:blood_bank/shared/styles/constants.dart';
import 'package:blood_bank/shared/styles/responsive_methods.dart';
import 'package:flutter/material.dart';

class RequestAlertScreen extends StatefulWidget {
  const RequestAlertScreen({super.key});

  @override
  State<RequestAlertScreen> createState() => _RequestAlertScreenState();
}

class _RequestAlertScreenState extends State<RequestAlertScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text("Request Alert", style: TextStyle(color: Colors.white)),
        leading: Icon(Icons.arrow_back, color: Colors.white),
        centerTitle: true,
      ),
      body: DefaultCard(
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
                    borderRadius: BorderRadius.circular(context.resWidth(0.03)),
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
            //EDIT NEEDED: Add a button to navigate to the map screen / add a map view to show the location of the donation center and the donors who have responded to the request.
            //EDIT NEEDED: Add a label to tell uts a live view
            //EDIT NEEDED: Add a accept request button to accept the request and navigate to the map screen to show the location of the donation center and the donors who have responded to the request.
            //EDIT NEEDED: Add a reject request button to reject the request and navigate back to the home screen.
            //EDIT NEEDED: add firebase messaging to send a notification to the donors who have responded to the request when the request is accepted or rejected.
            //EDIT NEEDED: force the user to the request alert screen when a new request is received and the user is not on the request alert screen.
          ],
        ),
      ),
    );
  }
}
