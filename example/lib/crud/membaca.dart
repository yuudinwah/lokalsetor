import 'package:example/crud/membuat.dart';
import 'package:example/crud/menghapus.dart';
import 'package:example/crud/mengubah.dart';
import 'package:flutter/material.dart';
import 'package:lokalsetor/lokalsetor.dart';

class Membaca extends StatefulWidget {
  const Membaca({
    Key? key,
  }) : super(key: key);

  @override
  State<Membaca> createState() => _MembacaState();
}

class _MembacaState extends State<Membaca> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Lokalsetor'),
      ),
      body: FutureBuilder<PotretKueri>(
        future: LokalSetor.instansi.koleksi('catatan').ambil(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (_, int indek) {
                PotretDokumen dokumen = snapshot.data!.doks![indek];
                if (dokumen.ada) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          offset: const Offset(0.0, 0.0),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    dokumen.data()['label'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 210,
                              child: Text(
                                dokumen.data()['judul'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              width: 210,
                              child: Text(
                                dokumen.data()['deskripsi'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                bool? result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Mengubah(
                                      dokumen: dokumen,
                                    ),
                                  ),
                                );

                                if (result != null && result) {
                                  setState(() {});
                                }
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                            ),
                            Menghapus(
                              onPressed: () async {
                                await dokumen.referensi.hapus();

                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Membuat(),
            ),
          );

          if (result != null && result) {
            setState(() {});
          }
        },
      ),
    );
  }
}
