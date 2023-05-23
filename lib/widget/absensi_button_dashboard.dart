import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'absensi_button.dart';
import 'bottom_sheet_checkin.dart';
import 'bottom_sheet_checkout.dart';

class Buttondashboard extends StatefulWidget {
  const Buttondashboard({super.key});

  @override
  State<Buttondashboard> createState() => _ButtondashboardState();
}

class _ButtondashboardState extends State<Buttondashboard> {
  bool presensiMasuk = false;

  @override
  void initState() {
    super.initState();

    loadlist();
  }

  Future loadlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? result = prefs.getBool('presensiMasuk');
    if (mounted) {
      setState(() {
        presensiMasuk = result!;
      });
    }

    print('Status : $presensiMasuk');
  }

  @override
  Widget build(BuildContext context) {
    if (presensiMasuk == false) {
      return AbsensiButton(
        onPressed: () async {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25),
              ),
            ),
            builder: (BuildContext context) => BottomSheetCheckIn(),
          ).then((value) async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            bool? result = prefs.getBool('presensiMasuk');
            print(result);
            if (mounted) {
              setState(() {
                presensiMasuk = result!;
              });
            }
          });
        },
        text: Text('CHECK IN'),
        color: Color(0xFF00AC47),
        textColor: Colors.white,
      );
    } else {
      return AbsensiButton(
        onPressed: () async {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25),
              ),
            ),
            builder: (BuildContext context) => BottomSheetCheckOut(),
          ).then((value) async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove('presensiMasuk');
            if (mounted) {
              setState(() {});
            }
          });
        },
        text: Text('CHECK OUT'),
        color: Color(0xFFEA4435),
        textColor: Colors.white,
      );
    }
  }
}
