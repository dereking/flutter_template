import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';

Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 1,  // 显示方法调用数量
    errorMethodCount: 2,  // 错误时的堆栈深度
    lineLength: 120,
    colors: true,
    printEmojis: true,
    // dateTimeFormat: (time) => time.(), 
  ),);

void initLogger() {
  Logger.level = kReleaseMode ? Level.warning : Level.trace;
}