import 'package:flutter/material.dart';
import 'sql_helper.dart';

// ignore: must_be_immutable
class EditActivity extends StatefulWidget {
  int id;
  dynamic aktivitas;
  dynamic aktivitasDesc;
  EditActivity({
    super.key,
    required this.id,
    required this.aktivitas,
    required this.aktivitasDesc,
  });

  @override
  State<StatefulWidget> createState() {
    return _EditActivity();
  }
}

class _EditActivity extends State<EditActivity> {
  TextEditingController aktivitas = TextEditingController();
  TextEditingController aktivitasDesc = TextEditingController();

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateAct(id, aktivitas.text, aktivitasDesc.text);
  }

  @override
  void initState() {
    aktivitas.text = widget.aktivitas;
    aktivitasDesc.text = widget.aktivitasDesc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Ubah detail aktivitas"),
        ),
        body: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              TextField(
                controller: aktivitas,
              ),
              TextField(
                controller: aktivitasDesc,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await _updateItem(widget.id);
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Sukses mengubah detail aktivitas")));
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  child: const Text("Ubah detail aktivitas")),
            ],
          ),
        ));
  }
}
