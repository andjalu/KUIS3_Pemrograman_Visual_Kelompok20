import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Pinjaman {
  String nama;
  String id;

  Pinjaman({required this.nama, required this.id});

  factory Pinjaman.fromJson(Map<String, dynamic> json) {
    return Pinjaman(nama: json['nama'], id: json['id']);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<Pinjaman> _pinjamanList;

  Future<List<Pinjaman>> fetchData() async {
    final response =
        await http.get(Uri.parse('http://178.128.17.76:8000/jenis_pinjaman/1'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body)['data'];
      return jsonResponse.map((data) => Pinjaman.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData().then((value) {
      setState(() {
        _pinjamanList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pinjaman List',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pinjaman List'),
        ),
        body: ListView.builder(
          itemCount: _pinjamanList.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                title: Text(_pinjamanList[index].nama),
                subtitle: Text(_pinjamanList[index].id),
              ),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
