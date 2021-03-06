import 'dart:convert';

import 'package:currency_flutter/screens/agencelistpage.dart';
import 'package:currency_flutter/screens/converssionMiles.dart';
import 'package:currency_flutter/screens/reclmation.dart';
import 'package:flutter/material.dart';
import 'package:currency_flutter/constants/textstyle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/textstyle.dart';
import '../model/fidelys.dart';
import '../screens/LogIn.dart';
import '../screens/achatMiles.dart';
import '../screens/activerCompte.dart';
import '../screens/gestiondeprofile.dart';
import '../screens/home_screen.dart';
import 'package:http/http.dart' as http;

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

class NavigationDrawerWidget extends StatefulWidget {
  @override
  _NavigationDrawerWidget createState() {
    // TODO: implement createState
    return _NavigationDrawerWidget();
  }
}

String finalid = "0";
late String title;

class _NavigationDrawerWidget extends State<NavigationDrawerWidget> {
  bool isvisible = false;
  final padding = EdgeInsets.symmetric(horizontal: 20);
  Future getvalidationData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userid = preferences.getString('id');
    setState(() {
      finalid = userid!;
    });
    if (finalid == "0") {
      title = "Login";
      isvisible;
    } else {
      title = "My account";
      isvisible = !isvisible;
    }
  }

  @override
  void initState() {
    getvalidationData();
    if (finalid == "0") {
      setState(() {
        title = "Login";
      });
    } else {
      setState(() {
        title = "My account";
      });
    }
    setState(() {});

    super.initState();
  }

  Future logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('id');
  }

  void login(BuildContext context) {
    setState(() {});
    if (finalid == "0") {
      title = "Login";
      isvisible = false;
      setState(() {});
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LogIn(),
          ));
      setState(() {});
    } else {
      setState(() {
        title = "My account";
      });
      isvisible = true;
      title = "My account";

      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GestionProfile(),
          ));
      setState(() {
        title = "My account";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Drawer(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildHeader(context),
          buildMenuItems(context),
        ],
      ),
    ));
  }

  Widget buildHeader(BuildContext context) => Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Image.asset("assets/images/fidelys.png"));

  Widget buildMenuItems(BuildContext context) => Wrap(
        children: [
          FutureBuilder(
            future: getfid(finalid),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<Fidelys> data = snapshot.data;
                return Container(
                    child: SingleChildScrollView(
                        child: Column(
                  children: data
                      .map<Widget>(
                        (data) => Container(
                          height: 65,
                          child: Row(
                            children: [
                              SizedBox(
                                  height: 65,
                                  child: Row(
                                    children: [
                                      Stack(
                                          alignment: Alignment.topLeft,
                                          children: [
                                            Image.asset(
                                                "assets/images/banner.png"),
                                            Positioned(
                                              top: 11,
                                              left: 4,
                                              child: Text(data.status,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                  )),
                                            )
                                          ]),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              data.firstname +
                                                  " " +
                                                  data.secondname,
                                              style:
                                                  ApptextStyle.LISTTILE_TITLE),
                                          Text("ID : " + data.id.toString(),
                                              style: ApptextStyle
                                                  .LISTTILE_SUB_TITLE),
                                        ],
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                )));
              }
              return Container(
                height: 65,
                child: Row(
                  children: [
                    SizedBox(
                        height: 65,
                        child: Row(
                          children: [
                            Stack(alignment: Alignment.topLeft, children: [
                              Image.asset("assets/logo/circle.png"),
                              Positioned(
                                top: 11,
                                left: 4,
                                child: Text("",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 20,
                                    )),
                              )
                            ]),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text("Welcome",
                                    style: ApptextStyle.LISTTILE_TITLE),
                                Text("Guset",
                                    style: ApptextStyle.LISTTILE_SUB_TITLE),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              );
            },
          ),
          const Divider(
            color: Colors.black54,
            height: 0,
            thickness: 0.5,
          ),
          FutureBuilder(
            future: getfid(finalid),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<Fidelys> data = snapshot.data;
                return Container(
                    child: SingleChildScrollView(
                        child: Column(
                  children: data
                      .map<Widget>((data) => Column(
                            children: [
                              ListTile(
                                  leading: const Icon(Icons.account_circle),
                                  title: Text(title),
                                  onTap: () {
                                    setState(() {});

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              GestionProfile(),
                                        ));
                                  }),
                              Visibility(
                                visible: isvisible,
                                child: ListTile(
                                  leading: const Icon(Icons.file_copy),
                                  title: const Text('Mes r??clamations'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => recc(),
                                        ));
                                    setState(() {});
                                  },
                                ),
                              ),
                              Visibility(
                                visible: isvisible,
                                child: ListTile(
                                  leading: const Icon(Icons.airplane_ticket),
                                  title: const Text(
                                      'R??server/Acheter une billet Prime'),
                                  onTap: () {
                                    setState(() {});
                                  },
                                ),
                              ),
                              Visibility(
                                visible: isvisible,
                                child: ListTile(
                                  leading:
                                      const Icon(Icons.shopping_cart_rounded),
                                  title: const Text('Acheter des Miles'),
                                  onTap: () {
                                    setState(() {});
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AchatMiles(),
                                        ));
                                    setState(() {});
                                  },
                                ),
                              ),
                              Visibility(
                                visible: isvisible,
                                child: ListTile(
                                  leading: const Icon(Icons.loop_outlined),
                                  title: const Text('Converssion des Miles'),
                                  onTap: () {
                                    setState(() {});
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ConverssionMiles(),
                                        ));
                                    setState(() {});
                                  },
                                ),
                              ),
                              Visibility(
                                visible: isvisible,
                                child: ListTile(
                                  leading: const Icon(Icons.exit_to_app),
                                  title: const Text('Se d??connecter'),
                                  onTap: () {
                                    logout();
                                    finalid = "0";
                                    title = "Login";
                                    setState(() {});
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomeScreen(),
                                        ));
                                    setState(() {});
                                  },
                                ),
                              ),
                              const Divider(color: Colors.black54),
                              ListTile(
                                leading: const Icon(Icons.home_work_rounded),
                                title: const Text('Nos agences'),
                                onTap: () {
                                  setState(() {});
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AgenceListPage(),
                                      ));

                                  setState(() {});
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.local_phone),
                                title: const Text('Nous contacter'),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const Divider(
                                color: Colors.black54,
                                height: 0,
                              ),
                              ListTile(
                                leading: const Icon(Icons.info),
                                title: const Text('Info & Services'),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.settings),
                                title: const Text('Param??tres'),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ))
                      .toList(),
                )));
              }
              return Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: Text(title),
                    onTap: () {
                      setState(() {});
                      getvalidationData().whenComplete(() => login(context));
                      setState(() {});
                    },
                  ),
                  Visibility(
                    visible: isvisible,
                    child: ListTile(
                      leading: const Icon(Icons.file_copy),
                      title: const Text('Mes r??clamations'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => recc(),
                            ));
                        setState(() {});
                      },
                    ),
                  ),
                  Visibility(
                    visible: isvisible,
                    child: ListTile(
                      leading: const Icon(Icons.airplane_ticket),
                      title: const Text('R??server/Acheter une billet Prime'),
                      onTap: () {
                        setState(() {});
                      },
                    ),
                  ),
                  Visibility(
                    visible: isvisible,
                    child: ListTile(
                      leading: const Icon(Icons.shopping_cart_rounded),
                      title: const Text('Acheter des Miles'),
                      onTap: () {
                        setState(() {});
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AchatMiles(),
                            ));
                        setState(() {});
                      },
                    ),
                  ),
                  Visibility(
                    visible: isvisible,
                    child: ListTile(
                      leading: const Icon(Icons.loop_outlined),
                      title: const Text('Converssion des Miles'),
                      onTap: () {
                        setState(() {});
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConverssionMiles(),
                            ));
                        setState(() {});
                      },
                    ),
                  ),
                  Visibility(
                    visible: isvisible,
                    child: ListTile(
                      leading: const Icon(Icons.exit_to_app),
                      title: const Text('Se d??connecter'),
                      onTap: () {
                        logout();
                        finalid = "0";
                        title = "Login";
                        setState(() {});
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ));
                        setState(() {});
                      },
                    ),
                  ),
                  const Divider(color: Colors.black54),
                  ListTile(
                    leading: const Icon(Icons.home_work_rounded),
                    title: const Text('Nos agences'),
                    onTap: () {
                      setState(() {});
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AgenceListPage(),
                          ));

                      setState(() {});
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.local_phone),
                    title: const Text('Nous contacter'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(
                    color: Colors.black54,
                    height: 0,
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('Info & Services'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Param??tres'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          ),
        ],
      );
}
