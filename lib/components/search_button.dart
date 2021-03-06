import 'package:flutter/material.dart';
import 'package:tim_demo/dto/friend_index_dto.dart';
import 'package:tim_demo/generated/i18n.dart';
import 'package:tim_demo/styles/index.dart';

class SearchButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  SearchButton({this.text, this.callback});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.callback,
      child: Container(
          color: AppColors.appBarColor,
          height: 60.0,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.search,
                  color: AppColors.lineColor,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(text ?? S.of(context).search,
                    style:
                        TextStyle(color: AppColors.lineColor, fontSize: 18.0))
              ],
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0)),
    );
  }
}
