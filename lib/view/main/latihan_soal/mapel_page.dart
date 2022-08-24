import 'package:flutter/material.dart';
import 'package:lms/models/mapel_list.dart';
import 'package:lms/view/main/latihan_soal/home_page.dart';
import 'package:lms/view/main/latihan_soal/paket_soal_page.dart';

class MapelPage extends StatelessWidget {
  const MapelPage({Key? key, required this.mapel}) : super(key: key);
  static String route = "mapel_page";
  final MapelList mapel;
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
            final currentMapel = mapel.data![index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PaketSoalPage(id: mapel.data![index].courseId!),
                  ),
                );
              },
              child: MapelWidget(
                  title: currentMapel.courseName!,
                  totalDone: currentMapel.jumlahDone.toString(),
                  totalPacket: currentMapel.jumlahMateri.toString()),
            );
          },
          itemCount: mapel.data!.length,
        ),
      ),
    );
  }
}
