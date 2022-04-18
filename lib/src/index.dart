import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LokalSetor {
  static LokalSetor get instansi => LokalSetor();

  ReferensiDokumen dok(String jalan) {
    return ReferensiDokumen(jalan);
  }

  ReferensiKoleksi koleksi(String jalan) {
    return ReferensiKoleksi(jalan);
  }
}

class ReferensiDokumen {
  String get jalan => _jalan;
  String get id => _id;
  ReferensiKoleksi? get induk => _induk;

  SharedPreferences? _prefs;
  Future<void> _awalPref() async =>
      _prefs = await SharedPreferences.getInstance();

  ReferensiDokumen(String jalan) {
    assert(jalan.isNotEmpty, 'jalan harus tidak berisi string kosong');
    assert(!jalan.contains('//'), 'jalan koleksi harus tidak berisi "//"');
    assert(_jalanDokumenValid(jalan),
        'jalan dokumen harus mengarah ke dokumen yang valid');
    _awal(jalan);
  }

  _awal(jalan) {
    _jalan = jalan;
    _id = Penunjuk(jalan).id;
    if (_jalan.split('')[0] != '/') _jalan = '/' + _jalan;
    if (_jalan.split('')[_jalan.length - 1] != '/') _jalan = _jalan + '/';
    if (Penunjuk(jalan).jalanInduk() != null)
      _induk = ReferensiKoleksi(Penunjuk(jalan).jalanInduk()!);
    else
      _induk = null;
  }

  Future<void> _buatJikaTidakAda() async {
    if (induk != null) {
      await induk!._buatJikaTidakAda();
    }
    if (_prefs == null) await _awalPref();
    PotretDokumen dok = await LokalSetor.instansi.dok(jalan).ambil();

    if (!dok.ada) {
      Map<String, dynamic> indukBaru = {
        "id": id,
        "data": null,
        "doc": null,
        "path": jalan,
        "title": null
      };
      await _prefs!.setString(jalan, jsonEncode(indukBaru));
      String? indukMentah = await _prefs!.getString(induk!.jalan);
      if (indukMentah != null) {
        Map<String, dynamic> indukData = jsonDecode(indukMentah);
        List<String> datas = List<String>.from(indukData['data'] ?? []);
        datas.add(id);
        indukData['data'] = datas;
        await _prefs!.setString(induk!.jalan, jsonEncode(indukData));
      }
    }
  }

  late String _jalan;
  late String _id;
  late ReferensiKoleksi? _induk;

  Future<PotretDokumen> ambil() async {
    PotretDokumen dok = await PotretDokumen._awal(_jalan);
    await dok.ambil();
    return dok;
  }

  Future<void> setel(Map<String, dynamic> data) async {
    if (induk != null) await induk!._buatJikaTidakAda();
    if (_prefs == null) await _awalPref();

    List<Map<String, dynamic>> param = _ubahMapKeParam(data);

    Map<String, dynamic> indukBaru = {
      "id": id,
      "data": null,
      "doc": param,
      "path": jalan,
      "title": null
    };

    await _prefs!.setString(jalan, jsonEncode(indukBaru));

    String? indukMentah = await _prefs!.getString(induk!.jalan);
    if (indukMentah != null) {
      Map<String, dynamic> indukData = jsonDecode(indukMentah);
      List<String> datas = List<String>.from(indukData['data'] ?? []);
      datas.add(id);
      indukData['data'] = datas;
      await _prefs!.setString(induk!.jalan, jsonEncode(indukData));
    }
  }
}

class ReferensiKoleksi {
  String get jalan => _jalan;
  String get id => _id;
  ReferensiDokumen? get induk => _induk;

  SharedPreferences? _prefs;
  Future<void> _awalPref() async =>
      _prefs = await SharedPreferences.getInstance();

  ReferensiKoleksi(String jalan) {
    assert(jalan.isNotEmpty, 'jalan harus tidak berisi string kosong');
    assert(!jalan.contains('//'), 'jalan koleksi harus tidak berisi "//"');
    assert(_jalanKoleksiValid(jalan),
        'jalan dokumen harus mengarah ke dokumen yang valid');
    _awal(jalan);
  }

  _awal(jalan) {
    _jalan = jalan;
    _id = Penunjuk(jalan).id;
    if (_jalan.split('')[0] != '/') _jalan = '/' + _jalan;
    if (_jalan.split('')[_jalan.length - 1] != '/') _jalan = _jalan + '/';
    if (Penunjuk(jalan).jalanInduk() != null)
      _induk = ReferensiDokumen(Penunjuk(jalan).jalanInduk()!);
    else
      _induk = null;
  }

