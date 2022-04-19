import 'package:lokalsetor/lokalsetor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test Koleksi', () {
    test(('Test Tambah Dokumen'), () async {
      Map<String, dynamic> data = {"test": "koleksi"};
      ReferensiDokumen refDok =
          await LokalSetor.instansi.koleksi('test').tambah(data);
      expect(
          (await refDok.ambil()).id,
          equals(
              (await LokalSetor.instansi.dok('test/${refDok.id}').ambil()).id));
    });
    
  });
  // LokalSetor.instansi.koleksi('users').tambah({'nama': 'Wahyu Wahyudin'});
}
