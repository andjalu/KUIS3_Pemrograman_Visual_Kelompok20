import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';

// sebaiknya di file terpisah
// menampung data hasil pemanggilan API
class Pinjaman {
  String nama;
  String id;

  Pinjaman({required this.nama, required this.id});
}

class ListPinjaman {
  //list berisi nama dan situs
  List<Pinjaman> listPinjaman = <Pinjaman>[];
  //constructor
  ListPinjaman(dynamic json) {
    //loop isi elemen data untuk ambil nama dan situs
    for (var val in json) {
      var nama = val["nama"].toString();
      var id = val["id"].toString();
      //tambahkan ke array
      listPinjaman.add(Pinjaman(nama: nama, id: id));
    }
  }

  //map dari json ke atribut
  factory ListPinjaman.fromJson(dynamic json) {
    return ListPinjaman(json);
  }
}

class ListPinjCubit extends Cubit<ListPinjaman> {
  bool loading = true;
  String kode = "1"; // kode id
  String url = "http://178.128.17.76:8000/jenis_pinjaman/";

  //constructor
  ListPinjCubit() : super(ListPinjaman([])) {
    fetchData();
  }

  //map dari json ke atribut
  void setFromJson(dynamic json) {
    emit(ListPinjaman(json));
  }

  void fetchData() async {
    final response = await http.get(Uri.parse(url + kode));
    if (response.statusCode == 200) {
      if (loading) loading = false;
      setFromJson(jsonDecode(response.body));
    } else {
      if (loading) loading = false;
      throw Exception('Gagal load');
    }
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My APP P2P',
      home: BlocProvider(
        create: (context) => ListPinjCubit(),
        child: const HalamanUtama(),
      ),
    );
  }
}

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({Key? key}) : super(key: key);

  @override
  HalamanUtamaState createState() => HalamanUtamaState();
}

class HalamanUtamaState extends State<HalamanUtama> {
  List<String> listPinjaman = ["1", "2", "3"];
  String selectedKode = "1";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'coba cubit',
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Jenis Pinjaman'),
            ),
            body: Column(children: [
              Text(
                  "2102204,Mohamad Asyqari Anugrah ; 2102671,Anderfa Jalu Kawani Saya berjanji tidak akan berbuat curang data atau membantu orang lain berbuat curang"),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedKode,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedKode = newValue!;
                  });
                  // access the ListUnivCubit instance
                  final listPinjCubit = BlocProvider.of<ListPinjCubit>(context);
                  listPinjCubit.loading = true;
                  listPinjCubit.kode = newValue!;
                  listPinjCubit
                      .fetchData(); // sama dengan context.read<ListUnivCubit>().fetchData();
                },
                items: listPinjaman.map((kode) {
                  return DropdownMenuItem<String>(
                    value: kode,
                    child: Center(child: Text(kode)),
                  );
                }).toList(),
              ),
              Expanded(
                  child: BlocBuilder<ListPinjCubit, ListPinjaman>(
                      buildWhen: (previousState, state) {
                return true;
              }, builder: (context, jenis) {
                final listPinjCubit = BlocProvider.of<ListPinjCubit>(context);
                if (listPinjCubit.loading) {
                  // return const CircularProgressIndicator();
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (jenis.listPinjaman.isNotEmpty) {
                  // gunakan listview builder
                  return ListView.builder(
                      itemCount: jenis.listPinjaman.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: ListTile(
                          onTap: () {},
                          title: Text(jenis.listPinjaman[index].nama),
                          subtitle: Text(jenis.listPinjaman[index].id),
                        ));
                      });
                } else {
                  return Text('Data pinjaman tidak ada.');
                }
              }))
            ])));
  }
}
