import 'package:flutter/material.dart';
import 'package:tsdoha/theme/app_colors.dart';

class TopRedSection extends StatelessWidget {
  final Size? size;

  const TopRedSection({super.key, this.size});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: Container(
        color: primarycolor,
        height: 350,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 100,
              child: Column(
                children: [
                  SizedBox(
                    height: 156,
                    width: 156,
                    child: Image.asset('assets/imgs/tsdIcon.png'),
                  ),
                  Column(
                    children: [
                      Text(
                        'Tunisian School Doha',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontFamily: 'Bahij',
                        ),
                      ),
                      Text(
                        'المدرسة التونسية بالدوحة',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontFamily: 'Bahij',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
