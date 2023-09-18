import 'package:flutter/material.dart';
import 'add_activity.dart';
import 'edit_activity.dart';
import 'sql_helper.dart';

// ignore: must_be_immutable
class ListActivity extends StatefulWidget {
  int id;
  ListActivity({super.key, required this.id});

  @override
  State<StatefulWidget> createState() {
    return _ListActivity();
  }
}

class _ListActivity extends State<ListActivity> {
  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;

  void _refreshJournals() async {
    final data = await SQLHelper.getAct(widget.id);
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
  }

  void _deleteItem(int id) async {
    await SQLHelper.deleteItem('aktivitas', id);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Sukses menghapus aktivitas murid'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Aktivitas Murid'),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _journals.length,
                itemBuilder: (context, index) => Card(
                  margin: const EdgeInsets.all(15),
                  child: ListTile(
                      title: Text(_journals[index]['aktivitas']),
                      subtitle: Text(_journals[index]['tanggal']
                          .toString()
                          .substring(0, 10)),
                      trailing: SizedBox(
                        width: 150,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                        //height: 200,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            //mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              const Text("Detail Aktivitas"),
                                              Text("Pelajaran: " +
                                                  _journals[index]
                                                      ['aktivitas']),
                                              Text("Materi: " +
                                                  _journals[index]
                                                      ['aktivitasDesc']),
                                              ElevatedButton(
                                                child: const Text('Tutup'),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.text_snippet)),
                            IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  await Navigator.push(context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return EditActivity(
                                      id: _journals[index]['id_aktivitas'],
                                      aktivitas: _journals[index]['aktivitas'],
                                      aktivitasDesc: _journals[index]
                                          ['aktivitasDesc'],
                                    );
                                  }));
                                  _refreshJournals();
                                }),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteItem(_journals[index]['id_aktivitas']),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return AddActivity(id: widget.id);
              }));
              _refreshJournals();
            }));
  }
}
