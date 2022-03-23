import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vidbusters/Provider/Report.dart';
import 'package:http/http.dart' as http;

class ReportsItems extends StatefulWidget {
  @override
  _ReportsItemsState createState() => _ReportsItemsState();
}

class _ReportsItemsState extends State<ReportsItems> {
  String id ;

  @override
  Widget build(BuildContext context) {
    final report = Provider.of<Report>(context, listen: false);


    return ClipRRect(

      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Widget saveButton = FlatButton(
                child: Text("save"),
                onPressed: () {
                  Navigator.of(context).pop();
                });
            Widget deleteButton = FlatButton(
                child: Text("delete"),
                onPressed: () {
                  id = report.id;
               Report_handling().then((value){
                 Navigator.pushNamed(context, '/ReportsScreen');
                 }
               );
                });
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          new BorderRadius.circular(15)),
                      title: Text("Report"),
                      content: Text(report.msg),
                      actions: [saveButton, deleteButton]);
                });
          },
          child: Image.network(
            report.img,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            report.name,
          ),
        ),
      ),
    );
  }

  Future<void> Report_handling() async {
    final url =
        'https://pharmacies-f20f5-default-rtdb.firebaseio.com/reports/$id.json';
    try {
      final response = await http.delete(url);
    } catch (error) {

    }
  }
}
