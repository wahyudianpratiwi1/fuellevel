import 'package:flutter/material.dart';
import 'package:fuellevel_monitoring/config/asset_config.dart';
import 'package:fuellevel_monitoring/config/color.dart';
import 'package:fuellevel_monitoring/widget/fueltank_widget.dart';
import 'package:get/get.dart';

import '../controller/fuel_controller.dart';

class Monitor1 extends StatefulWidget {
  const Monitor1({super.key});

  @override
  State<Monitor1> createState() => _Monitor1State();
}

class _Monitor1State extends State<Monitor1> {
  // double _volumePercentage = 0.0;
  @override
  void initState() {
    super.initState();
    // _listenToVolumeChanges();
  }

  // void _listenToVolumeChanges() {
  //   FirebaseDatabase.instance.ref('tank3/volume').onValue.listen((event) {
  //     if (event.snapshot.value != null) {
  //       setState(() {
  //         _volumePercentage = (event.snapshot.value as num).toDouble() / 100;
  //       });
  //     }
  //   });
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;
    return GetBuilder<FuelController>(builder: (controller) {
      return Scaffold(
          body: Stack(children: [
        Stack(children: [
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
              AppAsset.bg1,
              alignment: Alignment.bottomRight,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Text(
                    'Fuel Level Monitor',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(80.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 0.4,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Obx(() => FuelTankWidget(
                      tankName: 'Tank ${index + 1}',
                      fuelLevel: controller.getFuelLevel(index),
                      onTap: () {
                        Navigator.pushNamed(context, '/tank_detail',
                            arguments: index);
                      },
                      width: 150,
                      height: 300,
                    ));
              },
            ),
          ),
        ])
      ]));
    });
  }
}
