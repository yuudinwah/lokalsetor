import 'package:flutter/material.dart';
import 'package:lokalsetor/lokalsetor.dart';

class Membuat extends StatelessWidget {
  Membuat({
    Key? key,
  }) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _judul = TextEditingController();
  final TextEditingController _deskripsi = TextEditingController();
  final TextEditingController _label = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membuat Catatan'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _judul,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.title),
                    labelText: 'Judul',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val == '') {
                      return 'Judul harus diisi!';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 14,
                ),
                TextFormField(
                  controller: _deskripsi,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.description),
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val == '') {
                      return 'Deskripsi harus diisi!';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 14,
                ),
                TextFormField(
                  controller: _label,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.label),
                    labelText: 'Label',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val == '') {
                      return 'Label harus diisi!';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 18,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () async {
                      FormState? form = _formKey.currentState;

                      if (form != null && form.validate()) {
                        await LokalSetor.instansi.koleksi('catatan').tambah(
                          {
                            'judul': _judul.text,
                            'deskripsi': _deskripsi.text,
                            'label': _label.text,
                          },
                        ).then((_) => Navigator.pop(context, true));
                      }
                    },
                    child: const Text('SIMPAN'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
