import 'package:flutter/material.dart';

double getResponsiveHeight(BuildContext context, double percentage) {
  return MediaQuery.of(context).size.height * percentage;
}

double getResponsiveWidth(BuildContext context, double percentage) {
  return MediaQuery.of(context).size.width * percentage;
}

const Color mainColor = Color(0xFF8B0000);
const String apiURL = 'https://your-api-url.com/api'; //dummy url
const String donorBackgroundImage = 'assets/images/backgroundDonor.jpg';
const String staffBackgroundImage = 'assets/images/nurseImage.jpg';
const String donorBackgroundImage2 = 'assets/images/backgroundDonor2.jpg';
