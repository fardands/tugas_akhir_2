import 'package:flutter/material.dart';
import 'sql_helper.dart';

// ignore: must_be_immutable
class AddActivity extends StatefulWidget {
  int id;
  AddActivity({super.key, required this.id});

  @override
  State<StatefulWidget> createState() {
    return _AddActivity();
  }
}

class _AddActivity extends State<AddActivity> {
  TextEditingController aktivitas = TextEditingController();
  TextEditingController aktivitasDesc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Aktivitas baru"),
        ),
        body: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              TextField(
                controller: aktivitas,
                decoration: const InputDecoration(
                  hintText: "judul aktivitas",
                ),
              ),
              TextField(
                controller: aktivitasDesc,
                decoration: const InputDecoration(
                  hintText: "deskripsi aktivitas",
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await _addItem();
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Sukses menambahkan aktivitas")));
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  child: const Text("Simpan data aktivitas")),
            ],
          ),
        ));
  }

  Future<void> _addItem() async {
    await SQLHelper.createAct(widget.id, aktivitas.text, aktivitasDesc.text);
  }
}
