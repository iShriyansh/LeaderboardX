import 'dart:math' as m;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_leaderboard/db_helper.dart';

class AddGameScore extends StatefulWidget {
  @override
  _AddGameScoreState createState() => _AddGameScoreState();
}

TextEditingController edtGameName = TextEditingController();
TextEditingController edtGamerUserName = TextEditingController();
TextEditingController edtScore = TextEditingController();

class _AddGameScoreState extends State<AddGameScore> {
  final _addScoreFormKey = GlobalKey<FormState>();
  DbHelper dbHelper = DbHelper();
  Future<CollectionReference> glRef;

  @override
  void initState() {
    // TODO: implement initState
    glRef = dbHelper.getGlRef();
    super.initState();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Add Game Score")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Form(
            key: _addScoreFormKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: edtGameName,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                        labelText: "Game Name"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter Game Name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: edtGamerUserName,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                        labelText: "Gamer User Name"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter user name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
                    ],
                    keyboardType: TextInputType.number,
                    controller: edtScore,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                        labelText: "Score"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter score";
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    height: 40,
                    minWidth: double.infinity,
                    color: Colors.blue,
                    onPressed: () async {
                      if (_addScoreFormKey.currentState.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        final snackBar =
                            SnackBar(content: Text('Saving data...'));
                        _scaffoldKey.currentState.showSnackBar(snackBar);

                        await addDataToFirestore();
                      }
                    },
                    child: Text(
                      "Add Score To Leaderboard",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSuccessSnkbar() {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    final snackBar = SnackBar(content: Text('Data Saved Successfully'));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<String> addDataToFirestore() async {
    //check user score is greter then the  existing scores in db if users are more then 10

    String gameName = edtGameName.text;
    String userName = edtGamerUserName.text.toString();
    int scorex = int.parse(edtScore.text);
    CollectionReference gamerLb =
        FirebaseFirestore.instance.collection('Gamer_Leaderboard');

    Map gamersScore;

    await gamerLb.doc(gameName).get().then((value) {
      gamersScore = value.data();
      print(gamersScore);
    });

    print(gamersScore);

    int scoreLength = 0;

    if (gamersScore != null) {
      gamersScore.forEach((key, value) async {
        for (int i = 0; i < value["score"].length; i++) {
          scoreLength = scoreLength + 1;
        }
      });
    }

    print(scoreLength);

    DateTime timestamp = DateTime.now();

    if (scoreLength < 10) {
      await gamerLb.doc(gameName).set({
        userName: {
          "score": FieldValue.arrayUnion([scorex]),
          "timestamp": timestamp
        }
      }, SetOptions(merge: true)).whenComplete(() => showSuccessSnkbar());
    } else {
      List name = [];
      List score = [];

      gamersScore.forEach((key, value) async {
        for (int i = 0; i < value["score"].length; i++) {
          name.add(key);
          score.add(value["score"][i]);
        }
      });

      List temp = score;
      temp.sort();
      int minvalue = temp[0];
      int minvalueindex = score.indexOf(minvalue);
      print(temp);

      if (minvalue < scorex) {
        await gamerLb.doc(gameName).set({
          userName: {
            "score": FieldValue.arrayUnion([scorex]),
            "timestamp": timestamp
          }
        }, SetOptions(merge: true)).whenComplete(() {
          showSuccessSnkbar();
        });
      }
    }
  }
}
