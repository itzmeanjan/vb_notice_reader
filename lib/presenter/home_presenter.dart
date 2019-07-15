import 'package:vb_notice_reader/model/home_model.dart';
import 'dart:io' show File;
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import 'package:vb_notice_reader/view/home_view.dart';
import 'package:path/path.dart' show join, basename;
import 'package:vb_noticeboard/vb_noticeboard.dart';

class HomePresenter {
  HomeModel homeModel;
  HomeView _homeView;

  HomePresenter() {
    homeModel = HomeModel();
    getTargetFile().then(
      (val) => homeModel.targetFile = val,
      onError: (e) {},
    );
  }

  Future<File> getTargetFile() => getTemporaryDirectory()
      .then((dirName) => File(join(dirName.path, 'data.json')));

  fetchFile() => FetchNotice().fetch().then(
        (val) {
          homeModel.noticeBoard = ParseNotice().parseIt(val);
          StoreNotice.storeIt(homeModel.targetFile.path, homeModel.noticeBoard)
              .then(
            (val) => print(val),
          );
          homeModel.loaded = true;
        },
        onError: (e) {
          homeModel.loaded = true;
          homeModel.error = true;
        },
      );

  set homeView(HomeView homeView) {
    _homeView = homeView;
    _homeView.updateUI(homeModel);
  }
}
