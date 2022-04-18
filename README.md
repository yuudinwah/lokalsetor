# lokalsetor
Flutter local database based on sharedpreference

You can try it on
[lokalsetor.lamun.my.id](https://lokalsetor.lamun.my.id).

### Usage

```dart
import 'package:lokalsetor/lokalsetor.dart';

...
Future<void> main() async {
  PotretDokumen dok = await LokalSetor.instansi.koleksi('koleksiID').dok('dokumenID').ambil();
  ...
...
```

### Koleksi

[Koleksi] is a place to store several [Dokumen] in it we can add [Dokumen] and retrieve all [Dokumen] in the [Koleksi]

### PotretKueri

`PotretKueri()` - return when get all [Dokumen] on [Koleksi]

* `.doks` - will return the [Dokumen] that are in the [Koleksi]
* `.size` - will return the length of the [Dokumen] that are in the [Koleksi]

For example:

```dart
...
  PotretKueri kueri = await LokalSetor.instansi.koleksi('koleksiID').ambil();
  int size = kueri.size;
  List<PotretDokumen>? doks = kueri.doks;
...
```

### PotretDokumen

`PotretDokumen()` - return when get single [Dokumen]

* `.id` - will return the [Dokumen] ID
* `.ada` - will return the [Dokumen] is exists?
* `.jalan` - will return the [Dokumen] path
* `.referensi` - will return the [Dokumen] reference in the form of [ReferensiDokumen]

* `.ambil()` - to get [Dokumen]
* `.data()` - will return the data of [Dokumen] in the form of [Map<String, dynamic>]
* `.setel(data)` - to reformat [Dokumen] to a new format

For example:

```dart
...
  PotretDokumen dok = await LokalSetor.instansi.dok(jalanDok).ambil();
    if (dok.ada) {
      print(dok.id);
      Map<String, dynamic> data = dok.data();
    }
...
```
