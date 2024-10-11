import 'package:flutter/material.dart';

class FuelTankWidget extends StatelessWidget {
  final String tankName;
  final double fuelLevel;
  final VoidCallback onTap;
  final double width;
  final double height;

  const FuelTankWidget({
    Key? key,
    required this.tankName,
    required this.fuelLevel,
    required this.onTap,
    this.width = 100,
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Text(tankName, style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(10, (index) {
                        double lineLevel = 1 - (index / 9);
                        return _buildIndicatorLine(lineLevel);
                      }),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.all(12),
                      height: (height - 24) * fuelLevel,
                      decoration: BoxDecoration(
                        color: _getFuelColor(fuelLevel),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 12 + ((height - 24) * fuelLevel),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${(fuelLevel * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicatorLine(double level) {
    Color lineColor = _getIndicatorColor(level);
    return Container(
      height: 2,
      margin: EdgeInsets.symmetric(horizontal: 12),
      color: lineColor,
    );
  }

  Color _getIndicatorColor(double level) {
    if (level <= 0.2) return Colors.red;
    if (level <= 0.4) return Colors.orange;
    if (level <= 0.6) return Colors.yellow;
    return Colors.green;
  }

  Color _getFuelColor(double level) {
    if (level < 0.2) return Colors.red.withOpacity(0.7);
    if (level < 0.5) return Colors.orange.withOpacity(0.7);
    return Colors.green.withOpacity(0.7);
  }
}
