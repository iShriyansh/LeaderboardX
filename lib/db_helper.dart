import 'package:cloud_firestore/cloud_firestore.dart';

class DbHelper{

  
  Future<CollectionReference> getGlRef() async {
      // Call the user's CollectionReference to add a new user
       CollectionReference gamerLeaderBoard = await  FirebaseFirestore.instance.collection('Gamer_Leaderboard');
          // users.add({
          //   'full_name': "Fdf", // John Doe
          //   'company': "DdF", // Stokes and Sons
          //   'age': 2323 // 42
          // })
          // .then((value) => print("User Added"))
          // .catchError((error) => print("Failed to add user: $error"));
        gamerLeaderBoard.doc("coc").get();
          return gamerLeaderBoard;
    }





}