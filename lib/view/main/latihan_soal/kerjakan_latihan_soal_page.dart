import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lms/constant/r.dart';
import 'package:lms/helper/user_email.dart';
import 'package:lms/models/kerjakan_soal_list.dart';
import 'package:lms/models/network_response.dart';
import 'package:lms/repository/latihan_soal_api.dart';
import 'package:lms/view/main/latihan_soal/result_page.dart';

class KerjakanLatihanSoalPage extends StatefulWidget {
  const KerjakanLatihanSoalPage({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<KerjakanLatihanSoalPage> createState() =>
      _KerjakanLatihanSoalPageState();
}

class _KerjakanLatihanSoalPageState extends State<KerjakanLatihanSoalPage>
    with SingleTickerProviderStateMixin {
  KerjakanSoalList? soalList;
  getQuestion() async {
    final result = await LatihanSoalApi().postQuestionList(widget.id);
    if (result.status == Status.success) {
      soalList = KerjakanSoalList.fromJson(result.data!);
      _controller = TabController(length: soalList!.data!.length, vsync: this);
      _controller?.addListener(
        () {
          setState(() {});
        },
      );
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQuestion();
  }

  TabController? _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Latihan Soal"),
      ),
      //tombol submit / selanjutnya
      bottomNavigationBar: _controller == null
          ? const SizedBox(
              height: 0,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: R.colors.primary,
                      fixedSize: const Size(135, 33),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  onPressed: () async {
                    if (_controller!.index == soalList!.data!.length - 1) {
                      final result = await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return const BottomSheetConfirmation();
                        },
                      );
                      // print(result);
                      if (result == true) {
                        List<String> answer = [];
                        List<String> questionId = [];

                        for (var value in soalList!.data!) {
                          questionId.add(value.bankQuestionId!);
                          answer.add(value.studentAnswer!);
                        }
                        final payLoad = {
                          "user_email": UserEmail.getUserEmail(),
                          "exercise_id": widget.id,
                          "bank_question_id": questionId,
                          "student_answer": answer,
                        };
                        final result =
                            await LatihanSoalApi().postStudentAnswer(payLoad);
                        if (result.status == Status.success) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResultPage(
                                  exerciseId: widget.id,
                                ),
                              ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Submit gagal. Silahkan ulangi"),
                            ),
                          );
                        }
                        // print(payLoad);
                      } else {
                        // print("Cancel");
                      }
                    } else {
                      _controller!.animateTo(_controller!.index + 1);
                    }
                  },
                  child: Text(
                    _controller?.index == soalList!.data!.length - 1
                        ? "Kumpulin"
                        : "Selanjutnya",
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
      body: soalList == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                //Tab Bar no Soal
                TabBar(
                  controller: _controller,
                  tabs: List.generate(
                    soalList!.data!.length,
                    (index) => Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                //Tab Bar View Soal dan Pilihan Jawaban
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TabBarView(
                        controller: _controller,
                        children: List.generate(
                          soalList!.data!.length,
                          (index) => SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Soal no ${index + 1}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: R.colors.greySubtitleHome),
                                ),
                                if (soalList!.data![index].questionTitle !=
                                    null)
                                  Html(
                                    data: soalList!.data![index].questionTitle!,
                                    style: {
                                      "body": Style(
                                        padding: EdgeInsets.zero,
                                      ),
                                      "p": Style(
                                        fontSize: const FontSize(12),
                                      )
                                    },
                                  ),
                                if (soalList!.data![index].questionTitleImg !=
                                    null)
                                  Image.network(
                                      soalList!.data![index].questionTitleImg!),
                                _buildOption(
                                    "A",
                                    soalList!.data![index].optionA,
                                    soalList!.data![index].optionAImg,
                                    index),
                                _buildOption(
                                    "B",
                                    soalList!.data![index].optionB,
                                    soalList!.data![index].optionBImg,
                                    index),
                                _buildOption(
                                    "C",
                                    soalList!.data![index].optionC,
                                    soalList!.data![index].optionCImg,
                                    index),
                                _buildOption(
                                    "D",
                                    soalList!.data![index].optionD,
                                    soalList!.data![index].optionDImg,
                                    index),
                                _buildOption(
                                    "E",
                                    soalList!.data![index].optionE,
                                    soalList!.data![index].optionEImg,
                                    index),
                              ],
                            ),
                          ),
                        ).toList()),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildOption(
      String option, String? answer, String? anserImg, int index) {
    final answerCheck = soalList!.data![index].studentAnswer == option;
    return GestureDetector(
      onTap: () {
        soalList!.data![index].studentAnswer = option;
        setState(() {});
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
              color: answerCheck ? Colors.blue.withOpacity(0.4) : Colors.white,
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Text(
                "$option.",
                style:
                    TextStyle(color: answerCheck ? Colors.white : Colors.black),
              ),
              if (answer != null)
                Expanded(
                    child: Html(
                  data: answer,
                  style: {
                    "p": Style(color: answerCheck ? Colors.white : Colors.black)
                  },
                )),
              if (anserImg != null) Expanded(child: Image.network(anserImg)),
            ],
          )),
    );
  }
}

class BottomSheetConfirmation extends StatefulWidget {
  const BottomSheetConfirmation({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomSheetConfirmation> createState() =>
      _BottomSheetConfirmationState();
}

class _BottomSheetConfirmationState extends State<BottomSheetConfirmation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: R.colors.greySubtitle,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Image.asset(R.assets.icConfirmation),
          const SizedBox(
            height: 10,
          ),
          const Text("Kumpulkan latihan soal sekarang?"),
          const Text("Boleh langsung kumpulin dong"),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("Nanti Dulu"),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Ya"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
