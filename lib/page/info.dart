import 'package:flutter/material.dart';
import 'package:fuellevel_monitoring/config/asset_config.dart';
import 'package:fuellevel_monitoring/config/color.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;
    return Scaffold(
        body: Stack(children: [
      Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
            color: AppColor.bg,
            border: Border.all(color: Colors.black, width: 2)),
      ),
      Container(
        height: screenHeight,
        width: screenWidth,
        child: Image.asset(
          AppAsset.bg,
          alignment: Alignment.bottomRight,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 130),
        child: Image.asset(
          AppAsset.icon2,
          width: 131,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 50),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  border: Border.all(color: Colors.black),
                  color: const Color.fromARGB(255, 185, 185, 185),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 30.0, left: 30, bottom: 50),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColor.bg,
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20, top: 40, bottom: 20),
                    child: Text(
                      "FUEL LEVEL MONITORING IS AN APPLICATION MONITORING LEVEL SYSTEM THAT CAPICITY A FUEL TANK WHICH USING SMART TECHNOLOGY BASED ON IoT. THIS APPLICATION COMPLETED WITH A FEATURE THAT CAN SEE A HISTORY OF DAILY USE FUEL, WEEKLY, MONTHLY OR EVEN A YEAR. THE WORKING SYSTEM OF THIS APPLICATION IS USING A READING METHOD OF ULTRASONIC SENSOR AND FOR THE MICROCONTROLLER, WE USE RASPBERRY PI",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Positioned(
        top: 200,
        left: 0,
        right: 0,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.bg,
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15, top: 5, bottom: 5),
              child: Text(
                "FUEL LEVEL MONITORING",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 27),
              ),
            ),
          ),
        ),
      ),
    ]));
  }
}
