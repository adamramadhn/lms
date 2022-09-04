import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lms/constant/r.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, this.id}) : super(key: key);
  static String route = "chat_page";
  final String? id;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final textController = TextEditingController();
  late CollectionReference chat;
  late QuerySnapshot chatData;

  @override
  Widget build(BuildContext context) {
    chat = FirebaseFirestore.instance
        .collection("room")
        .doc("kimia")
        .collection("chat");
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diskusi Soal"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: chat.orderBy("time").snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data?.docs.reversed.length ?? 0,
                    itemBuilder: (context, index) {
                      final currentCHat =
                          snapshot.data!.docs.reversed.toList()[index];
                      final currentDate =
                          (currentCHat["time"] as Timestamp?)?.toDate();
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          crossAxisAlignment: user.uid == currentCHat["uid"]
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentCHat["nama"],
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xff5200ff),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: user.uid == currentCHat["uid"]
                                    ? Colors.green
                                    : const Color(0xffffdcdc),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: const Radius.circular(10),
                                  bottomRight: user.uid == currentCHat["uid"]
                                      ? const Radius.circular(0)
                                      : const Radius.circular(10),
                                  topRight: const Radius.circular(10),
                                  topLeft: user.uid == currentCHat["uid"]
                                      ? const Radius.circular(10)
                                      : const Radius.circular(0),
                                ),
                              ),
                              child: currentCHat["type"] == "file"
                                  ? Image.network(
                                      currentCHat["file_url"],
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          padding: const EdgeInsets.all(10),
                                          child: const Icon(Icons.warning),
                                        );
                                      },
                                    )
                                  : Text(
                                      currentCHat["content"],
                                    ),
                            ),
                            Text(
                              currentDate == null
                                  ? ""
                                  : DateFormat("dd-MMM-yyy HH:mm")
                                      .format(currentDate),
                              style: TextStyle(
                                fontSize: 10,
                                color: R.colors.greySubtitleHome,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          SafeArea(
            child: Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    offset: const Offset(0, -1),
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.25))
              ]),
              child: Row(children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add,
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              controller: textController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: "  Tulis pesan disini...",
                                hintStyle: const TextStyle(color: Colors.grey),
                                suffixIcon: IconButton(
                                  onPressed: () async {
                                    final imgResult = await ImagePicker()
                                        .pickImage(
                                            source: ImageSource.camera,
                                            maxHeight: 500,
                                            maxWidth: 500);

                                    if (imgResult != null) {
                                      File file = File(imgResult.path);
                                      final nameFile =
                                          imgResult.path.split("/");
                                      String room = widget.id ?? "kimia";
                                      String ref =
                                          "chat/$room/${user.uid}/${imgResult.name}";

                                      final imgResUpload = await FirebaseStorage
                                          .instance
                                          .ref()
                                          .child(ref)
                                          .putFile(file);

                                      final url = await imgResUpload.ref
                                          .getDownloadURL();

                                      final chatContent = {
                                        "nama": user.displayName,
                                        "uid": user.uid,
                                        "content": textController.text,
                                        "email": user.email,
                                        "photo": user.photoURL,
                                        "ref": ref,
                                        "type": "file",
                                        "file_url": url,
                                        "time": FieldValue.serverTimestamp(),
                                      };
                                      chat.add(chatContent).whenComplete(
                                          () => textController.clear());
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (textController.text.isEmpty) {
                              return;
                            }
                            // print(textController.text);
                            final user = FirebaseAuth.instance.currentUser!;
                            final chatContent = {
                              "nama": user.displayName,
                              "uid": user.uid,
                              "content": textController.text,
                              "email": user.email,
                              "photo": user.photoURL,
                              "ref": null,
                              "type": "text",
                              "file_url": null,
                              "time": FieldValue.serverTimestamp(),
                            };
                            chat
                                .add(chatContent)
                                .whenComplete(() => textController.clear());
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}
