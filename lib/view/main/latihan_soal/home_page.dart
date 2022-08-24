import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lms/constant/r.dart';
import 'package:lms/models/banner_list.dart';
import 'package:lms/models/mapel_list.dart';
import 'package:lms/models/network_response.dart';
import 'package:lms/repository/latihan_soal_api.dart';
import 'package:lms/view/main/latihan_soal/mapel_page.dart';

import 'paket_soal_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MapelList? mapelList;
  getMapel() async {
    final mapel = await LatihanSoalApi().getMapel();
    if (mapel.status == Status.success) {
      mapelList = MapelList.fromJson(mapel.data!);
      setState(() {});
    }
  }

  BannerList? bannerList;
  getBanner() async {
    final banner = await LatihanSoalApi().getBanner();
    if (banner.status == Status.success) {
      bannerList = BannerList.fromJson(banner.data!);
      setState(() {});
    }
  }

  // UserData? userData;
  // getUserData1() async {
  //   userData = await PreferenceHelper().getUserData();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMapel();
    getBanner();
    // getUserData1();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.grey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildUserHomeProfile(),
              _buildTopBanner(context),
              _buildHomeListMapel(mapelList),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Terbaru",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    bannerList == null
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : SizedBox(
                            height: 150,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final currentBanner = bannerList!.data![index];
                                return Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                          currentBanner.eventImage!)),
                                );
                              },
                              itemCount: bannerList!.data!.length,
                            ),
                          ),
                    const SizedBox(
                      height: 35,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildHomeListMapel(MapelList? list) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Pilih pelajaran",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapelPage(mapel: mapelList!),
                        ));
                  },
                  child: Text(
                    "Lihat Semua",
                    style: TextStyle(
                        fontSize: 12,
                        color: R.colors.primary,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          ),
          list == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.data!.length > 3 ? 3 : list.data!.length,
                  itemBuilder: (context, index) {
                    final currentMapel = list.data![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PaketSoalPage(id: currentMapel.courseId!),
                          ),
                        );
                      },
                      child: MapelWidget(
                        title: currentMapel.courseName!,
                        totalDone: currentMapel.jumlahDone.toString(),
                        totalPacket: currentMapel.jumlahMateri.toString(),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Container _buildTopBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      height: 147,
      width: double.infinity,
      decoration: BoxDecoration(
        color: R.colors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.25,
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            child: const Text(
              "Mau Kerjain Soal Apa Hari Ini?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              R.assets.imgHome,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
          )
        ],
      ),
    );
  }

  Padding _buildUserHomeProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi Anon",
                  // userData?.userName.toString() ?? 'Hi Anonymous',
                  style: GoogleFonts.poppins()
                      .copyWith(fontWeight: FontWeight.w700, fontSize: 12),
                ),
                Text(
                  "Selamat Datang",
                  style: GoogleFonts.poppins().copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          Image.asset(
            R.assets.imgProfile,
            width: 35,
            height: 35,
          ),
        ],
      ),
    );
  }
}

class MapelWidget extends StatelessWidget {
  const MapelWidget({
    Key? key,
    required this.title,
    required this.totalDone,
    required this.totalPacket,
  }) : super(key: key);
  final String title;
  final String totalDone;
  final String totalPacket;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 21),
      child: Row(
        children: [
          Container(
            height: 53,
            width: 53,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: R.colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              R.assets.icAtom,
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
                Text(
                  "$totalDone/$totalPacket Paket latihan soal",
                  style: TextStyle(
                      color: R.colors.greySubtitleHome,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 5,
                ),
                Stack(
                  children: [
                    Container(
                      height: 5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: R.colors.grey),
                    ),
                    Container(
                      height: 5,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: R.colors.primary),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
