class Language {
  final String languageCode;
  final String name;
  final String flag;
  bool isSelected;

  Language({
    required this.flag,
    required this.name,
    required this.languageCode,
    this.isSelected = false,
  });

  static List<Language> languageList() {
    return <Language>[
      Language(name: 'English', flag: '🇺🇸', languageCode: 'en'),
      Language(name: 'Arabic', flag: '🇸🇦', languageCode: 'ar'),
      Language(name: 'French', flag: '🇫🇷', languageCode: 'fr'),
    ];
  }

  void select() {
    for (var lang in Language.languageList()) {
      lang.isSelected = false;
    }
    this.isSelected = true;
  }
}
