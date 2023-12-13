import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/pages/community/logic/fetch_forum.dart';

class CommunityOne extends StatelessWidget {
  final String forumId;
  CommunityOne({super.key, required this.forumId});

  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    var forumData = fetchForum(forumId);
    print(forumData);
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder<Forum>(
            future: fetchForum(forumId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Text('No data available');
              } else {
                Forum forum = snapshot.data!;
                Timestamp time = forum.date;
                String dateTime =
                    DateFormat('dd MM yyyy').format(time.toDate().toLocal());

                return Column(
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
                                  SizedBox(height: 160),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration:
                                        BoxDecoration(color: Color(0xffFF822B)),
                                    child: Text(
                                      forum.category,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    forum.title,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  )
                                ]),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(forum.creator),
                                  SizedBox(height: 4),
                                  Text(forum.certification),
                                  SizedBox(height: 4),
                                  Text('Created on $dateTime'),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 30),
                          ForumTab(),
                        ],
                      ),
                    )
                  ],
                );
              }
            }));
  }
}

class ForumTab extends StatefulWidget {
  const ForumTab({super.key});

  @override
  State<ForumTab> createState() => _ForumTabState();
}

class _ForumTabState extends State<ForumTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      child: Column(
        children: [
          Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: TabBar(
                controller: _tabController,
                unselectedLabelColor: Color(0xff999999),
                labelColor: Color(0xffFF822B),
                indicatorColor: Color(0xffFF822B),
                isScrollable: true,
                tabs: <Widget>[
                  Text('Instructions'),
                  Text('Members'),
                  Text('About group'),
                  Text('Message Admin')
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(child: InstructionTab()),
                Container(child: Members()),
                Container(child: AboutTab()),
                Container(child: MessageAdmin()),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class InstructionTab extends StatelessWidget {
  const InstructionTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 30,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(color: Color(0xffF3F3F1)),
                child: Text(
                  'Confidentiality',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
              SizedBox(height: 4),
              Text(
                  'Respect the confidentiality of all financial and accounting information shared within the management accounting group. Do not disclose or discuss sensitive data with unauthorized individuals.'),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 30,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(color: Color(0xffF3F3F1)),
                child: Text(
                  'Ethical Conduct',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
              SizedBox(height: 4),
              Text(
                  'Adhere to high ethical standards in all financial activities and interactions. Avoid engaging in any fraudulent, deceptive, or unethical practices'),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0))),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => CommunityListUi()),
                  // );
                },
                child: Text('JOIN GROUP NOW'),
              )
            ],
          ),
        ));
  }
}

class Members extends StatelessWidget {
  const Members({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const Text('NO MEMBERS'));
  }
}

class AboutTab extends StatelessWidget {
  const AboutTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                  'Respect the confidentiality of all financial and accounting information shared within the management accounting group. Do not disclose or discuss sensitive data with unauthorized individuals. '),
              SizedBox(height: 20),
              Text(
                  'Management accounting is a branch of accounting that involves the process of collecting, analyzing, and interpreting financial and non-financial information to aid in managerial decision-making, planning, and control within an organization.'),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0))),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => CommunityListUi()),
                  // );
                },
                child: Text('JOIN GROUP NOW'),
              )
            ],
          ),
        ));
  }
}

class MessageAdmin extends StatelessWidget {
  const MessageAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const Text('Building...'));
  }
}
