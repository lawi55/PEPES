import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/fidelys.dart';
import '../widgets/navigation_drawer_widget.dart';

Future getfid(String id) async {
  var Url = "http://10.0.2.2:8081/getfidelys";
  var res = await http.post(Uri.parse(Url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(<String, String>{"id": id}));
  if (res.statusCode == 200) {
    List jsonResponse = json.decode(res.body);
    // print(jsonResponse.length);

    print(id);
    return jsonResponse.map((data) => new Fidelys.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

String mliesqua = "";

class ConverssionMiles extends StatefulWidget {
  @override
  _ConverssionMiles createState() {
    // TODO: implement createState
    return _ConverssionMiles();
  }
}

String mp = "";

class _ConverssionMiles extends State<ConverssionMiles> {
  final TextEditingController milesprimecontroller =
      new TextEditingController(text: mp);

  late final TextEditingController milesqualifiantcontroller =
      new TextEditingController(text: mliesqua);

  Future getvalidationData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userid = preferences.getString('id');
    setState(() {
      finalid = userid!;
    });
  }

  @override
  void initState() {
    getvalidationData();

    super.initState();
  }

  Future TesterSolde(String id, String solde) async {
    var Url = "http://10.0.2.2:8081/testersolde";
    var res = await http.post(Uri.parse(Url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(<String, String>{"id": id, "solde": solde}));
    if (res.statusCode == 200) {
      int jsonResponse = json.decode(res.body);
      print(jsonResponse);

      print(id);
      print(jsonResponse);

      setState(() {
        mp = solde;
        mliesqua = jsonResponse.toString();
      });
      return jsonResponse;
    } else {
      Fluttertoast.showToast(
          msg: "Votre solde est insuffisant",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      throw Exception('Unexpected error occured!');
    }
  }

  Future ConvertirSolde(String id, String solde) async {
    var Url = "http://10.0.2.2:8081/convertirsolde";
    var res = await http.post(Uri.parse(Url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(<String, String>{"id": id, "solde": solde}));
    if (res.statusCode == 200) {
      String jsonResponse = json.decode(res.body);
      print(jsonResponse);

      print(id);
      print(jsonResponse);

      setState(() {
        Fluttertoast.showToast(
            msg: res.body,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      });
      return jsonResponse;
    } else {
      Fluttertoast.showToast(
          msg: "Probléme ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      throw Exception('Unexpected error occured!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: Color(0xFFD80404),
          title: Container(
            padding: EdgeInsets.all(25),
            child: Image.asset(
              "assets/images/tunisair.png",
              height: 60,
            ),
          ),
          elevation: 0.0,
        ),
        body: Column(
          children: [
            Text("Convertissement des Miles Primes en Miles Qualifiants"),
            Text("Miles Prime"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 170,
                    height: 35,
                    child: TextField(
                      controller: milesprimecontroller,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    )),
              ],
            ),
            Text("Max 15000."),
            Text("Miles Qualifiants"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 170, height: 35, child: Text(mliesqua)),
              ],
            ),
            Container(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(140, 40),
                        textStyle: TextStyle(fontSize: 19)),
                    child: Text("Initialiser"),
                    onPressed: () {
                      TesterSolde(finalid, milesprimecontroller.text);
                      setState(() {});
                    }),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(140, 40),
                        textStyle: TextStyle(fontSize: 19)),
                    child: Text("Convertir"),
                    onPressed: () {
                      ConvertirSolde(finalid, milesprimecontroller.text);
                      setState(() {});
                    })
              ],
            ))
          ],
        ));
  }
}
