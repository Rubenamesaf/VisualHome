import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class realtime_db extends StatefulWidget {
  @override
  _realtime_dbState createState() => _realtime_dbState();
}

class _realtime_dbState extends State<realtime_db> {
  late DatabaseReference _dbref;
  String databasejson = "";
  int countvalue = 7;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // ignore: deprecated_member_use
    _dbref = FirebaseDatabase.instance.reference();

    _dbref.child("").child("").onValue.listen((DatabaseEvent event) {
      print("counter update " + event.snapshot.value.toString());
      setState(() {
        //countvalue = event.snapshot.value as int;
        print("klk");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text(countvalue.toString() + " database - " + databasejson),
              ),
              TextButton(
                  onPressed: () {
                    _createDB();
                  },
                  child: Text(" create DB")),
              TextButton(
                  onPressed: () {
                    _realdb_once();
                  },
                  child: Text(" read value")),
              TextButton(
                  onPressed: () {
                    _readdb_onechild();
                  },
                  child: Text(" read once child")),
              TextButton(
                  onPressed: () {
                    _updatevalue();
                  },
                  child: Text(" update value")),
              TextButton(
                  onPressed: () {
                    _updatevalue_count();
                  },
                  child: Text(" update counter value by 1")),
              //   _updatevalue_count()
              TextButton(
                  onPressed: () {
                    _delete();
                  },
                  child: Text(" delete value")),
            ],
          ),
        ),
      ),
    );
  }

  _createDB() {
    _dbref.child("Vivienda 2").set({
      'Timbre': 0,
      "TelefonoFijo": 0,
      'RuidoAlto': 0,
      "PresenciaPuerta": 0,
      'Perimetro': 0,
      "Incendrio": 0,
      'DisparoAlarma': 0,
      "Despertador": 0,
      'BotonPanico': 0,
      "ActivacionAlarma": 0,
      'Acceso': 0
    });
  }

  _realdb_once() {
    _dbref.once().then((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        print(" read once - " + dataSnapshot.value.toString());
        setState(() {
          databasejson = dataSnapshot.value.toString();
        });
      }
    });
  }

  _readdb_onechild() {
    _dbref
        .child("Vivienda 1")
        .child("BotonPanico")
        .once()
        .then((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        print(" read once - " + dataSnapshot.value.toString());
        setState(() {
          databasejson = dataSnapshot.value.toString();
        });
      }
    });
  }

  _updatevalue() {
    _dbref.child("Vivienda 1").update({"Timbre": 2});
  }

  _updatevalue_count() {
    _dbref.child("Vivienda 2").update({"Acceso": 2});
  }

  _delete() {
    _dbref.child("profile").remove();
  }
}
