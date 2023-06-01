// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'dart:io' as io;
import 'package:absensi/helper/exception_handler.dart';
import 'package:absensi/pages/connection.dart';
import 'package:absensi/pages/data_pegawai_page.dart';
import 'package:absensi/pages/login_page.dart';
import 'package:absensi/widget/absensi_button.dart';
import 'package:absensi/widget/loading_presensi.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart';
import 'package:absensi/model/profile_model.dart';
import 'package:absensi/widget/absensi_shimmer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int? responseUpdateAva;
  XFile? _profile;
  final picker = ImagePicker();
  CroppedFile? _croppedFile;

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      getImage(ImageSource.gallery, context);
                      Navigator.pop(context);
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    getImage(ImageSource.camera, context);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  Future getImage(ImageSource source, BuildContext context) async {
    final pickedFile = await picker.pickImage(
      source: source,
      maxHeight: 800,
      maxWidth: 800,
      imageQuality: 100,
    );

    if (pickedFile != null) {
      setState(() {
        _profile = XFile(pickedFile.path);
      });
      _cropImage(context);
    }
    if (pickedFile == null) return;
  }

  Future<void> _cropImage(BuildContext context) async {
    if (_profile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _profile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarWidgetColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      if (croppedFile != null) {
        pleaseWait(context);
        setState(() {
          _croppedFile = croppedFile;
        });
        uploadImage(context);
      }
      if (croppedFile == null) return;
    }
  }

  Future<void> uploadImage(BuildContext context) async {
    String fileName = basename(_croppedFile!.path);
    Reference ref =
        FirebaseStorage.instance.ref().child('profile_picture/$fileName');
    final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': fileName});
    UploadTask uploadTask = ref.putFile(io.File(_croppedFile!.path), metadata);
    await Future.value(uploadTask);
    Future.value(uploadTask)
        .then((value) => {print("Upload file path ${value.ref.fullPath}")})
        .onError((error, stackTrace) =>
            {print("Upload file path error ${error.toString()} ")});

    await uploadTask.whenComplete(() async {
      var urlprofile = await uploadTask.snapshot.ref.getDownloadURL();
      var result = urlprofile.toString();
      await updateAva(context: context, ava: result);
      if (responseUpdateAva == 200) {
        Navigator.pop(context);
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            message: 'Berhasil',
          ),
        );
        setState(() {});
      } else {
        Navigator.pop(context);
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: 'Terjadi Kesalahan',
          ),
        );
      }
    });
  }

  Future<void> updateAva(
      {required BuildContext context, required String ava}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? baseUrl = prefs.getString('server');
      int? id = prefs.getInt('idPegawai');
      var msg = jsonEncode({"id_user": id, "ava": ava});
      var response = await http.post(Uri.parse('$baseUrl/updateava'),
          headers: {
            'X-API-Key': "12345678",
            'Accept': "application/json",
          },
          body: msg);
      print(response.body);
      responseUpdateAva = response.statusCode;
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

  void exit(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black54,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light));
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Info penting!',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'Akun akan dihapus dari perangkat ini. Kamu bisa masuk lagi dengan menggunakan email dan password.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AbsensiButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: const Color(0xFF4285F4),
                          textColor: Colors.white,
                          paddingVertical: 10,
                          text: const Text(
                            'Batal',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool('isLoggedIn', false);
                            Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Text(
                            'Keluar',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.red),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ).then((value) => SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 27, right: 27),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Profile",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 13, bottom: 13, left: 21, right: 21),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0x26000000)),
                ),
                child: FutureBuilder(
                    future: ProfileRepository.getProfile(context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Row(
                          children: [
                            circleShimmer(height: 70, width: 70),
                            const SizedBox(
                              width: 25,
                            ),
                            Column(
                              children: [
                                shimmer(
                                  height: 20,
                                  width:
                                      MediaQuery.of(context).size.width - 193,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                shimmer(
                                  height: 15,
                                  width:
                                      MediaQuery.of(context).size.width - 193,
                                ),
                              ],
                            )
                          ],
                        );
                      } else if (snapshot.hasData) {
                        ProfileModel profile = snapshot.data!;
                        return Row(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage: NetworkImage(
                                    profile.data.avatar == '-'
                                        ? 'https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/profile_picture%2Fimage_profile.png?alt=media&token=1a3f9725-8601-4c3c-a14d-cc1a222980d9'
                                        : profile.data.avatar,
                                  ),
                                ),
                                Positioned(
                                  bottom: -15,
                                  left: 15,
                                  child: RawMaterialButton(
                                    onPressed: () async {
                                      SystemChrome.setSystemUIOverlayStyle(
                                          const SystemUiOverlayStyle(
                                              statusBarColor:
                                                  Colors.transparent,
                                              systemNavigationBarColor:
                                                  Colors.white,
                                              statusBarIconBrightness:
                                                  Brightness.light));
                                      _showPicker(context);
                                    },
                                    elevation: 0.0,
                                    fillColor: const Color(0xFFF5F6F9),
                                    shape: const CircleBorder(),
                                    child: const Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    profile.data.nama,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    profile.data.email,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 14,
                                        color: Color(0xff757575)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox();
                      }
                    }),
              ),
              const SizedBox(
                height: 31,
              ),
              const Text(
                "Akun & Keamanan",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 23,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const DataPegawaiPage()));
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/document2.svg',
                          height: 26,
                          width: 26,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          "Data Pegawai",
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 15,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ],
                    ),
                    const Divider(
                      color: Color(0xffE3E3FE),
                      height: 20,
                      thickness: 1,
                      indent: 44,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              InkWell(
                onTap: () {
                  exit(context);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: SvgPicture.asset(
                            'assets/svg/upload.svg',
                            height: 26,
                            width: 26,
                          ),
                        ),
                        const SizedBox(
                          width: 21,
                        ),
                        const Text(
                          "Keluar",
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xffE03A45)),
                        )
                      ],
                    ),
                    const Divider(
                      color: Color(0xffE3E3FE),
                      height: 18,
                      thickness: 1,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // void onPress(BuildContext context) async {
  //   pleaseWait(context);
  //   XFile? file = await getImage(context);

  //   File resultFile = File(file!.path);
  //   String linkProfile = await uploadImage(resultFile);
  //   print('link foto profil : $linkProfile');
  //   await updateAva(context: context, ava: linkProfile);
  //   if (responseUpdateAva == 200) {
  //     Navigator.pop(context);
  //     showTopSnackBar(
  //       Overlay.of(context),
  //       CustomSnackBar.success(
  //         message: 'Berhasil',
  //       ),
  //     );
  //     setState(() {});
  //   } else {
  //     Navigator.pop(context);
  //     showTopSnackBar(
  //       Overlay.of(context),
  //       CustomSnackBar.error(
  //         message: 'Terjadi Kesalahan',
  //       ),
  //     );
  //   }
  // }
}
