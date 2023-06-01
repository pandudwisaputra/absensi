import 'package:absensi/pages/satubulan.dart';
import 'package:absensi/pages/satuminggu.dart';
import 'package:absensi/pages/semua.dart';
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
                const Text(
                  'Riwayat Presensi',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 33,
                ),
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                        labelColor: const Color(0xff466aff),
                        unselectedLabelColor: const Color(0xFF878787),
                        labelPadding: const EdgeInsets.only(right: 7),
                        indicatorColor: Colors.transparent,
                        isScrollable: true,
                        tabs: [
                          Tab(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 14),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text(
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 14),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text(
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 14),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text(
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
                const Expanded(
                  child: TabBarView(
                    children: [Semua(), SatuMinggu(), SatuBulan()],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
