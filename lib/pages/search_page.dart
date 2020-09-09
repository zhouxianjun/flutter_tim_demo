import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tim_demo/components/common_bar.dart';
import 'package:tim_demo/routers.dart';

typedef AsyncOnSearch<T, P> = Future<T> Function(P value);

Future<T> showASearch<T>(
    {@required BuildContext context, @required SearchPage delegate}) {
  assert(delegate != null);
  return Navigator.of(context).push(MaterialPageRoute(builder: (_) {
    return delegate;
  }));
}

class SearchPage extends StatefulWidget {
  final String placeholder;
  final AsyncOnSearch<Widget, String> onChanged;
  final AsyncOnSearch<Widget, String> onSearch;

  SearchPage(
      {@required this.onSearch, this.placeholder = '搜索', this.onChanged});

  @override
  State<StatefulWidget> createState() {
    return _SearchPage();
  }
}

class _SearchPage extends State<SearchPage> {
  final TextEditingController _queryTextController = TextEditingController();
  Widget body;
  FocusNode _focusNode = FocusNode();

  String get query => _queryTextController.text;
  set query(String value) {
    assert(query != null);
    _queryTextController.text = value;
  }

  Widget renderTextField() {
    return TextField(
      controller: _queryTextController,
      cursorColor: Colors.green,
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: widget.placeholder,
        isDense: true,
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(borderSide: BorderSide.none),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.grey,
        ),
        prefixIconConstraints: BoxConstraints.expand(width: 30, height: 35),
        suffixIcon: AnimatedOpacity(
          opacity: query.isNotEmpty ? 1.0 : 0.0,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOutCubic,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.clear,
              color: Colors.grey,
            ),
            onPressed: () => query = '',
          ),
        ),
        suffixIconConstraints: BoxConstraints.expand(width: 35, height: 35),
      ),
      textInputAction: TextInputAction.search,
      onChanged: (value) async {
        if (widget.onChanged != null) {
          body = await widget.onChanged(value);
        }
        setState(() {});
      },
      onSubmitted: (value) async {
        body = await widget.onSearch(value);
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonBar(
        canBack: false,
        titleWidget: Container(
          child: renderTextField(),
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        ),
        rightDMActions: [
          InkWell(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 10.0),
              child: Text(
                '取消',
                style: TextStyle(color: Colors.blue[300]),
              ),
            ),
            onTap: () {
              _focusNode.unfocus();
              Routers.router.pop(context);
            },
          )
        ],
      ),
      body: body ?? Container(),
    );
  }
}
