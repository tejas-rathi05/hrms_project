import 'package:flutter/cupertino.dart';

class GetLastRequestModel{
  int change_req_id;String hrms_employee_id;String module_name;String tab_name;String status;String emp_ip_address;
  DateTime emp_txn_timestamp;String dc_hrms_id;String dc_ip_address;DateTime dc_txn_timestamp;
  String va_hrms_id;String va_ip_address;DateTime va_txn_timestamp;
  String aa_hrms_id;
  String aa_ip_address;
  DateTime aa_txn_timestamp;
  String dc_remarks;
  String va_remarks;
  String aa_remarks;
  bool result;




  GetLastRequestModel(this.change_req_id, this.hrms_employee_id, this.module_name,
      this.tab_name, this.status, this.emp_ip_address, this.emp_txn_timestamp,
      this.dc_hrms_id, this.dc_ip_address,
      this.dc_txn_timestamp, this.va_hrms_id, this.va_ip_address,
      this.va_txn_timestamp, this.aa_hrms_id, this.aa_ip_address, this.aa_txn_timestamp,
      this.dc_remarks,
      this.va_remarks,this.aa_remarks,this.result,);
  factory GetLastRequestModel.fromJson(dynamic json) {
    return GetLastRequestModel(json['change_req_id'] as int, json['hrms_employee_id'] as String,
        json['module_name'] as String, json['tab_name'] as String,
        json['status'] as String,json['emp_ip_address'] as String,
        json['emp_txn_timestamp'] as DateTime,
        json['dc_hrms_id'] as String, json['dc_ip_address'] as String, json['dc_txn_timestamp'] as DateTime,
        json['va_hrms_id'] as String, json['va_ip_address'] as String, json['va_txn_timestamp'] as DateTime,
        json['aa_hrms_id'] as String,
        json['aa_ip_address'] as String,
        json['aa_txn_timestamp'] as DateTime,
        json['dc_remarks'] as String,
        json['va_remarks'] as String,
        json['aa_remarks'] as String,
        json['result'] as bool
    );
  }
  @override
  String toString() {
    return '{ ${this.change_req_id}, ${this.hrms_employee_id},${this.module_name},${this.tab_name},${this.status},${this.emp_ip_address},${this.emp_txn_timestamp},${this.dc_hrms_id},${this.dc_ip_address},${this.dc_txn_timestamp},${this.va_hrms_id},${this.va_ip_address},${this.va_txn_timestamp},${this.aa_hrms_id},${this.aa_ip_address},${this.aa_txn_timestamp},${this.dc_remarks},${this.va_remarks},${this.aa_remarks},${this.result} }';
  }


}

