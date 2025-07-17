

import '../../util/validation_check.dart';

class EmployeeSRPublicationDetailsModel{
  String tech_nontech;
  String publication_name;
  String publisher_name;
  int year;
  String subject;
  String origin;
  int sr_no;
  String language;
  String ip_address;
  int sequencenumber;
  String publication_type;
  String txn_timestamp;
  String user_id;
  String hrms_employee_id;
  String publication_level;
  String remarks;
  String description_published;
  String status;

  EmployeeSRPublicationDetailsModel(
      this.tech_nontech,
      this.publication_name,
      this.publisher_name,
      this.year,
      this.subject,
      this.origin,
      this.sr_no,
      this.language,
      this.ip_address,
      this.sequencenumber,
      this.publication_type,
      this.txn_timestamp,
      this.user_id,
      this.hrms_employee_id,
      this.publication_level,
      this.remarks,
      this.description_published,
      this.status);

  factory EmployeeSRPublicationDetailsModel.fromJson(dynamic json) {
    return EmployeeSRPublicationDetailsModel(
        json['tech_nulltech']?.toString() ?? 'NA',
        json['publication_name']?.toString() ?? 'NA',
        json['publisher_name']?.toString() ?? 'NA',
        json['year'] as int,
        json['subject']?.toString() ?? 'NA',
        json['origin']?.toString() ?? 'NA',
        json['sr_no'] as int,
        json['language']?.toString() ?? 'NA',
        json['ip_address']?.toString() ?? 'NA',
        json['sequencenumber'] as int,
        json['publication_type']?.toString() ?? 'NA',
        json['txn_timestamp']?.toString() ?? 'NA',
        json['user_id']?.toString() ?? 'NA',
        json['hrms_employee_id']?.toString() ?? 'NA',
        json['publication_level']?.toString() ?? 'NA',
        json['remarks']?.toString() ?? 'NA',
        json['description_published']?.toString() ?? 'NA',
        service_status_check(json['status']) as String);
  }


    @override
  String toString() {
    return 'EmployeeSRPublicationDetailsModel{tech_nontech: $tech_nontech, publication_name: $publication_name, publisher_name: $publisher_name, year: $year, subject: $subject, origin: $origin, sr_no: $sr_no, language: $language, ip_address: $ip_address, sequencenumber: $sequencenumber, publication_type: $publication_type, txn_timestamp: $txn_timestamp, user_id: $user_id, hrms_employee_id: $hrms_employee_id, publication_level: $publication_level, remarks: $remarks, description_published: $description_published, status: $status}';
  }

}