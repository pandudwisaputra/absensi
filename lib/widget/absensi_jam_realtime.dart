import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class JamRealTime extends StatefulWidget {
  const JamRealTime({super.key});

  @override
  State<JamRealTime> createState() => _JamRealTimeState();
}

class _JamRealTimeState extends State<JamRealTime> {
  String? formattedTime;
  String formattedDate =
      DateFormat("EEEE, d MMMM yyyy", "id_ID").format(DateTime.now());

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss', 'id_ID').format(dateTime);
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    if (mounted) {
      setState(() {
        formattedTime = formattedDateTime;
      });
    }
  }

  @override
  void initState() {
    formattedTime = _formatDateTime(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/svg/calender.svg',
          width: 19,
          height: 19,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          formattedDate,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        SvgPicture.asset(
          'assets/svg/clock.svg',
          width: 19,
          height: 19,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          formattedTime!,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
