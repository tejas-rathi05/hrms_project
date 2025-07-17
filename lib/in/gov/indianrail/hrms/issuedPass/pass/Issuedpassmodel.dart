class IssuedPassModel{
String cancel_allowed;
String hrms_id;
String pass_type_code;
String pan;  //int
String unique_pass_number; //int
String issuing_date;
String expiry_date;
String split_pass_flag;
String attendant_flag;
String attendant_upn;  //int


String cancel_flag;
String pass_year; //int
String full_half_set_flag;
String from_station;
String to_station;

String pass_type;
String set_flag;
String expired;

String travelling_alone;
String cancelstatus;
String splitstatus;
String cancel_transaction_time;
IssuedPassModel(this.cancel_allowed, this.hrms_id, this.pass_type_code,
    this.pan, this.unique_pass_number, this.issuing_date, this.expiry_date,
    this.split_pass_flag, this.attendant_flag,this.attendant_upn,
    this.cancel_flag, this.pass_year, this.full_half_set_flag,
    this.from_station, this.to_station, this.pass_type, this.set_flag,
    this.expired,
    this.travelling_alone,
    this.cancelstatus,this.splitstatus,this.cancel_transaction_time);


factory IssuedPassModel.fromJson(dynamic json) {
  return IssuedPassModel(
    json['cancel_allowed'] != null ? json['cancel_allowed'] as String : '',
    json['hrms_id'] != null ? json['hrms_id'] as String : '',
    json['pass_type_code'] != null ? json['pass_type_code'] as String : '',
    json['pan']!= null ? json['pan'].toString()  : '',
    json['unique_pass_number'] != null ? json['unique_pass_number'].toString() : '',
    json['issuing_date'] != null ? json['issuing_date'] as String : '',
    json['expiry_date'] != null ? json['expiry_date'] as String : '',
    json['split_pass_flag'] != null ? json['split_pass_flag'] as String : '',
    json['attendant_flag'] != null ? json['attendant_flag'] as String : '',
    json['attendant_upn'] != null? json['attendant_upn'].toString() : '',
    json['cancel_flag'] != null ? json['cancel_flag'] as String : '',
    json['pass_year'] != null? json['pass_year'].toString() : '',
    json['full_half_set_flag'] != null ? json['full_half_set_flag'] as String : '',
    json['from_station'] != null ? json['from_station'] as String : '',
    json['to_station'] != null ? json['to_station'] as String : '',
    json['pass_type'] != null ? json['pass_type'] as String : '',
    json['set_flag'] != null ? json['set_flag'] as String : '',
    json['expired'] != null ? json['expired'] as String : '',
    json['travelling_alone'] != null ? json['travelling_alone'] as String : '',
    json['cancelstatus'] != null ? json['cancelstatus'] as String : '',
    json['splitstatus'] != null ? json['splitstatus'] as String : '',
    json['cancel_transaction_time'] != null ? json['cancel_transaction_time'] as String : '',
  );
}


@override
String toString() {
  return '{ ${this.cancel_allowed}, ${this.hrms_id},${this.pass_type_code},${this.pan},${this.unique_pass_number},${this.issuing_date},${this.expiry_date},${this.split_pass_flag},${this.attendant_flag},${this.attendant_upn},${this.cancel_flag},${this.pass_year},${this.full_half_set_flag},${this.from_station},${this.to_station},${this.pass_type},${this.set_flag},${this.expired},${this.travelling_alone},${this.cancelstatus},${this.splitstatus},${this.cancel_transaction_time} }';
}


}

