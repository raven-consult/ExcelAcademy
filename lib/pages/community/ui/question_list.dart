import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/pages/community/ui/questionone.dart';

class QuestionList extends StatelessWidget {
  final String forumId;
  final String forumName;
  const QuestionList(
      {super.key, required this.forumId, required this.forumName});

  @override
  Widget build(BuildContext context) {
    var questionQuery =
        FirebaseFirestore.instance.collection('forum/$forumId/questions');
    TextEditingController _textEditingController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
          title: Text(
        forumName,
        style: TextStyle(fontSize: 20),
      )),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffD6D6D6), width: 1),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      labelText: 'Find Topics',
                      labelStyle: TextStyle(color: Color(0xff767676)),
                      prefixIcon: Icon(Icons.search,
                          color: Color(0xff767676)), // Icon to the left
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Handle the search button action
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    color: Colors.transparent, // Background color of the button
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: Color(0xffFF822B), // Text color of the button
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          Container(
              height: 600,
              child: FirestoreListView<Map<String, dynamic>>(
                  query: questionQuery,
                  itemBuilder: (context, snapshot) {
                    Map<String, dynamic> question = snapshot.data();

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return QuestionOne(
                            forumName: forumName,
                            question: question['question'],
                            questionId: snapshot.id,
                            forumId: forumId,
                          );
                        }));
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Color(0xffF3F3F1)),
                        child: Text(
                          question['question'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w800),
                        ),
                      ),
                    );
                  }))
        ]),
      ),
    );
  }
}
