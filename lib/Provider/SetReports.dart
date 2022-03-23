import 'package:flutter/cupertino.dart';
import 'package:vidbusters/Provider/Report.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vidbusters/Screens/Reports.dart';


class SetReports with ChangeNotifier {
  List<Report> Reports = [];

  List<Report> get items {
    return [...Reports];
  }

  Report findById(String id) {
    return Reports.firstWhere((prod) => prod.id == id);
  }

  Future<bool> fetchAndSetReports() async {
    const url =
        'https://pharmacies-f20f5-default-rtdb.firebaseio.com/reports.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<dynamic, dynamic>;
      final List<Report> loadedReports = [];

      extractedData.forEach((prodId, prodData) async {
        loadedReports.add(Report(
            id: prodId,
            msg: prodData['report'],
            name: prodData['pharmacyname'],
            img: prodData['img']
        ));
      });


      Reports = loadedReports;
      notifyListeners();
    return false;
    }
    catch (error) {
      return true;
      throw (error);
    }
  }
}