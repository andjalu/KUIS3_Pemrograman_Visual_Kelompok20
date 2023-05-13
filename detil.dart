import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

// menampung data hasil pemanggilan API
class Pinjaman {
  String nama;
  String id;
  String bunga;
  String isSyariah;

  Pinjaman(
      {required this.nama,
      required this.id,
      required this.bunga,
      required this.isSyariah}); //constructor

  //map dari json ke atribut
  factory Pinjaman.fromJson(Map<String, dynamic> json) {
    return Pinjaman(
        nama: json['nama'],
        id: json['id'],
        bunga: json['bunga'],
        isSyariah: json['is_syariah']);
  }
}

//class state
class MyAppState extends State<MyApp> {
  late Future<Pinjaman> futureCatFact;
  String url = "http://178.128.17.76:8000/detil_jenis_pinjaman/5";

  //fetch data
  Future<Pinjaman> fetchData() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // jika server mengembalikan 200 OK (berhasil),
      // parse json
      return Pinjaman.fromJson(jsonDecode(response.body));
    } else {
      // jika gagal (bukan  200 OK),
      // lempar exception
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureCatFact = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'coba http',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('coba http'),
          ),
          body: Center(
            child: FutureBuilder<Pinjaman>(
              future: futureCatFact,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Text("Nama : ${snapshot.data!.nama}"),
                        Text("id : ${snapshot.data!.id}"),
                        Text("bunga : ${snapshot.data!.bunga}"),
                        Text("isSyariah : ${snapshot.data!.isSyariah}")
                      ]));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ),
        ));
  }
}
