
class Pass_ApplicationStatusModel {
  String hrms_id;
  String passtype;
  int pan;
  int pass_year;
  String breakjo;
  String submitted_date;
  String full_half_set_flag;
  String from_station;
  String to_station;
  String status_flag;
  String remarks;
  String pass_type_code;


  Pass_ApplicationStatusModel(this.hrms_id, this.passtype, this.pan, this.pass_year,this.breakjo,
      this.submitted_date, this.full_half_set_flag,
      this.from_station, this.to_station, this.status_flag, this.remarks,this.pass_type_code);

  factory Pass_ApplicationStatusModel.fromJson(dynamic json) {
    return Pass_ApplicationStatusModel(
      json['hrms_id'] != null ? json['hrms_id'] as String : '',
      json['passtype'] != null ? json['passtype'] as String : '',
      json['pan'] as int ,
      json['pass_year'] as int,
      json['breakjo'] != null ? json['breakjo'] as String : '',
      json['submitted_date'] != null ? json['submitted_date'] as String : '',
      json['full_half_set_flag'] != null ? json['full_half_set_flag'] as String : '',
      json['from_station'] != null ? json['from_station'] as String : '',
      json['to_station'] != null ? json['to_station'] as String : '',
      json['status_flag'] != null ? json['status_flag'] as String : '',
      json['remarks'] != null ? json['remarks'] as String : '',
      json['pass_type_code'] != null ? json['pass_type_code'] as String : '',
    );
  }


  @override
  String toString() {
    return '{ ${this.hrms_id}, ${this.passtype},${this.pan},${this.pass_year},${this.breakjo},${this.submitted_date},${this.full_half_set_flag},${this.from_station},${this.to_station},${this.status_flag},${this.remarks},${this.pass_type_code}}';
  }
}