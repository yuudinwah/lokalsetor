import 'package:example/crud/membaca.dart';
import 'package:flutter/material.dart';
import 'package:lokalsetor/lokalsetor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<PotretDokumen>(
        future: LokalSetor.instansi.koleksi('settings').dok('counter').ambil(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.ada) {
              return Column(
                children: [
                  const Expanded(child: SizedBox()),
                  const Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    '${snapshot.data!.data()['counter']}',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Membaca(),
                      ),
                    ),
                    child: const Text('Contoh CRUD'),
                  ),
                  const Expanded(child: SizedBox()),
                  Container(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton(
                      onPressed: () async => snapshot.data!.referensi.setel({
                        'counter': snapshot.data!.data()['counter'] + 1
                      }).then((value) => setState(() {})),
                      tooltip: 'Increment',
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              );
            } else {
              return FutureBuilder<void>(
                future: LokalSetor.instansi
                    .dok('settings/counter')
                    .setel({'counter': 0}).then((value) => setState(() {})),
                builder: (_, __) {
                  return const Text('Loading ...');
                },
              );
            }
          } else {
            return const Text('Loading ...');
          }
        },
      ),
    );
  }
}
