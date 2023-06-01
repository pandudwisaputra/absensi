import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClickFoto extends StatefulWidget {
  final String foto;
  final String nama;
  const ClickFoto({super.key, required this.foto, required this.nama});

  @override
  State<ClickFoto> createState() => _ClickFotoState();
}

class _ClickFotoState extends State<ClickFoto> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black,
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
          title: Text(
            widget.nama,
            style: const TextStyle(
              fontFamily: 'Open Sans',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  widget.foto,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
