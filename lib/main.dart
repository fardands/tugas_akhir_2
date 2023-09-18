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
        title: 'Daftar Murid Ekstrakurikuler',
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
                      title: Text("Nama: " +
                          _journals[index]['nama'] +
                          " | Kelas: " +
                          _journals[index]['kelas']),
                      subtitle:
                          Text("Asal Sekolah: " + _journals[index]['sekolah']),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
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
