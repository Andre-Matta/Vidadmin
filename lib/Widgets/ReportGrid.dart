import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vidbusters/Provider/SetReports.dart';
import 'package:vidbusters/Widgets/ReportItem.dart';

class ReportsGrid extends StatefulWidget {
  @override
  _ReportsGridState createState() => _ReportsGridState();
}

class _ReportsGridState extends State<ReportsGrid> {
  @override
  Widget build(BuildContext context) {

    final ReportsData = Provider.of<SetReports>(context);
    final reports = ReportsData.items;

    return Container(
      child: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: reports.length,
        itemBuilder: (ctx, i) {
          return ChangeNotifierProvider.value(
            value: reports[i],
            child: ReportsItems(),
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