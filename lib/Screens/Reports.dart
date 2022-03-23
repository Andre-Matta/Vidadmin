import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vidbusters/Provider/SetReports.dart';
import 'package:vidbusters/Widgets/ReportGrid.dart';


class Reports extends StatefulWidget {
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {

  var _isLoading = true;
  var _isEmpty = false;
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
      Provider.of<SetReports>(context).fetchAndSetReports().then((i) {
        setState(() {
          if (i)
          {
            _isLoading = false;
            _isEmpty = true;
          }
          else{
            _isLoading = false;
            _isEmpty = false;
          }
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
      body:  _isLoading && !_isEmpty
      ? Center(
    child: CircularProgressIndicator(),
    )
        :  !_isLoading && !_isEmpty
    ? ReportsGrid() : Center(
    child: Text("There is no Reports!!"),
    ),
    );
  }


}


