## 开发

### 环境

- Flutter 3.13.9
- Dart 3.1.5


### 多语言编译

- flutter gen-l10n 命令，根据 .arb 文件生成相应的本地化文件
- 编译后会生成 `app_en.dart` 和 `app_zh.dart` 文件
- 项目中使用 `AppLocalizations.of(context)?.login` 来获取对应语言的字符串