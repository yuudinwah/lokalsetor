import 'package:flutter/material.dart';
import 'package:lokalsetor/lokalsetor.dart';

class Mengubah extends StatefulWidget {
  final PotretDokumen dokumen;

  const Mengubah({
    Key? key,
    required this.dokumen,
  }) : super(key: key);

  @override
  State<Mengubah> createState() => _MengubahState();
}

class _MengubahState extends State<Mengubah> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _judul = TextEditingController();
  TextEditingController _deskripsi = TextEditingController();
  TextEditingController _label = TextEditingController();

  @override
  void initState() {
    super.initState();
    _judul = TextEditingController(text: widget.dokumen.data()['judul']);
    _deskripsi =
        TextEditingController(text: widget.dokumen.data()['deskripsi']);
    _label = TextEditingController(text: widget.dokumen.data()['label']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mengubah Catatan'),
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
                        await widget.dokumen.referensi.ubah(
                          {
                            'judul': _judul.text,
                            'deskripsi': _deskripsi.text,
                            'label': _label.text,
                          },
                        ).then((_) => Navigator.pop(context, true));
                      }
                    },
                    child: const Text('UPDATE'),
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
