import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String name;
  final String date;
  final String amount;

  CustomCard({
    required this.title,
    required this.name,
    required this.date,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black45,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            title == "Outgoing"
                ? Icon(
                    Icons.arrow_upward,
                    color: Colors.red,
                  )
                : Icon(
                    Icons.arrow_downward,
                    color: Colors.green,
                  ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 8.0),
                Text(
                  '${amount}',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
