import 'package:flutter/material.dart';
import 'package:fuellevel_monitoring/config/asset_config.dart';
import 'package:fuellevel_monitoring/config/color.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
    // .whenComplete(() => Navigator.pushNamed(context, '/pilihan'));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;
    return Scaffold(
        body: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Opacity(
                  opacity: _animation.value,
                  child: Stack(
                    children: [
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
                        padding: const EdgeInsets.only(top: 260.0, left: 130),
                        child: Image.asset(
                          AppAsset.icon,
                          width: 131,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 350.0, top: 50),
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/info'),
                          child: Image.asset(AppAsset.button1, width: 60),
                        ),
                      ),
                      Center(
                          child: Text(
                        'FUEL LEVEL \n MONITORING',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )),
                      Padding(
                        padding: const EdgeInsets.only(top: 700.0, left: 100),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/monitor1');
                          },
                          child: Text(
                            "ENTER",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all<Size>(
                                  const Size(200, 70)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  AppColor.bg)),
                        ),
                      )
                    ],
                  ));
            }));
  }
}
