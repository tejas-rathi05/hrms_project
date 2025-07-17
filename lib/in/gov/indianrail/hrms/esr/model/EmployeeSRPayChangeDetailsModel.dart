import 'package:hrms_cris/in/gov/indianrail/hrms/util/date_time.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/validation_check.dart';

class EmployeeSRPayChangeDetailsModel{
  String payChangeDescription;
  String stationCode;
  String st;
  String payChangeSrNo;
  String payLevel;
  String srPageNumber;
  String ipAddress;
  String payCommission;
  String userId;
  String stagnationIncrement;
  String txnEntryDate;
  String hrmsEmployeeId;
  String scaleDesc;
  String personalPay;
  String noPayChangeDescription;
  String reasonNoPayChange;
  String basicPay;
  String payChangeCategory;
  String scaleCode;
  String dateOfPayChange;
  String remarks;
  String status;

  EmployeeSRPayChangeDetailsModel(
      this.payChangeDescription,
      this.stationCode,
      this.st,
      this.payChangeSrNo,
      this.payLevel,
      this.srPageNumber,
      this.ipAddress,
      this.payCommission,
      this.userId,
      this.stagnationIncrement,
      this.txnEntryDate,
      this.hrmsEmployeeId,
      this.scaleDesc,
      this.personalPay,
      this.noPayChangeDescription,
      this.reasonNoPayChange,
      this.basicPay,
      this.payChangeCategory,
      this.scaleCode,
      this.dateOfPayChange,
      this.remarks,
      this.status);

  factory EmployeeSRPayChangeDetailsModel.fromJson(dynamic json) {
    return EmployeeSRPayChangeDetailsModel(
        json['payChangeDescription']?.toString() ?? 'NA',
        json['stationCode']?.toString() ?? 'NA',
        json['st']?.toString() ?? 'NA',
        json['payChangeSrNo']?.toString() ?? 'NA',
        json['payLevel']?.toString() ?? 'NA',
        json['srPageNumber']?.toString() ?? 'NA',
        json['ipAddress']?.toString() ?? 'NA',
        json['payCommission']?.toString() ?? 'NA',
        json['userId']?.toString() ?? 'NA',
        json['stagnationIncrement']?.toString() ?? 'NA',
        json['txnEntryDate']!=null? format_date(json['txnEntryDate']): 'NA',
        json['hrmsEmployeeId']?.toString() ?? 'NA',
        json['scaleDesc']?.toString() ?? 'NA',
        json['personalPay']?.toString() ?? 'NA',
        json['noPayChangeDescription']?.toString() ?? 'NA',
        json['reasonNoPayChange']?.toString() ?? 'NA',
        json['basicPay']?.toString() ?? 'NA',
        json['payChangeCategory']?.toString() ?? 'NA',
        json['scaleCode']?.toString() ?? 'NA',
        format_date(json['dateOfPayChange'])?.toString() ?? 'NA',
        json['remarks']?.toString() ?? 'NA',
        json['status']?.toString() ?? 'NA',
    );

  }

  @override
  String toString() {
    return 'EmployeeSRPayChangeDetailsModel{payChangeDescription: $payChangeDescription, stationCode: $stationCode, st: $st, payChangeSrNo: $payChangeSrNo, payLevel: $payLevel, srPageNumber: $srPageNumber, ipAddress: $ipAddress, payCommission: $payCommission, userId: $userId, stagnationIncrement: $stagnationIncrement, txnEntryDate: $txnEntryDate, hrmsEmployeeId: $hrmsEmployeeId, scaleDesc: $scaleDesc, personalPay: $personalPay, noPayChangeDescription: $noPayChangeDescription, reasonNoPayChange: $reasonNoPayChange, basicPay: $basicPay, payChangeCategory: $payChangeCategory, scaleCode: $scaleCode, dateOfPayChange: $dateOfPayChange, remarks: $remarks, status: $status}';
  }
}

