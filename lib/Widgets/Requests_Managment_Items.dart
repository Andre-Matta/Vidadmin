import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vidbusters/Provider/SetPharmacy.dart';
import 'package:vidbusters/Provider/Pharmacy.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vidbusters/Screens/RequestsDetail.dart';

class Requests_Managment_Items extends StatefulWidget {
  @override
  _Requests_Managment_ItemsState createState() => _Requests_Managment_ItemsState();
}

class _Requests_Managment_ItemsState extends State<Requests_Managment_Items> {
  @override
  Widget build(BuildContext context) {
    final pharmacy = Provider.of<Pharmacy>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              RequestDetail.routeName,
              arguments: pharmacy.id,
            );
          },
          child: Image.network(
            pharmacy.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            pharmacy.name,
          ),
        ),
      ),
    );
  }
}
