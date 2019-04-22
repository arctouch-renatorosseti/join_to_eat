import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListSchedules extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> items = ["100","200","800","1.2"];

    return Scaffold(
      backgroundColor: Colors.white70,
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext _context, int i) {
            return _buildRow(items[i]);
          }
    ),
    );
  }

  Widget _buildRow(String text) {
    return Card(
      semanticContainer: true,
      color: Colors.white,
      clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: IconButton(
                icon: Icon(Icons.location_on, size: 30),
                tooltip: 'Increase volume by 10',
                onPressed: () {

                },
              ),
            ),
            Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text("Almoço com Renato às 12:00h", style: TextStyle(color: Colors.grey, fontSize: 16)),
                      Text("Local: No 4 estações.", style: TextStyle(color: Colors.grey, fontSize: 16))
                    ]

                )
            )
          ],
        ),
        
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: EdgeInsets.all(10),
    );
  }
}