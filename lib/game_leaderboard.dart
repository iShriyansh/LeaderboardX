import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GameLeaderBoard extends StatefulWidget {
  final gameLeaderBoardData;

  const GameLeaderBoard({Key key, this.gameLeaderBoardData}) : super(key: key);

  @override
  _GameLeaderBoardState createState() => _GameLeaderBoardState();
}

class _GameLeaderBoardState extends State<GameLeaderBoard> {
  var leaderboardData = [];
  String formatted;
  @override
  void initState() {
    // TODO: implement initState
    Map gameData = widget.gameLeaderBoardData.data();
    gameData.forEach((key, value) {
      for (int i = 0; i < value["score"].length; i++) {
        leaderboardData.add([key, value["score"][i], value["timestamp"]]);
      }
    });

    leaderboardData.sort((a, b) => b[1].compareTo(a[1]));

    super.initState();
  }

  TextStyle rankTextStyle(int rank) {
    if (rank < 3) {
      return TextStyle(color: Colors.green, fontSize: 20);
    } else if (rank >= 3 && rank < 7) {
      return TextStyle(color: Colors.yellow, fontSize: 20);
    } else {
      return TextStyle(color: Colors.orange, fontSize: 20);
    }
  }

  String dateFormatter(Timestamp stamp) {
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    formatted = formatter.format(stamp.toDate());
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Color(0xffF5FAFA),
      appBar: AppBar(
        title: Text(widget.gameLeaderBoardData.id.toString().toUpperCase()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Gamers\nLeaderboard",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: leaderboardData.length < 10
                        ? leaderboardData.length
                        : 10,
                    itemBuilder: (BuildContext ctx, index) {
                      return Container(
                        height: 100,
                        width: double.infinity,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  elevation: 0,
                                  child: Container(
                                    height: 100,
                                    width: 30,
                                    child: Text((index + 1).toString(),
                                        style: rankTextStyle(index)),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          leaderboardData[index][0],
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                          maxLines: 2,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        dateFormatter(
                                            leaderboardData[index][2]),
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ))
                                  ],
                                ),
                                Expanded(
                                  child: Container(
                                    height: 200,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(13.0),
                                          child: Text(
                                            leaderboardData[index][1]
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
