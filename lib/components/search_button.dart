import 'package:flutter/material.dart';
import 'package:tim_demo/generated/i18n.dart';
import 'package:tim_demo/styles/index.dart';

class SearchButton extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Container(
            color: AppColors.appBarColor,
            height: 60.0,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    color: Colors.white
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Icon(Icons.search, color: AppColors.lineColor,),
                        SizedBox(
                            width: 8.0,
                        ),
                        Text(S.of(context).search,
                            style: TextStyle(
                                color: AppColors.lineColor,
                                fontSize: 18.0
                            )
                        )
                    ],
                ),
            ),
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0)
        );
    }
}