  Future<void> _buatJikaTidakAda() async {
    if (induk != null) await induk!._buatJikaTidakAda();
    if (_prefs == null) await _awalPref();
    String? dok = await _prefs!.getString(jalan);
    if (dok == null) {
      Map<String, dynamic> indukBaru = {
        "id": id,
        "data": null,
        "doc": null,
        "path": jalan,
        "title": null
      };
      await _prefs!.setString(jalan, jsonEncode(indukBaru));
      String? indukMentah =
          await _prefs!.getString(induk != null ? induk!.jalan : '/');
      if (indukMentah != null) {
        Map<String, dynamic> indukData = jsonDecode(indukMentah);
        List<String> datas = List<String>.from(indukData['data'] ?? []);
        datas.add(id);
        indukData['data'] = datas;
        await _prefs!.setString(
            induk != null ? induk!.jalan : '/', jsonEncode(indukData));
      } else {
        Map<String, dynamic> indukBaru = {
          "id": id,
          "data": [id],
          "doc": null,
          "path": jalan,
          "title": null
        };
        await _prefs!.setString('/', jsonEncode(indukBaru));
      }
    }
  }

  late String _jalan;
  late String _id;
  late ReferensiDokumen? _induk;

  ReferensiDokumen dok(String jalan) {
    return ReferensiDokumen(_jalan + jalan);
  }

  Future<PotretKueri> ambil() async {
    PotretKueri kueri = await PotretKueri._ambil(_jalan);
    return kueri;
  }
}

// Support String, Map, List, number, bool, null, DateTime
class PotretDokumen {
  String get id => _id;
  String get jalan => _jalan;
  bool get ada => _params != null;
  ReferensiDokumen get referensi => _referensi;

  SharedPreferences? _prefs;
  Future<void> _awalPref() async =>
      _prefs = await SharedPreferences.getInstance();

  static Future<PotretDokumen> _awal(String jalan) async {
    PotretDokumen dok = PotretDokumen();
    dok._referensi = ReferensiDokumen(jalan);
    dok._jalan = jalan;

    dok._id = Penunjuk(jalan).id;
    return dok;
  }

  Future<void> ambil() async {
    // TODO

    if (_prefs == null) await _awalPref();
    String? params = await _prefs!.getString(_jalan);

    if (params != null) {
      try {
        Map<String, dynamic> data = jsonDecode(params);
        _DokumenMentah mentah = _DokumenMentah.fromMap(data);
        _id = mentah.id;

        _params = mentah.doc;
      } catch (e) {}
    } else {
      _params = null;
    }
  }

  Future<void> setel(Map<String, dynamic> data) async {
    if (referensi.induk != null) await referensi.induk!._buatJikaTidakAda();
    if (_prefs == null) await _awalPref();
    List<Map<String, dynamic>> param = _ubahMapKeParam(data);
    Map<String, dynamic> indukBaru = {
      "id": id,
      "data": null,
      "doc": param,
      "path": jalan,
      "title": null
    };
    await _prefs!.setString(jalan, jsonEncode(indukBaru));
    String? indukMentah = await _prefs!.getString(referensi.induk!.jalan);
    if (indukMentah != null) {
      Map<String, dynamic> indukData = jsonDecode(indukMentah);
      List<String> datas = List<String>.from(indukData['data'] ?? []);
      if (!datas.contains(id)) datas.add(id);
      indukData['data'] = datas;
      await _prefs!.setString(referensi.induk!.jalan, jsonEncode(indukData));
    }
  }

  Map<String, dynamic> data() {
    assert(ada, 'dokumen tidak ditemukan');
    Map<String, dynamic> result = _ubahParamkeMap(_params!);
    return result;
  }

  late ReferensiDokumen _referensi;
  late List<Map<String, dynamic>>? _params;
  late String _jalan;
  late String _id;
}

class PotretKueri {
  List<PotretDokumen>? get doks => _doks;
  int get size => (_doks ?? []).length;

  SharedPreferences? _prefs;
  Future<void> _awalPref() async =>
      _prefs = await SharedPreferences.getInstance();

  static Future<PotretKueri> _ambil(String jalan) async {
    PotretKueri kueri = PotretKueri();
    if (kueri._prefs == null) await kueri._awalPref();
    String? params = await kueri._prefs!.getString(jalan);

    if (params != null) {
      try {
        Map<String, dynamic> data = jsonDecode(params);
        _DokumenMentah mentah = _DokumenMentah.fromMap(data);
        List<PotretDokumen> doks = [];

        for (String id in (mentah.data ?? [])) {
          doks.add(await LokalSetor.instansi.dok(jalan + id).ambil());
        }

        kueri._doks = doks;
      } catch (e) {}
    } else {
      kueri._doks = null;
    }

    return kueri;
  }

  late List<PotretDokumen>? _doks;
}

