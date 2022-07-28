import 'package:flutter/material.dart';
import 'package:lms/constant/r.dart';

class PaketSoalPage extends StatefulWidget {
  const PaketSoalPage({Key? key}) : super(key: key);
  static String route = "paket_soal_page";
  @override
  State<PaketSoalPage> createState() => _PaketSoalPageState();
}

class _PaketSoalPageState extends State<PaketSoalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.grey,
      appBar: AppBar(
        title: const Text(
          "Paket Soal",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih Paket Soal",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: GridView.count(
                mainAxisSpacing: 10,
                crossAxisSpacing: 1,
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                children: const [
                  PaketSoalWidget(),
                  PaketSoalWidget(),
                  PaketSoalWidget(),
                  PaketSoalWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaketSoalWidget extends StatelessWidget {
  const PaketSoalWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13.0),
      margin: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue.withOpacity(0.2),
            ),
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              R.assets.icNote,
              width: 14,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          const Text(
            "Aljabar",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            "0/0 Paket Soal",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 9,
                color: R.colors.greySubtitleHome),
          ),
        ],
      ),
    );
  }
}
