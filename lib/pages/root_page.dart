import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Container(
                child: Text(
                    'root page'
                ),
            ),
        );
    }
}

class LoadImage extends StatelessWidget {
    final String img;

    LoadImage(this.img);

    @override
    Widget build(BuildContext context) {
        return Container(
            margin: EdgeInsets.only(bottom: 2.0),
            child: Image.asset(img, fit: BoxFit.cover, gaplessPlayback: true)
        );
    }
}