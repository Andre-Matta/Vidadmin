import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vidbusters/Provider/SetPharmacy.dart';
import 'package:vidbusters/Provider/Pharmacy.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

String id, status, reason;
String accept_msg =
    "Dear user, \n Thanks for registering in vidbuster,\n You have been accepted.";
String rejected_msg =
    "Dear user, \n Thanks for registering in vidbuster,\n you have been rejected for the following reason -> \n $reason";
String warning_msg =
    "Dear user, \n We notify you that we received several reports stating that ->\n $reason";
String deleted_msg =
    "Dear user, \n We regret to inform you that you have been deleted for the following reason -> \n $reason";

var meds = [
  "",
  'C-Retard',
  'Acetylcysteine',
  'Favipiravir',
  'Hydroxy Chloroquine',
  'Invermectin',
  'Kalertra',
  'Lactoferriene',
  'Remdesivir',
  'Zinc',
];
var d = "";

class RequestDetail extends StatefulWidget {
  static const routeName = '/RequestDetail';

  @override
  _RequestDetailState createState() => _RequestDetailState();
}

class _RequestDetailState extends State<RequestDetail> {
  var markers = HashSet<Marker>();

  @override
  Widget build(BuildContext context) {
    final Id =
        ModalRoute.of(context).settings.arguments as String; // is the id!

    final Pharmacy loadedProduct = Provider.of<SetPharmacy>(
      context,
      listen: false,
    ).findById(Id);
    id = loadedProduct.id;
    loadedProduct.haveDelivery == true ? d = "Avaliable" : d = "Not Avaliable";

    Future<void> sendemail(int i) async {
      String username = "vidbusters21@gmail.com";
      String password = "vidbuster50k";
      print(loadedProduct.email);

      final smtpServer = gmail(username, password);

      // Create our message.
      final message = Message()
        ..from = Address('vidbusters21@gmail.com', 'Vidbusters')
        ..recipients.add(loadedProduct.email)
        ..subject = 'Vidbuster team notification'
        ..text = i == 1
            ? accept_msg
            : i == 2
                ? rejected_msg
                : i == 3
                    ? warning_msg
                    : deleted_msg;

      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 15),
            Container(
              height: 200,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              width: double.infinity,
              child: GestureDetector(
                  child: Image.network(
                    loadedProduct.licenceUrl,
                    fit: BoxFit.fill,
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(

                            backgroundColor: Colors.transparent,
                            content: SizedBox(
                              height: 600,
                              width: 600,
                              child: Image.network(
                                loadedProduct.licenceUrl,
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                        });
                  },
                ),
              ),
            SizedBox(height: 10),
            Container(
                margin: const EdgeInsets.all(10.0),
                height: 300,
                width: double.infinity,
                child: GoogleMap(
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: true,
                  onMapCreated: (GoogleMapController googleMapController) {
                    setState(() {
                      markers.add(
                        Marker(
                          markerId: MarkerId('1'),
                          position:
                              LatLng(loadedProduct.lat, loadedProduct.lng),
                        ),
                      );
                    });
                  },
                  markers: markers,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(loadedProduct.lat, loadedProduct.lng),
                    zoom: 17,
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Container(
                child: Column(children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Delivery: " + d,
                  textAlign: TextAlign.left,
                ),
              )
            ])),
            SizedBox(
              height: 20,
            ),
            Container(
                child: Text(
              "Avaliable Mediciens:",
              textAlign: TextAlign.left,
            )),
            Container(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(10.0),
                itemCount: 10,
                itemBuilder: (ctx, i) {
                  return loadedProduct.avaliableMedicines[i]
                      ? Text(meds[i])
                      : Text(" ");
                },
              ),
            ),
            Container(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (ctx, i) {
                      return Text(
                        "E-mail: " + loadedProduct.email,
                        textAlign: TextAlign.left,
                      );
                    })),
            SizedBox(
              height: 20,
            ),
            FloatingActionButton.extended(
              label: Text('Open Maps',
                  style: TextStyle(fontSize: 20, color: Colors.white70)),
              backgroundColor: Colors.green,
              icon: Icon(Icons.add_location),
              onPressed: () {
                openMap(loadedProduct.lat, loadedProduct.lng);
              },
            ),
            SizedBox(
              height: 10,
            ),
            loadedProduct.status == "Waiting"
                ? FloatingActionButton.extended(
                    label: Text('Accept', style: TextStyle(fontSize: 20)),
                    backgroundColor: Colors.green,
                    icon: Icon(Icons.check),
                    autofocus: true,
                    onPressed: () {
                      sendemail(1);
                      status = "Accepted";
                      Status().then((value) {
                        Navigator.pushNamed(context, '/home');
                      });
                    },
                  )
                : FloatingActionButton.extended(
                    label:
                        Text('Send Warning!!', style: TextStyle(fontSize: 20)),
                    backgroundColor: Color.fromARGB(255, 204, 204, 0),
                    icon: Icon(Icons.warning),
                    onPressed: () {
                      Widget okButton = FlatButton(
                          child: Text("OK"),
                          onPressed: () {
                            sendemail(3);
                            Navigator.pushNamed(context, '/home');
                          });
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(15)),
                                title: Text("Warning!!"),
                                content: TextFormField(
                                  maxLines: 6,
                                  minLines: 1,
                                  onChanged: (value) {
                                    setState(() {
                                      reason = value;
                                    });
                                  },
                                ),
                                actions: [okButton]);
                          });
                    },
                  ),
            SizedBox(
              height: 10,
            ),
            loadedProduct.status == "Waiting"
                ? FloatingActionButton.extended(
                    label: const Text('Reject', style: TextStyle(fontSize: 20)),
                    backgroundColor: Colors.red,
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      Widget okButton = FlatButton(
                          child: Text("OK"),
                          onPressed: () {
                            sendemail(2);
                            status = "Rejected";
                            Status().then((value) {
                              Navigator.pushNamed(context, '/home');
                            });
                            Navigator.of(context).pop();
                          });
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(15)),
                                title: Text("Reject Reason"),
                                content: TextFormField(
                                  maxLines: 6,
                                  minLines: 1,
                                  onChanged: (value) {
                                    setState(() {
                                      reason = value;
                                    });
                                  },
                                ),
                                actions: [okButton]);
                          });
                    },
                  )
                : FloatingActionButton.extended(
                    label: const Text('Delete', style: TextStyle(fontSize: 20)),
                    backgroundColor: Colors.red,
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      Widget okButton = FlatButton(
                          child: Text("OK"),
                          onPressed: () {
                            sendemail(4);
                            status = "Rejected";
                            Status().then((value) {
                              Navigator.pushNamed(context, '/home');
                            });
                            Navigator.of(context).pop();
                          });
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(15)),
                                title: Text("Delete  Reason"),
                                content: TextFormField(
                                  maxLines: 6,
                                  minLines: 1,
                                  onChanged: (value) {
                                    setState(() {
                                      reason = value;
                                    });
                                  },
                                ),
                                actions: [okButton]);
                          });
                    },
                  )
          ],
        ),
      ),
    );
  }

  Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}

Future<void> Status() async {
  final url =
      'https://pharmacies-f20f5-default-rtdb.firebaseio.com/users/$id.json';
  try {
    if (status == "Rejected") {
      final response = await http.patch(
        url,
        body: json.encode({
          'Status': "Rejected",
        }),
      );
      final response1 = await http.delete(url);
    } else {
      final response = await http.patch(
        url,
        body: json.encode({'Status': status}),
      );
    }
  } catch (error) {}
}
