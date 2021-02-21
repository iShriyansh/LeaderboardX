import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:game_leaderboard/add_gamescore_data.dart';
import 'package:game_leaderboard/game_leaderboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Leaderboard',
      home: LeaderboardHome(),
      theme: ThemeData.light()
          .copyWith(scaffoldBackgroundColor: Color(0xffF5FAFA)),
    );
  }
}

class LeaderboardHome extends StatefulWidget {
  @override
  _LeaderboardHomeState createState() => _LeaderboardHomeState();
}

class _LeaderboardHomeState extends State<LeaderboardHome> {
  CollectionReference gamerLb;

  @override
  void initState() {
    //getGameData();
    gamerLb = FirebaseFirestore.instance.collection('Gamer_Leaderboard');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Game Leaderboard"),
          actions: [],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Add Score",
          onPressed: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AddGameScore()))
                .then((value) => setState(() => {}));
            ;
          },
          child: Icon(Icons.gamepad),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Container(
            child: StreamBuilder(
                stream: gamerLb.get().asStream(),
                builder: (context, data) {
                  if (data.connectionState == ConnectionState.none) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (data.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (data.connectionState == ConnectionState.done) {
                    var listOfGames = [];
                    QuerySnapshot xxxx = data.data;

                    xxxx.docs.forEach((element) {
                      listOfGames.add(element);
                    });

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            "Games",
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.w400),
                          ),
                        ),
                        GridView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemCount: xxxx.docs.length,
                            itemBuilder: (BuildContext ctx, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GameLeaderBoard(
                                                gameLeaderBoardData:
                                                    listOfGames[index],
                                              )));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  elevation: 0,
                                  child: Container(
                                    height: 100,
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            listOfGames[index].id,
                                            style: TextStyle(
                                                fontSize: 21,
                                                fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ],
                    );
                  } else {
                    return Center(
                        child: Expanded(child: CircularProgressIndicator()));
                  }
                }),
          ),
        ));
  }
}
