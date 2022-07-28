import 'package:flutter/material.dart';
import 'package:lms/view/main/latihan_soal/home_page.dart';

class MapelPage extends StatelessWidget {
  const MapelPage({Key? key}) : super(key: key);
  static String route = "mapel_page";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Mata Pelajaran"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return GestureDetector(onTap: () {}, child: const MapelWidget());
          },
          itemCount: 5,
        ),
      ),
    );
  }
}
