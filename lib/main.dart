import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        CupertinoButton(
          child: Text("Send Req"),
          onPressed: () async {
            int start = 0;
            Map<String, String> header = {
              "Authorization":
                  "Bearer sk_test_7900fef8f8ea69dca85277900fff368124be8b17",
              "Content-Type": "application/json"
            };
            Map body = {
              "email": "oreofesolarin@gmail.com",
              "amount": "10000",
              "ussd": {"type": "737"},
              "metadata": {
                "custom_fields": [
                  {
                    "value": "makurdi",
                    "display_name": "Donation for",
                    "variable_name": "donation_for"
                  }
                ]
              }
            };
            http
                .post(Uri.parse("https://api.paystack.co/charge"),
                    headers: header, body: jsonEncode(body))
                .then((value) async {
              var k = json.decode(value.body);
              log(k.toString());
              if (k["status"]) {
                Timer.periodic(const Duration(seconds: 5), (t) async {
                  await http
                      .get(Uri.parse(
                          "https://paystackflutterbackendtest.herokuapp.com/ussd"))
                      .then((value) {
                    if (jsonDecode(value.body)["Hi"] != "Yo") {
                      log(jsonDecode(value.body)["Hi"]);
                      t.cancel();
                    } else {
                      start++;
                      if (start >= 60) {
                        log("done waiting f");
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                "We have waited but nothing. Please try again Later")));
                      }
                      log("Waiting");
                    }
                  });
                });
              }
            });
          },
        ),
      ],
    )));
  }
}
