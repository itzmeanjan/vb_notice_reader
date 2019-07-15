import 'package:flutter/material.dart';
import 'package:vb_noticeboard/vb_noticeboard.dart';
import 'package:vb_notice_reader/downloader.dart';
import 'package:vb_notice_reader/presenter/home_presenter.dart';
import 'home_view.dart';
import 'package:vb_notice_reader/model/home_model.dart';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState(HomePresenter());
}

class _MyHomeState extends State<MyHome>
    with TickerProviderStateMixin
    implements HomeView {
  HomePresenter _homePresenter;

  _MyHomeState(this._homePresenter);

  @override
  void initState() {
    super.initState();
    _getTargetFile().then(
      (file) => file.existsSync()
          ? ExtractFromJson.extractIt(file.path).then(
              (data) {
                _noticeBoard = data;
                setState(() => _loaded = true);
              },
              onError: (e) => _fetchFile(),
            )
          : _fetchFile(),
      onError: (e) => _fetchFile(),
    );
  }

  @override
  updateUI(HomeModel homeModel) =>
      setState(() => _homePresenter.homeModel = homeModel);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            'VB Notice Board',
            style: TextStyle(
              color: Colors.teal,
              fontSize: 10,
              shadows: [
                Shadow(
                  color: Colors.black,
                  offset: Offset(1.2, 1.5),
                ),
              ],
            ),
            textScaleFactor: 2,
          ),
          centerTitle: true,
          actions: <Widget>[
            if (_loaded && !_error)
              IconButton(
                  icon: Icon(
                    Icons.refresh,
                  ),
                  onPressed: () {
                    setState(() {
                      _loaded = false;
                    });
                    _fetchFile();
                  }),
          ],
        ),
        body: _loaded
            ? _error
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    color: Colors.cyanAccent,
                    child: Text(
                      'Something went wrong \u{1f644}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.cyan,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(1.2, 1.5),
                          ),
                        ],
                      ),
                      textScaleFactor: 2,
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) => Card(
                      child: ListTile(
                        onTap: () => showDialog(
                          context: context,
                          builder: (contextNew) => AlertDialog(
                            title: Text(
                              'Notice :: ${index + 1}/ ${_noticeBoard.length}',
                            ),
                            content: Text(
                              _noticeBoard.values.toList()[index]['text'],
                            ),
                            actions: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.file_download,
                                ),
                                onPressed: () => getTemporaryDirectory().then(
                                  (dirName) => Downloader.download(
                                    Uri.parse(
                                        _noticeBoard.keys.toList()[index]),
                                    join(
                                      dirName.path,
                                      basename(
                                          _noticeBoard.keys.toList()[index]),
                                    ),
                                  ).then(
                                    (result) =>
                                        Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          result
                                              ? 'Notice Downloaded !!!'
                                              : 'Notice Download Failed !!!',
                                        ),
                                        backgroundColor:
                                            result ? Colors.green : Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          barrierDismissible: true,
                        ),
                        title: Text(
                          _noticeBoard.values.toList()[index]['text'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.teal,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(
                          left: 6,
                          right: 6,
                          top: 3,
                          bottom: 3,
                        ),
                        subtitle: Text(
                          _noticeBoard.values.toList()[index]['date'],
                          style: TextStyle(
                            color: Colors.teal,
                          ),
                        ),
                        leading: Icon(
                          Icons.notifications_active,
                          color: Colors.red,
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
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                color: Colors.cyanAccent,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.cyanAccent,
                  valueColor: Tween<Color>(
                    begin: Colors.black,
                    end: Colors.tealAccent,
                  ).animate(
                    AnimationController(
                      vsync: this,
                    ),
                  ),
                ),
              ),
      );
}
