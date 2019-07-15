import 'dart:io' show File;

class HomeModel {
  Map<String, Map<String, String>> noticeBoard = {};
  bool loaded = false;
  bool error = false;
  File targetFile;
}
