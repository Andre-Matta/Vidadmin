import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';


class Report with ChangeNotifier
{
  final String id;
  final String msg;
  final String name;
  final String img;

  Report ({this.id,this.msg, this.name, this.img});

}