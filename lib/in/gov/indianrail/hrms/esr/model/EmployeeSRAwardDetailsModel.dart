import 'package:hrms_cris/in/gov/indianrail/hrms/util/date_time.dart';

class EmployeeSRAwardDetailsModel {
  String st;
  String sequenceNumber;
  String awardDocumentUpload;
  String srPageNumber;
  String awardPeriod;
  String cashAmount;
  String awardAuthority;
  String awardDoc;
  String awardName;
  String hrmsEmployeeIdForAward;
  String awardLevel;
  String awardSrNo;
  String awardFor;
  String remarks;
  String status;

  EmployeeSRAwardDetailsModel(
      this.st,
      this.sequenceNumber,
      this.awardDocumentUpload,
      this.srPageNumber,
      this.awardPeriod,
      this.cashAmount,
      this.awardAuthority,
      this.awardDoc,
      this.awardName,
      this.hrmsEmployeeIdForAward,
      this.awardLevel,
      this.awardSrNo,
      this.awardFor,
      this.remarks,
      this.status);

  factory EmployeeSRAwardDetailsModel.fromJson(dynamic json) {
    return EmployeeSRAwardDetailsModel(
        json['st']?.toString() ?? 'NA',
        json['sequenceNumber']?.toString() ?? 'NA',
        json['awardDocumentUpload']?.toString() ?? 'NA',
        json['srPageNumber']?.toString() ?? 'NA',
        json['awardPeriod']!=null ? format_date(json['awardPeriod']): 'NA',
        json['cashAmount']?.toString() ?? 'NA',
        json['awardAuthority']?.toString() ?? 'NA',
        json['awardDoc']?.toString() ?? 'NA',
        json['awardName']?.toString() ?? 'NA',
        json['hrmsEmployeeIdForAward']?.toString() ?? 'NA',
        json['awardLevel']?.toString() ?? 'NA',
        json['awardSrNo']?.toString() ?? 'NA',
        json['awardFor']?.toString() ?? 'NA',
        json['remarks']?.toString() ?? 'NA',
        json['status']?.toString() ?? 'NA',
      );
    }

  @override
  String toString() {
    return 'EmployeeSRAwardDetailsModel{st: $st, sequenceNumber: $sequenceNumber, awardDocumentUpload: $awardDocumentUpload, srPageNumber: $srPageNumber, awardPeriod: $awardPeriod, cashAmount: $cashAmount, awardAuthority: $awardAuthority, awardDoc: $awardDoc, awardName: $awardName, hrmsEmployeeIdForAward: $hrmsEmployeeIdForAward, awardLevel: $awardLevel, awardSrNo: $awardSrNo, awardFor: $awardFor, remarks: $remarks, status: $status}';
  }


}
