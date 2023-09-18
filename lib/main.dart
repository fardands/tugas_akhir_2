import 'package:flutter/material.dart';
import 'package:tugas_akhir_2/add_student.dart';
import 'edit_student.dart';
import 'sql_helper.dart';

void main() {
  runApp(const ListStudents());
}

class ListStudents extends StatelessWidget {
  const ListStudents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        // Remove the debug banner
        debugShowCheckedModeBanner: false,
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // All journals
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
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

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Sukses menghapus data murid'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Murid Les'),
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
                      title: Text("Nama: " + _journals[index]['nama']),
                      subtitle: Text("Kelas: " + _journals[index]['kelas']),
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
                                              const Text("Detail Murid"),
                                              Text("Nama: " +
                                                  _journals[index]['nama']),
                                              Text("Kelas: " +
                                                  _journals[index]['kelas']),
                                              Text("Sekolah: " +
                                                  _journals[index]['sekolah']),
                                              Text("Nomor hp: " +
                                                  _journals[index]['telp']),
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
                                    return EditStudent(
                                      id: _journals[index]['id'],
                                      nama: _journals[index]['nama'],
                                      kelas: _journals[index]['kelas'],
                                      sekolah: _journals[index]['sekolah'],
                                      telp: _journals[index]['telp'],
                                    );
                                  }));
                                  _refreshJournals();
                                }),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteItem(_journals[index]['id']),
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
                return const AddStudent();
              }));
              _refreshJournals();
            }));
  }
}
