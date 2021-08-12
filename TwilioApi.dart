import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:get/get.dart';


class Twilio extends StatefulWidget {
  Twilio({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TwilioState createState() => _TwilioState();
}

class _TwilioState extends State<Twilio> {
  TwilioFlutter twilioFlutter;

  @override
  void initState() {
    twilioFlutter = TwilioFlutter(
        accountSid: 'ACf86377ed992d82416b6bd9c9128e08b4',
        authToken: 'a17f87038f2e2ae3be701fdf80335c54',
        twilioNumber: '+14242342686');

    super.initState();
  }

  void sendSms() async {
    twilioFlutter.sendSMS(
        toNumber: '+923068061710',
        messageBody: 'Ambulance arrived Thanks For Your Service');
  }

  void secondSms() async {
    twilioFlutter.sendSMS(
        toNumber: '+923068061710',
        messageBody: 'Ambulance not arrived due to unavoidable reason');
  }

  void getSms() async {
    var data = await twilioFlutter.getSmsList();
    print(data);

    await twilioFlutter.getSMS('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Center(child: Text('Ambulance Respones')),
      ),
      body: Container(
        child: Column(children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20),
                child: Text(
                  '1) Click Red Button If Ambulance Arrived',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Signatra',
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Divider(
                  thickness: 3,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 35, vertical: 35),
                child: Text(
                  '2) For Complaint Click Black Button If Ambulance Not Arrived',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Signatra',
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Divider(
                  color: Colors.black,
                  thickness: 3,
                ),
              ),
            ],
          ),
        ]),
      ),
      floatingActionButton: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: MaterialButton(
                  height: 100,
                  highlightColor: Colors.red,
                  color: Colors.white,
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Message Send',
                      content: Text(
                          'Dear user your message Send to Rescue1122 Headquater'),
                      backgroundColor: Colors.yellow,
                      confirmTextColor: Colors.white,
                      onCancel: () {},
                      barrierDismissible: false,
                    );
                  },
                  child: FloatingActionButton(
                    backgroundColor: Colors.red[900],
                    onPressed: sendSms,
                    tooltip: 'Send Sms',
                    child: Icon(Icons.send),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 400, bottom: 200, left: 20, right: 20),
                child: VerticalDivider(
                  thickness: 3,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: MaterialButton(
                  height: 100,
                  highlightColor: Colors.red,
                  color: Colors.white,
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Message Send',
                      content: Text(
                          'Dear user your message Send to Rescue1122 Headquater'),
                      backgroundColor: Colors.yellow,
                      confirmTextColor: Colors.white,
                      onCancel: () {},
                      barrierDismissible: false,
                    );
                  },
                  child: FloatingActionButton(
                    backgroundColor: Colors.black,
                    onPressed: secondSms,
                    tooltip: 'Send Sms',
                    child: Icon(Icons.send),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

