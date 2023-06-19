import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tsdoha/model/time_table_model.dart';
import 'package:tsdoha/theme/app_colors.dart';

class TimeTableEntry extends StatelessWidget {
  final TimeTable? timetableEntry;
  const TimeTableEntry(this.timetableEntry, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.circle,
                color: primarycolor,
              ),
              const SizedBox(width: 10),
              Text(
                '${timetableEntry!.startTime ?? ''} - ${timetableEntry!.endTime ?? ''}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                timetableEntry!.day ?? '',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                timetableEntry!.teacher ?? '',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              Text(
                timetableEntry!.subject ?? '',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
