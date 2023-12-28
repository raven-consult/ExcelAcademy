import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class QuestionOne extends StatelessWidget {
  final String forumName;
  final String question;
  final String questionId;
  final String forumId;

  const QuestionOne(
      {super.key,
      required this.forumName,
      required this.question,
      required this.questionId,
      required this.forumId});

  @override
  Widget build(BuildContext context) {
    var answerQuery = FirebaseFirestore.instance
        .collection('forum/$forumId/questions/$questionId/answers');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          forumName,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset('assets/pages/community/bg.jpg'),
              Container(
                  child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 140),
                      Container(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            question,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          )),
                    ]),
              ))
            ],
          ),
          SizedBox(height: 20),
          Container(
            height: 400,
            child: FirestoreListView(
                query: answerQuery,
                itemBuilder: (context, snapshot) {
                  Map<String, dynamic> answer = snapshot.data();

                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                        decoration: BoxDecoration(color: Colors.grey[100]),
                        padding: EdgeInsets.all(20),
                        child: Text(
                          answer['answer'],
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14),
                        )),
                  );
                }),
          )
        ],
      ),
    );
  }
}
