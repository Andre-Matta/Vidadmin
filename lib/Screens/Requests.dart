import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vidbusters/Provider/SetPharmacy.dart';
import 'package:vidbusters/Widgets/Requests_Managment_Grid.dart';



class Requests extends StatefulWidget {
  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  var _isLoading = true;
  var _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<SetPharmacy>(context).fetchAndSetPharmacies("Waiting").then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pharmacies'),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          :
          Requests_Managment_Grid()
    );
  }
}