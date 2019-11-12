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
          border: Border(
              bottom: BorderSide(
                  width: 1, color: Color.fromRGBO(204, 204, 204, 0.4)))),
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

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  OrderCard({this.order});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Container(
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(212, 226, 244, 0.58),
                  offset: Offset(0, 2),
                  blurRadius: 10,
                  spreadRadius: 0)
            ]),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  '派送中',
                  style: TextStyle(
                      color: Color(0xFF1cb9b6),
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text('订单 ${order['sn']}',
                        style: TextStyle(fontSize: 15)),
                  ),
                ),
                Text(
                  '${order['shipping_distance']} km',
                  style: TextStyle(fontSize: 15, color: Color(0xFF4083ec)),
                )
              ],
            ),
            Container(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.store,
                    color: Color(0xff09b7fb),
                  ),
                  margin: EdgeInsets.only(right: 10),
                ),
                Expanded(child:  Text(
                  order['restaurant']['name'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  softWrap: true,
                ),)
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.face,
                    color: Color(0xfff5a623),
                  ),
                  margin: EdgeInsets.only(right: 10),
                ),
                Expanded(
                  child: Text(
                    order['address'],
                    style: TextStyle(fontSize: 18),
                    softWrap: true,
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text('下单时间 ${order['created_at']}'),
                Text('|'),
                Text(
                    '送达时间 ${order['appointed_at']} - ${order['appointed_end']}')
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class IndexPageState extends State<IndexPage> {
  List<dynamic> orders = [];

  void query() async {
    var response = await dio.get('/orders', queryParameters: {
      'filter': {
        'except_statuses': [9, -1, -2]
      },
      'pageinfo': {'limit': 100}
    });

    setState(() {
      orders = response.data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    query();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: <Widget>[
            Header(
              action: GestureDetector(
                child: Icon(Icons.refresh),
                onTap: query,
              ),
              title: '订单',
            ),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, i) {
                    return OrderCard(order: orders[i]);
                  },
                  separatorBuilder: (context, i) {
                    return Container(height: 15);
                  },
                  itemCount: orders.length),
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
