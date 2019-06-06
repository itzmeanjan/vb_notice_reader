import 'package:flutter/material.dart';
import 'package:vb_noticeboard/vb_noticeboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'VB Notice Board',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Colors.cyanAccent,
            elevation: 16,
          ),
        ),
        darkTheme: ThemeData(),
        home: MyHome(),
      );
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> with TickerProviderStateMixin {
  Map<String, Map<String, String>> _noticeBoard;
  bool _loaded;
  bool _error;
  @override
  void initState() {
    super.initState();
    _loaded = false;
    _error = false;
    FetchNotice().fetch().then(
      (val) {
        _noticeBoard = ParseNotice().parseIt(val);
        setState(
          () => _loaded = true,
        );
      },
      onError: (e) => setState(
            () {
              _loaded = true;
              _error = true;
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            'VB Notice Board',
          ),
          centerTitle: true,
        ),
        body: _loaded
            ? _error
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * .9,
                    height: MediaQuery.of(context).size.height * .65,
                    child: Card(
                      elevation: 16,
                      child: Text(
                        'Something went wrong :/',
                      ),
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) => Card(
                          margin: EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            left: 4,
                            right: 4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              36,
                            ),
                            side: BorderSide(
                              style: BorderStyle.solid,
                              color: Colors.tealAccent,
                              width: 1.0,
                            ),
                          ),
                          elevation: 12,
                          child: ListTile(
                            title: Text(
                              _noticeBoard.values.toList()[index]['text'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 6,
                              right: 6,
                              top: 3,
                              bottom: 3,
                            ),
                            subtitle: Text(
                              _noticeBoard.values.toList()[index]['date'],
                            ),
                            leading: Icon(
                              Icons.announcement,
                            ),
                          ),
                        ),
                    itemCount: _noticeBoard.length,
                    padding: EdgeInsets.only(
                      left: 6,
                      right: 6,
                      top: 16,
                      bottom: 16,
                    ),
                  )
            : Center(
                child: CircularProgressIndicator(
                  valueColor: Tween<Color>(
                    begin: Colors.tealAccent,
                    end: Colors.teal,
                  ).animate(
                    AnimationController(
                      vsync: this,
                    ),
                  ),
                ),
              ),
      );
}
