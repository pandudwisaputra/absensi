import 'dart:convert';
import 'dart:io';
import 'package:absensi/helper/exception_handler.dart';
import 'package:absensi/pages/connection.dart';
import 'package:absensi/pages/face_recognition_page.dart';
import 'package:absensi/widget/loading_presensi.dart';
import 'package:path/path.dart';
import 'package:absensi/model/profile_model.dart';
import 'package:absensi/pages/login_page.dart';
import 'package:absensi/pages/ubah_katasandi_page.dart';
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

  static Future<String> uploadImage(File imageFile) async {
    String fileName = basename(imageFile.path);
    Reference ref =
        FirebaseStorage.instance.ref().child('profile_picture/$fileName');
    UploadTask task = ref.putFile(
        imageFile,
        SettableMetadata(
            contentType: 'image/jpeg',
            customMetadata: {'picked-file-path': fileName}));
    TaskSnapshot snapshot = await task;

    return await snapshot.ref.getDownloadURL();
  }

  Future<XFile?> getImage(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      Navigator.pop(context);
    }
    return pickedFile;
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
      await Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => ConnectionPage(
            button: true,
            error: error,
          ),
        ),
      );
    }
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
                            SizedBox(
                              width: 25,
                            ),
                            Column(
                              children: [
                                shimmer(
                                  height: 20,
                                  width:
                                      MediaQuery.of(context).size.width - 193,
                                ),
                                SizedBox(
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
                        ProfileModel _profile = snapshot.data!;
                        return Row(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage: NetworkImage(
                                    _profile.data.avatar == '-'
                                        ? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'
                                        : _profile.data.avatar,
                                  ),
                                ),
                                Positioned(
                                  bottom: -15,
                                  left: 15,
                                  child: RawMaterialButton(
                                    onPressed: () async {
                                      onPress(context);
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
                                    _profile.data.nama,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    _profile.data.email,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
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
                        return SizedBox();
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
                          builder: ((context) => UbahKataSandi())));
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/key.svg',
                          height: 26,
                          width: 26,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          "Ubah Kata Sandi",
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 15,
                          ),
                        ),
                        Spacer(),
                        Icon(
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
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => FaceRecognitionPage()));
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
                          "Ajukan Data Wajah",
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 15,
                          ),
                        ),
                        Spacer(),
                        Icon(
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
                  Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
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

  void onPress(BuildContext context) async {
    PleaseWait(context);
    XFile? file = await getImage(context);

    File resultFile = File(file!.path);
    String linkProfile = await uploadImage(resultFile);
    print('link foto profil : $linkProfile');
    await updateAva(context: context, ava: linkProfile);
    if (responseUpdateAva == 200) {
      Navigator.pop(context);
      showTopSnackBar(
        Overlay.of(context)!,
        CustomSnackBar.success(
          message: 'Berhasil',
        ),
      );
      setState(() {});
    } else {
      Navigator.pop(context);
      showTopSnackBar(
        Overlay.of(context)!,
        CustomSnackBar.error(
          message: 'Terjadi Kesalahan',
        ),
      );
    }
  }
}
