import 'package:flutter/material.dart';

class AbsensiJam extends StatelessWidget {
  final String title;
  final String jam;
  final Color color;

  const AbsensiJam({super.key, required this.title, required this.jam, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
                            width: MediaQuery.of(context).size.width / 2 - 32,
                            padding: EdgeInsets.only(
                              left: 15,
                              bottom: 10,
                              top: 10,
                            ),
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(245, 245, 245, 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    color: color,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  jam,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 23,
                                    color: color,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                          );
  }
}