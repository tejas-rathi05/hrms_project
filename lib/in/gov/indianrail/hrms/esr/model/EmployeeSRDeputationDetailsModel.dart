import 'package:hrms_cris/in/gov/indianrail/hrms/util/date_time.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/validation_check.dart';

class EmployeeSRDeputationDetailsModel{
  String repatriated_to_railway;
  int deputiation_sr_no;
  String dep_in_to_station;
  String dep_in_oo_no;
  String date_joining_at_dept;
  String department_organisation;
  String hrms_employee_id;
  String station;
  String country_name;
  String dep_out_oo_date;
  String dep_out_from_station;
  String dep_in_oo_date;
  String date_to;
  String ip_address;
  String date_release_from_deputation;
  String country_code;
  String txn_timestamp;
  String deputation_type;
  String ministry_name;
  String user_id;
  String dep_out_oo_no;
  String designation;
  String pay_level;
  String date_from;
  String status;

  EmployeeSRDeputationDetailsModel(
      this.repatriated_to_railway,
      this.deputiation_sr_no,
      this.dep_in_to_station,
      this.dep_in_oo_no,
      this.date_joining_at_dept,
      this.department_organisation,
      this.hrms_employee_id,
      this.station,
      this.country_name,
      this.dep_out_oo_date,
      this.dep_out_from_station,
      this.dep_in_oo_date,
      this.date_to,
      this.ip_address,
      this.date_release_from_deputation,
      this.country_code,
      this.txn_timestamp,
      this.deputation_type,
      this.ministry_name,
      this.user_id,
      this.dep_out_oo_no,
      this.designation,
      this.pay_level,
      this.date_from,
      this.status);

  factory EmployeeSRDeputationDetailsModel.fromJson(dynamic json) {
    return EmployeeSRDeputationDetailsModel(
        null_empty_check(json['repatriated_to_railway']) as String,
        json['deputiation_sr_no'] as int,
        null_empty_check(json['dep_in_to_station']) as String,
        null_empty_check(json['dep_in_oo_no']) as String,
        format_date(json['date_joining_at_dept']) as String,
        null_empty_check(json['department_organisation']) as String,
        null_empty_check(json['hrms_employee_id']) as String,
        null_empty_check(json['station']) as String,
        null_empty_check(json['country_name']) as String,
        format_date(json['dep_out_oo_date']) as String,
        null_empty_check(json['dep_out_from_station']) as String,
        format_date(json['dep_in_oo_date']) as String,
        format_date(json['date_to']) as String,
        null_empty_check(json['ip_address']) as String,
        format_date(json['date_release_from_deputation']) as String,
        null_empty_check(json['country_code']) as String,
        null_empty_check(json['txn_timestamp']) as String,
        null_empty_check(json['deputation_type']) as String,
        null_empty_check(json['ministry_name']) as String,
        null_empty_check(json['user_id']) as String,
        null_empty_check(json['dep_out_oo_no']) as String,
        null_empty_check(json['designation']) as String,
        null_empty_check(json['pay_level']) as String,
        format_date(json['date_from']) as String,
        service_status_check(json['status']) as String);
  }


  @override
  String toString() {
    return 'EmployeeSRDeputationDetailsModel{repatriated_to_railway: $repatriated_to_railway, deputiation_sr_no: $deputiation_sr_no, dep_in_to_station: $dep_in_to_station, dep_in_oo_no: $dep_in_oo_no, date_joining_at_dept: $date_joining_at_dept, department_organisation: $department_organisation, hrms_employee_id: $hrms_employee_id, station: $station, country_name: $country_name, dep_out_oo_date: $dep_out_oo_date, dep_out_from_station: $dep_out_from_station, dep_in_oo_date: $dep_in_oo_date, date_to: $date_to, ip_address: $ip_address, date_release_from_deputation: $date_release_from_deputation, country_code: $country_code, txn_timestamp: $txn_timestamp, deputation_type: $deputation_type, ministry_name: $ministry_name, user_id: $user_id, dep_out_oo_no: $dep_out_oo_no, designation: $designation, pay_level: $pay_level, date_from: $date_from, status: $status}';
  }
}