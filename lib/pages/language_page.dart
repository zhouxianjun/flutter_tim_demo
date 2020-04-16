import 'package:tim_demo/components/common_bar.dart';
import 'package:tim_demo/dto/language_dto.dart';
import 'package:tim_demo/generated/i18n.dart';
import 'package:tim_demo/store/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguagePage extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
    AppStore appStore;
    final List<LanguageDTO> languageData = [
        LanguageDTO("中文", "zh", "CN"),
        LanguageDTO("English", "en", ""),
    ];

    @override
    void didChangeDependencies() {
        super.didChangeDependencies();
        appStore = Provider.of<AppStore>(context);
    }

    Widget _languageList() {
        return ListView(
            children: List.generate(languageData.length, (index) {
                final String name = languageData[index].name;
                return new RadioListTile(
                    value: name,
                    groupValue: appStore.localeName,
                    onChanged: (value) {
                        appStore.setLocale(languageData[index]);
                    },
                    title: new Text(name),
                );
            }),
        );
    }

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: CommonBar(
                title: S.of(context).multiLanguage
            ),
            body: _languageList(),
        );
    }
}
