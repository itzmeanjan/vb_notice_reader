import 'dart:io';
import 'dart:async' show Completer;

class Downloader {
  static Future<bool> download(Uri url, String targetPath) {
    var completer = Completer<bool>();
    HttpClient()
        .getUrl(url)
        .then(
          (request) => request.close(),
          onError: (e) => completer.complete(false),
        )
        .then(
          (response) => File(targetPath)
              .openWrite(
                mode: FileMode.write,
              )
              .addStream(response)
              .then(
                (val) => completer.complete(true),
                onError: (e) => completer.complete(false),
              ),
          onError: (e) => completer.complete(false),
        );
    return completer.future;
  }
}
