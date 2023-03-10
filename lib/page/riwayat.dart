import 'package:absensi/page/satubulan.dart';
import 'package:absensi/page/satuminggu.dart';
import 'package:absensi/page/semua.dart';
import 'package:flutter/material.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 27, right: 27),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: const Text(
                    'Riwayat Presensi',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 33,
                ),
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                        labelColor: Color(0xff466aff),
                        unselectedLabelColor: Color(0xFF878787),
                        labelPadding: EdgeInsets.only(right: 7),
                        indicatorColor: Colors.transparent,
                        isScrollable: true,
                        tabs: [
                          Tab(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 14),
                              decoration: BoxDecoration(
                                  color: Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "Semua",
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          Tab(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 14),
                              decoration: BoxDecoration(
                                  color: Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "1 Minggu",
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          Tab(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 14),
                              decoration: BoxDecoration(
                                  color: Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "1 Bulan",
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
                Expanded(
                  child: Container(
                      child: TabBarView(
                    children: [Semua(), SatuMinggu(), SatuBulan()],
                  )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
