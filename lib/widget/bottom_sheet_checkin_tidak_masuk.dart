// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:absensi/helper/exception_handler.dart';
import 'package:absensi/pages/connection.dart';
import 'package:absensi/pages/home/navbar.dart';
import 'package:absensi/widget/loading_presensi.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:absensi/widget/absensi_jam_realtime.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'absensi_button.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';

class BottomSheetCheckInTidakMasuk extends StatefulWidget {
  const BottomSheetCheckInTidakMasuk({Key? key}) : super(key: key);

  @override
  State<BottomSheetCheckInTidakMasuk> createState() =>
      _BottomSheetCheckInTidakMasukState();
}

class _BottomSheetCheckInTidakMasukState
    extends State<BottomSheetCheckInTidakMasuk> {
  final List<String> keteranganItems = [
    'Sakit',
    'Ijin',
    'Keluar Kota',
  ];
  bool isVisible = false;
  bool isPicked = false;
  String? selectedValue;
  PlatformFile? pickedFile;
  int? responsePresensiMasuk;

  final _formKey = GlobalKey<FormState>();

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) return;

    if (mounted) {
      setState(() {
        pickedFile = result.files.first;
        isVisible = true;
        isPicked = false;
      });
    }
  }

  Future uploadFile(File file) async {
    String fileName = basename(file.path);
    Reference ref =
        FirebaseStorage.instance.ref().child('bukti_keterangan/$fileName');
    UploadTask task = ref.putFile(
      file,
      SettableMetadata(
        contentType: 'pdf',
        customMetadata: {'picked-file-path': fileName},
      ),
    );
    TaskSnapshot snapshot = await task;

    return await snapshot.ref.getDownloadURL();
  }

  Future<void> presensiTidakMasuk({
    required BuildContext context,
    required String keterangan,
    required String linkBukti,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? id = prefs.getInt('idPegawai');
      String tanggalPresensi = DateTime.now().millisecondsSinceEpoch.toString();
      var msg = jsonEncode({
        "id_user": id,
        "tanggal_presensi": tanggalPresensi,
        "keterangan_tidak_masuk": keterangan,
        "link_bukti": linkBukti,
      });
      var response = await http.post(
          Uri.parse('http://api2.myfin.id:4500/api/presensitidakmasuk'),
          headers: {
            'X-API-Key': "12345678",
            'Accept': "application/json",
          },
          body: msg);
      responsePresensiMasuk = response.statusCode;
    } catch (e) {
      var error = ExceptionHandlers().getExceptionString(e);
      await Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => ConnectionPage(
            button: true,
            error: error,
          ),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 30),
                  height: 5,
                  width: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFEBEBEB)),
                ),
              ),
              const Text(
                'Keterangan Tidak Masuk',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButtonFormField2(
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF4285F4)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      isExpanded: true,
                      hint: const Text(
                        'Pilih Keterangan Tidak Masuk',
                        style: TextStyle(fontSize: 12),
                      ),
                      items: keteranganItems
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Pilih keterangan';
                        }
                        return null;
                      },
                      onChanged: (value) {},
                      onSaved: (value) {
                        selectedValue = value.toString();
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 60,
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFF4285F4),
                          ),
                        ),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFF4285F4),
                        ),
                        iconSize: 30,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Upload Bukti',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF4285F4))),
                child: AbsensiButton(
                  onPressed: selectFile,
                  text: const Text(
                    'Pilih File',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  color: Colors.white,
                  textColor: const Color(0xFF4285F4),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Visibility(
                visible: isVisible,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/document2.svg',
                      height: 35,
                      width: 35,
                      color: Colors.green,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Text(
                        pickedFile != null ? pickedFile!.name : '',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 30,
                    )
                  ],
                ),
              ),
              Visibility(
                visible: isPicked,
                child: const Text(
                  'Wajib mengupload bukti keterangan tidak masuk',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              const JamRealTime(),
              const SizedBox(
                height: 22,
              ),
              AbsensiButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (pickedFile != null) {
                      pleaseWait(context);
                      File resultFile = File(pickedFile!.path!);
                      String linkFile = await uploadFile(resultFile);

                      await presensiTidakMasuk(
                          context: context,
                          keterangan: selectedValue!,
                          linkBukti: linkFile);
                      if (responsePresensiMasuk == 200) {
                        Navigator.pop(context);
                        showTopSnackBar(
                          Overlay.of(context),
                          const CustomSnackBar.success(
                            message: 'Berhasil Checkin',
                          ),
                        );
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(
                              builder: ((context) => const Navbar())),
                          (route) => false,
                        );
                      } else {
                        showTopSnackBar(
                          Overlay.of(context),
                          const CustomSnackBar.error(
                            message: 'Terjadi Kesalahan',
                          ),
                        );
                      }
                    } else {
                      setState(() {
                        isPicked = true;
                      });
                    }
                  }
                },
                text: const Text('CHECK IN SEKARANG'),
                color: const Color(0xFF00AC47),
                textColor: Colors.white,
              ),
              const SizedBox(
                height: 35,
              )
            ],
          ),
        ],
      ),
    );
  }
}
