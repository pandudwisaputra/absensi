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
  bool? presensiMasuk;

  @override
  void initState() {
    super.initState();

    loadlist();
  }

  Future<void> loadlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? result = prefs.getBool('presensiMasuk');
    if (mounted) {
      setState(() {
        presensiMasuk = result!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> showSuccessDialog() async {
      return showDialog(
        context: context,
        builder: (BuildContext context) => SizedBox(
          width: MediaQuery.of(context).size.width - (2 * 30),
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Text(
                    'Pilih Keterangan',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25),
                                  ),
                                ),
                                builder: (BuildContext context) =>
                                    BottomSheetCheckIn(),
                              ).then((value) async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                bool? result = prefs.getBool('presensiMasuk');
                                print(result);
                                if (mounted) {
                                  setState(() {
                                    presensiMasuk = result!;
                                  });
                                }
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Masuk',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Tidak Masuk',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (presensiMasuk == null) {
      return AbsensiButton(
        onPressed: () {
          showSuccessDialog();
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
