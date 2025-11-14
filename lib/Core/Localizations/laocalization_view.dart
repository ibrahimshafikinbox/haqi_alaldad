import 'package:flutter/material.dart';
import 'package:store_mangment/Core/Localizations/app_localizatios.dart';
import 'package:store_mangment/Core/Localizations/laocalizations_const.dart';
import 'package:store_mangment/Core/Localizations/lng.dart';
import 'package:store_mangment/Feature/resources/styles/app_text_style.dart';
import 'package:store_mangment/main.dart' show MyApp;

class LanguageChangeWidget extends StatefulWidget {
  const LanguageChangeWidget({super.key});

  @override
  State<LanguageChangeWidget> createState() => _LanguageChangeWidgetState();
}

class _LanguageChangeWidgetState extends State<LanguageChangeWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(100),
            topLeft: Radius.circular(100),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context).translate("change_lang"),
                    style: AppTextStyle.textStyleBoldBlack,
                  ),
                  Spacer(),
                  DropdownButton<Language>(
                    underline: const SizedBox(),
                    icon: const Icon(
                      Icons.language,
                      color: Color.fromARGB(255, 22, 120, 26),
                    ),
                    onChanged: (Language? language) async {
                      if (language != null) {
                        Locale _locale = await setLocale(language.languageCode);
                        // ignore: use_build_context_synchronously
                        MyApp.setLocale(context, _locale);
                      }
                    },
                    items: Language.languageList()
                        .map<DropdownMenuItem<Language>>(
                          (e) => DropdownMenuItem<Language>(
                            value: e,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  e.flag,
                                  style: const TextStyle(fontSize: 30),
                                ),
                                Text(e.name),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
