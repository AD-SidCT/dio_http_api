import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataStoreScreen extends StatefulWidget {
  final token;
  const DataStoreScreen({Key? key, this.token}) : super(key: key);
  @override
  State<DataStoreScreen> createState() => _DataStoreScreenState();
}

class _DataStoreScreenState extends State<DataStoreScreen> {
  bool getData = false;
  Future<void> detchData() async {
    setState(() {
      getData = true;
    });
    final response = await http.get(
        Uri.parse('https://spv-dev.dkv.global:8000/api/user/marketplace-list/'),
        headers: {'Authorization': 'Bearer ${widget.token}'});
    print(response.statusCode.toString());
    print(response.body);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Your Failed Request with status : ${response.statusCode} ');
    }
    setState(() {
      getData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stored Data'),
      ),
      body: FutureBuilder(
        future: detchData(),
        builder: (BuildContext cotext, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            print('hasdata');
            return ListView.separated(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Text('id ${snapshot.data[index]['id']}'),
                    Text('user_id ${snapshot.data[index]['user_id']}'),
                    Text(snapshot.data[index]['title']),
                    Text(snapshot.data[index]['progress_bar'].toString()),
                    Text(snapshot.data[index]['currency']),
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  height: 2,
                );
              },
            );
          } else if (snapshot.hasError) {
            print('has Error');
            return const Center(
              child: Text('Something went Wrong'),
            );
          } else {
            // return a widget when there's no data yet
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
