import 'package:flutter/material.dart';
import 'package:vidbusters/Widgets/appdrawer.dart';
import 'dart:io';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<bool> onWillPop() {
    Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          exit(0);
        });
    Widget cancelButton = FlatButton(
        child: Text("cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        });

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15)),
            title: Text("Exit"),
            content: Text("Are you sure you want to exit?"),
            actions: [okButton, cancelButton],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      drawer: AppDrawer(),
      body: WillPopScope(
        child: Center(
          child: Column(children: <Widget>[
            SizedBox(
              height: 30,
              width: 100,
            ),
            SizedBox(
              width: 300,
              height: 50,
              child: FloatingActionButton.extended(
                  heroTag: 1,
                  onPressed: () {Navigator.pushNamed(context, '/RequestScreen');},
                  label: Text("Requests"),
                  icon: Icon(Icons.list)),
            ),
            SizedBox(
              height: 130,
              width: 100,
            ),
            FloatingActionButton.extended(
                heroTag: 2,
                onPressed: () {Navigator.pushNamed(context, '/ManagementScreen');},
                label: Text("Management"),
                icon: Icon(Icons.build_outlined)),
            SizedBox(
              height: 130,
              width: 100,
            ),
            FloatingActionButton.extended(
                heroTag: 3,
                onPressed: () {Navigator.pushNamed(context, '/ReportsScreen');},
                label: Text("Reports"),
                icon: Icon(Icons.announcement)),
          ]),
        ),
        onWillPop: onWillPop,
      ),
    );
  }
}
