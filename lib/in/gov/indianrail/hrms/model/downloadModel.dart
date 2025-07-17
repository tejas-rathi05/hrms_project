class DownloadAparModel {
  String status;
  String message;
  String fileString;

  DownloadAparModel(this.status, this.message, this.fileString);

  factory DownloadAparModel.fromJson(dynamic json) {
    return DownloadAparModel(json['status'] as String,
        json['message'] as String, json['fileString'] as String);
  }

  @override
  String toString() {
    return '{ ${this.status}, ${this.message},${this.fileString} }';
  }
}
