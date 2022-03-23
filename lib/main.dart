import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:vidbusters/Provider/SetReports.dart';
import 'package:vidbusters/Screens/Home.dart';
import 'package:flutter/material.dart';
import 'package:vidbusters/Screens/Management.dart';
import 'package:vidbusters/Screens/Reports.dart';
import 'package:vidbusters/Screens/Requests.dart';
import 'package:vidbusters/Screens/RequestsDetail.dart';
import 'package:vidbusters/Screens/starting.dart';
import 'package:vidbusters/Provider/SetPharmacy.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
       ChangeNotifierProvider.value(
          value: SetPharmacy(),
        ),
        ChangeNotifierProvider.value(
          value: SetReports(),
        ),
      ],

      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.green,
              ),
        routes: {
        '/': (context) => Starting(),
        '/home': (context) => Home(),
        '/RequestScreen': (context) => Requests(),
        '/ReportsScreen': (context) => Reports(),
        '/ManagementScreen': (context) => Managment(),
        RequestDetail.routeName: (ctx) => RequestDetail(),


        }  ,
      ),
    );
  }
}
