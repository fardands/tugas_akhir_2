import 'package:flutter/material.dart';
import 'sql_helper.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddStudent();
  }
}

class _AddStudent extends State<AddStudent> {
  TextEditingController nama = TextEditingController();
  TextEditingController kelas = TextEditingController();
  TextEditingController sekolah = TextEditingController();
  TextEditingController telp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Daftarkan Murid Baru"),
        ),
        body: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              TextField(
                controller: nama,
                decoration: const InputDecoration(
                  hintText: "Nama",
                ),
              ),
              TextField(
                controller: kelas,
                decoration: const InputDecoration(
                  hintText: "Kelas",
                ),
              ),
              TextField(
                controller: sekolah,
                decoration: const InputDecoration(
                  hintText: "Sekolah",
                ),
              ),
              TextField(
                controller: telp,
                decoration: const InputDecoration(
                  hintText: "Nomor telepon/hp",
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await _addItem();
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Sukses menambahkan murid")));
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  child: const Text("Simpan data murid")),
            ],
          ),
        ));
  }

  Future<void> _addItem() async {
    await SQLHelper.createItem(nama.text, kelas.text, sekolah.text, telp.text);
  }
}
