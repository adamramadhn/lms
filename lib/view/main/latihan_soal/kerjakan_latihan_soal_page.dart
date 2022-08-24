import 'package:flutter/material.dart';
import 'package:lms/models/kerjakan_soal_list.dart';
import 'package:lms/models/network_response.dart';
import 'package:lms/repository/latihan_soal_api.dart';

class KerjakanLatihanSoalPage extends StatefulWidget {
  const KerjakanLatihanSoalPage({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<KerjakanLatihanSoalPage> createState() =>
      _KerjakanLatihanSoalPageState();
}

class _KerjakanLatihanSoalPageState extends State<KerjakanLatihanSoalPage> {
  KerjakanSoalList? soalList;
  getQuestion() async {
    final result = await LatihanSoalApi().postQuestionList(widget.id);
    if (result.status == Status.success) {
      soalList = KerjakanSoalList.fromJson(result.data!);
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Latihan Soal"),
      ),
      //tombol submit / selanjutnya
      bottomNavigationBar: Container(),
      body: soalList == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                //Tab Bar no Soal
                Container(),
                //Tab Bar View Soal dan Pilihan Jawaban
                Expanded(
                  child: Container(),
                ),
              ],
            ),
    );
  }
}
