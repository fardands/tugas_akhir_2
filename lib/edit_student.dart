import 'package:flutter/material.dart';
import 'sql_helper.dart';

// ignore: must_be_immutable
class EditStudent extends StatefulWidget {
  int id;
  dynamic nama;
  dynamic kelas;
  dynamic sekolah;
  EditStudent(
      {super.key,
      required this.id,
      required this.nama,
      required this.kelas,
      required this.sekolah});

  @override
  State<StatefulWidget> createState() {
    return _EditStudent();
  }
}

class _EditStudent extends State<EditStudent> {
  TextEditingController nama = TextEditingController();
  TextEditingController kelas = TextEditingController();
  TextEditingController sekolah = TextEditingController();

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(id, nama.text, kelas.text, sekolah.text);
  }

  @override
  void initState() {
    nama.text = widget.nama;
    kelas.text = widget.kelas;
    sekolah.text = widget.sekolah;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Ubah data murid"),
        ),
        body: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              TextField(
                controller: nama,
              ),
              TextField(
                controller: kelas,
              ),
              TextField(
                controller: sekolah,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await _updateItem(widget.id);
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Sukses mengubah data murid")));
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  child: const Text("Ubah data murid")),
            ],
          ),
        ));
  }
}
