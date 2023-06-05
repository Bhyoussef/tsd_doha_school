import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRange extends StatelessWidget {
  const DateRange({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final saturday = monday.add(const Duration(days: 5));
    return Stack(
      children: [
        Container(
          height: 150,
          decoration: const BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.center,
              matchTextDirection: true,
              fit: BoxFit.cover,
              image: AssetImage("assets/imgs/bgTime.png"),
            ),
          ),
        ),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 190, 17, 74).withOpacity(0.5),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('dd-MM-yyyy').format(monday),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'To',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('dd-MM-yyyy').format(saturday),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
