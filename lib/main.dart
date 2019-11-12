import 'package:flutter/material.dart';
import 'dio.dart';

// flutter padding 不计入 height 中


const bold24Rotobo = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Color(0xFF666666));

class Header extends StatelessWidget {
  final Widget action;
  final String title;

  Header({this.action, this.title});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 50,
            child: Icon(Icons.location_on),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: bold24Rotobo,
              ),
            ),
          ),
          Container(child: action, width: 50)
        ],
      ),      
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 1, color: Color.fromRGBO(204, 204, 204, 0.4)))
      ),
      height: 50 + mediaQuery.viewPadding.top,
      padding: EdgeInsets.only(top: mediaQuery.viewPadding.top),
    );
  }
}

class TabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TabButton(
              icon: Icon(Icons.assignment),
              text: Text('订单'),
            ),
            flex: 1,
          ),
          Expanded(
            child: TabButton(
              icon: Icon(Icons.monetization_on),
              text: Text('收入'),
            ),
            flex: 1,
          ),
          Expanded(
            child: TabButton(
              icon: Icon(Icons.date_range),
              text: Text('排班'),
            ),
            flex: 1,
          ),
          Expanded(
            child: TabButton(
              icon: Icon(Icons.person),
              text: Text('个人中心'),
            ),
            flex: 1,
          ),
        ],
      ),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            offset: Offset(0, -2),
            blurRadius: 4)
      ]),
      height: 60 + mediaQuery.viewPadding.bottom,
      padding: EdgeInsets.only(bottom: mediaQuery.viewPadding.bottom),
    );
  }
}

class TabButton extends StatelessWidget {
  final Icon icon;
  final Text text;

  TabButton({this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[icon, text],
    );
  }
}

class IndexPageState extends State<IndexPage> {
  List<Map<String, dynamic>> _orders = [];

  void query() async {
    var response = await dio.get('/orders', queryParameters: {
      'filter': {
        'except_statuses': [9, -1, -2]
      },
      'pageinfo': {
        'limit': 100
      }
    });

    print(response.data);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: <Widget>[
            Header(
              action: GestureDetector(child: Icon(Icons.refresh), onTap: query,),
              title: '订单',
            ),
            Expanded(
              child: Text('Wang Yang'),
            ),
            TabBar()
          ],
        ),
        color: Color.fromRGBO(239, 244, 250, 1));
  }
}

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexPageState();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: alice.getNavigatorKey(),
      home: Scaffold(
        body: IndexPage(),
      ),
    );
  }
}

void main() => runApp(MyApp());
