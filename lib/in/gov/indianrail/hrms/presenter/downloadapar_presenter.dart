
import 'package:hrms_cris/in/gov/indianrail/hrms/model/downloadModel.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/repository/network_util.dart';

abstract class DownloadAparContract {
  void onDownloadSuccess(DownloadAparModel downloadAparModel,String aparFinYr);
  void onDownloadError(String error);
}

class DownloadAparPresenter {
  DownloadAparContract _view;
  NetworkUtil api = new NetworkUtil();
  DownloadAparPresenter(this._view);

  downloadApar(String userId, String aparFinYr) {
    api.downloadApar(userId, aparFinYr)
        .then((downloadapar) => _view.onDownloadSuccess(downloadapar as DownloadAparModel, aparFinYr))
        .catchError((onError) => _view.onDownloadError(onError.toString()));
  }
}