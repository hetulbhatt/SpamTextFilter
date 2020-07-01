import 'package:flutter/material.dart';
import 'package:sms/sms.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'SMS SPAM FILTER'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  List<SmsMessage> messages;
  SmsQuery query;
  String res;
  
  //Read messages from INBOX
  Future<void> fun() async {
    query = new SmsQuery();
    messages = await query.getAllSms;
  }

  
  //Predict SPAM or HAM
  String predict(String s) {
    String res;
    http.get('https://585a1ec7.ngrok.io/?msg='+s).then((x) {
      res = x.body;
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    
	this.fun();
    
	return Scaffold(
      appBar: AppBar(
        
		title: Text(widget.title),
        actions: <Widget>[new Icon(Icons.more_vert)],
      ),
      body: new ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, i) => new Column(
          children: <Widget>[
            new Divider(
              height: 10.0,
            ),
            new ListTile(
              leading: Icon(
                Icons.account_circle,
                size: 50,
              ),
              title: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                    messages[i].sender,
                    style: new TextStyle(fontWeight: FontWeight.bold),
                  ),
                  new Text(
                    messages[i].dateSent.toString(),
                    style: new TextStyle(color: Colors.grey, fontSize: 14.0),
                  )
                ],
              ),
              subtitle: new Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: new Text(
                    check(messages[i].body).toString(),
                    maxLines: 1,
                  )),
			  trailing:Text(check(messages[index].body)),
            )
          ],
        ),
      ),
    );
  }
}













