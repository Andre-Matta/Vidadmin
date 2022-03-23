import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class Pharmacy with ChangeNotifier {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final String licenceUrl;
  final String status;
  final String email;
  var avaliableMedicines = new List(10);
  final double lat;
  final double lng;
  bool haveDelivery = false ;
  Pharmacy(
      {
        this.status,
        this.id,
        this.name,
        this.email,
        this.location,
        this.imageUrl,
        this.avaliableMedicines,
        this.lat,
        this.lng,
        this.licenceUrl,
        this.haveDelivery});
}