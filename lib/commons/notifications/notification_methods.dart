import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

void registerOnFirebase() {
  _firebaseMessaging.subscribeToTopic('course');
  _firebaseMessaging
      .getToken()
      .then((token) => print('this is token: ' + token));
}

void getMessage(BuildContext context) {
  _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) async {
    print('Messsage here: $message');
    // int msgJobId = int.parse(message["data"]["jobId"]);
    String msgBody = message["notification"]["body"];
    String msgTitle = message["notification"]["title"];
    // String msgJobImage = message["data"]["jobImage"];
    showDialog(
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Column(
                  children: <Widget>[
                    // Container(
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(12.0),
                    //     child: Image.asset(
                    //       msgJobImage,
                    //       height: 120,
                    //       width: 50,
                    //     ),
                    //   ),
                    //   width: double.infinity,
                    //   decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       shape: BoxShape.rectangle,
                    //       borderRadius: BorderRadius.only(
                    //           topLeft: Radius.circular(12),
                    //           topRight: Radius.circular(12))),
                    // ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      msgTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      msgBody,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    RaisedButton(
                      onPressed: () {},
                      child: Text('Check it now!'),
                      color: Colors.white,
                      textColor: Colors.black,
                    )
                  ],
                ),
              ),
            ));
  }, onResume: (Map<String, dynamic> message) async {
    print('on resume $message');
  }, onLaunch: (Map<String, dynamic> message) async {
    print('on launch $message');
  });
}
