import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vidbusters/Provider/SetPharmacy.dart';
import 'package:vidbusters/Widgets/Requests_Managment_Items.dart';

class Requests_Managment_Grid extends StatefulWidget {
  @override
  _Requests_Managment_GridState createState() => _Requests_Managment_GridState();
}

class _Requests_Managment_GridState extends State<Requests_Managment_Grid> {
  @override
  Widget build(BuildContext context) {

    final productsData = Provider.of<SetPharmacy>(context);
    final pharmacies = productsData.items;



    return Container(
    child: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: pharmacies.length,
        itemBuilder: (ctx, i) {
          return ChangeNotifierProvider.value(
            value: pharmacies[i],
            child: Requests_Managment_Items(),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}