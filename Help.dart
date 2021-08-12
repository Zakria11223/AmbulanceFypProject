import 'package:flutter/material.dart';

class Policy extends StatefulWidget {
  @override
  _PolicyState createState() => _PolicyState();
}

class _PolicyState extends State<Policy> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 25.5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back_ios_outlined),
                        SizedBox(
                          width: 95.2,
                        ),
                        Text(
                          'Privacy Policy',
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        SizedBox(
                          width: 65,
                        ),
                        IconButton(
                            icon: Icon(Icons.more_vert_outlined), onPressed: () {}),
                      ],
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    Text(
                      'Terms & Conditions',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      height: 15.40,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Unique Positioning Statement: Navigate any city like a local with '
                                    'PORTFOLIO, America’s virtual concierge'
                                    'service. PORTFOLIO '
                                    'takes'
                                    '    the guesswork out of travel, whether it’s a vacation or'
                                    'staycation, everything you need to know about any major U.S. city'
                                    'is at your fingertips.',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'From sports, entertainment, dining, and weather, to secret'
                                    "locals-only spots and real insider advice on virtually any "
                                    "subject PORTFOLIO "
                                    "has it all. Why use multiple apps that can only give youbasic information?",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'PORTFOLIO is curated by city experts to provide the best, '
                                    'most up-to-date and complete bundle of resources you’ll ever need to'
                                    ' make you feel at home – no matter where you are. ',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),

                    SizedBox(
                      height: 35.40,
                    ),

                    Text(
                      'Agreements',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),

                    SizedBox(
                      height: 15.40,
                    ),

                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(





                              child: Text(
                                ' Unique Positioning Statement: Navigate any city like a local with PORTFOLIO, America’s virtual concierge service. PORTFOLIO takes the'
                                    ' guesswork out of travel, '
                                    'whether it’s a vacation or '
                                    'staycation, everything you need '
                                    'to know about any major U.S. city'
                                    ' is at your fingertips.',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'From sports, entertainment, dining, and weather, to secret'
                                    "locals-only spots and real insider advice on virtually any "
                                    "subject PORTFOLIO "
                                    "has it all. Why use multiple apps that can only give youbasic information?",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'From sports, entertainment, dining, and weather, to secret "locals-only"spots '
                                    'and real insider advice on '
                                    'virtually any subject, PORTFOLIO '
                                    'has it all. Why use multiple apps that'
                                    ' can only give you basic information?',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),

                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