bool _jalanDokumenValid(String jalanDokumen) {
  return Penunjuk(jalanDokumen).isDokumen();
}

bool _jalanKoleksiValid(String collectionPath) {
  return Penunjuk(collectionPath).isKoleksi();
}

Map<String, dynamic> _ubahParamkeMap(List<Map<String, dynamic>> params) {
  Map<String, dynamic> result = {};
  for (Map<String, dynamic> param in params) {
    dynamic value;
    switch (param['type']) {
      case 'dateTime':
        value = DateTime.tryParse(param['value']);
        break;
      case 'map':
        value = _ubahParamkeMap(param['value']);
        break;
      case 'array':
        value = _ubahParamkeList(param['value']);
        break;
      default:
        value = param['value'];
    }
    result[param['key']] = value;
  }
  return result;
}

List<dynamic> _ubahParamkeList(List<Map<String, dynamic>> params) {
  List<dynamic> result = [];
  for (dynamic param in params) {
    dynamic value;
    switch (param['type']) {
      case 'dateTime':
        value = DateTime.tryParse(param['value']);
        break;
      case 'map':
        value = _ubahParamkeMap(param['value']);
        break;
      case 'array':
        value = _ubahParamkeList(param['value']);
        break;
      default:
        value = param['value'];
    }
    result.add(value);
  }
  return result;
}

List<Map<String, dynamic>> _ubahListKeParam(List<dynamic> values) {
  List<Map<String, dynamic>> result = [];
  for (dynamic value in values) {
    String type = 'null';
    dynamic valueData = value;
    switch (value.runtimeType) {
      case String:
        type = 'string';
        break;
      case num:
        type = 'number';
        break;
      case DateTime:
        type = 'dateTime';
        valueData = valueData.toString();
        break;
      case bool:
        type = 'bool';
        break;
      case Map:
        type = 'map';
        valueData = _ubahMapKeParam(value);
        break;
      case List:
        type = 'array';
        valueData = _ubahListKeParam(value);
        break;
      default:
        type = 'null';
    }
    result.add({"type": type, "value": valueData});
  }
  return result;
}

List<Map<String, dynamic>> _ubahMapKeParam(Map<String, dynamic> value) {
  List<Map<String, dynamic>> result =
      List<Map<String, dynamic>>.from(value.entries.map((e) {
    String type = 'null';
    dynamic value = e.value;
    switch (e.value.runtimeType) {
      case String:
        type = 'string';
        break;
      case num:
        type = 'number';
        break;
      case DateTime:
        type = 'dateTime';
        value = e.value.toString();
        break;
      case bool:
        type = 'bool';
        break;
      case Map:
        type = 'map';
        value = _ubahMapKeParam(value);
        break;
      case List:
        type = 'array';
        value = _ubahListKeParam(value);
        break;
      default:
        type = 'null';
    }
    return {"type": type, "value": value, "key": e.key};
  }).toList());
  return result;
}

class Penunjuk {
  Penunjuk(String jalan)
      : komponens =
            jalan.split('/').where((element) => element.isNotEmpty).toList();

  String get jalan {
    return komponens.join('/');
  }

  final List<String> komponens;

  String get id {
    return komponens.last;
  }

  bool isKoleksi() {
    return komponens.length.isOdd;
  }

  bool isDokumen() {
    return komponens.length.isEven;
  }

  String jalanKoleksi(String jalanKoleksi) {
    assert(isDokumen());
    return '$jalan/$jalanKoleksi';
  }

  String jalanDokumen(String jalanDokumen) {
    assert(isKoleksi());
    return '$jalan/$jalanDokumen';
  }

  String? jalanInduk() {
    if (komponens.length < 2) {
      return null;
    }

    List<String> komponenInduk = List<String>.from(komponens)..removeLast();
    return komponenInduk.join('/');
  }

  @override
  bool operator ==(Object other) => other is Penunjuk && other.jalan == jalan;

  @override
  int get hashCode => jalan.hashCode;
}

class _DokumenMentah {
  String id, path;
  String? title;
  List<String>? data;
  List<Map<String, dynamic>>? doc;
  String? index;

  _DokumenMentah(
      {required this.id,
      required this.path,
      this.title,
      this.data,
      this.doc,
      this.index});

  factory _DokumenMentah.fromMap(Map<String, dynamic> value) {
    return _DokumenMentah(
      title: value['title'],
      path: value['path'],
      id: value['id'],
      data: value['data'] != null ? List<String>.from(value['data']) : null,
      doc: value['doc'] != null
          ? List<Map<String, dynamic>>.from(value['doc'])
          : null,
      index: value['index'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": this.title,
      "path": this.path,
      "id": this.id,
      "data": this.data,
      "doc": this.doc,
      "index": this.index,
    };
  }
}
