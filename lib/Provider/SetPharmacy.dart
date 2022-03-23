import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'dart:math';
import 'package:vidbusters/Provider/Pharmacy.dart';

class SetPharmacy with ChangeNotifier {
  List<Pharmacy> pharmacies = [];

  List<Pharmacy> get items {
    return [...pharmacies];
  }

  Pharmacy findById(String id) {
    return pharmacies.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetPharmacies(String status) async {
    final locData = await Location().getLocation();
    const url =
        'https://pharmacies-f20f5-default-rtdb.firebaseio.com/users.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<dynamic, dynamic>;
      final List<Pharmacy> loadedProducts = [];

      extractedData.forEach((prodId, prodData) async {
        if (prodData['Status'] == status) {
          loadedProducts.add(Pharmacy(
            id: prodId,
            status: prodData['Status'],
            name: prodData['pharmacyname'],
            email: prodData['email'],
            imageUrl: prodData['pharmacyimage'],
            licenceUrl: prodData['licenseimage'],
            avaliableMedicines: prodData['avaliableMedicines'],
            lat: prodData['lat'],
            lng: prodData['lng'],
            haveDelivery: prodData['haveDelivery'],
          ));
        }
      });

      pharmacies = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

}
