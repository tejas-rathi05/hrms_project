import 'package:hrms_cris/in/gov/indianrail/hrms/util/date_time.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/validation_check.dart';

class EmployeeSRNominationDetailsModel{
  String nomineeAddress;
  String amountPercentage;
  String st;
  String relationDescription;
  String aadhaarNo;
  String srPageNumber;
  String mobileNumber;
  String relationCode;
  String nomineeSrNo;
  String nomineeName;
  String dateWef;
  String hrmsEmployeeId;
  String nomineeAge;
  String otherRelation;
  String accountNature;
  String accountNo;
  String remarks;
  String contigencyNominee;
  String status;

  EmployeeSRNominationDetailsModel(
      this.nomineeAddress,
      this.amountPercentage,
      this.st,
      this.relationDescription,
      this.aadhaarNo,
      this.srPageNumber,
      this.mobileNumber,
      this.relationCode,
      this.nomineeSrNo,
      this.nomineeName,
      this.dateWef,
      this.hrmsEmployeeId,
      this.nomineeAge,
      this.otherRelation,
      this.accountNature,
      this.accountNo,
      this.remarks,
      this.contigencyNominee,
      this.status);

  factory EmployeeSRNominationDetailsModel.fromJson(dynamic json) {
    return EmployeeSRNominationDetailsModel(
        json['nomineeAddress']?.toString() ?? 'NA',
        json['amountPercentage']?.toString() ?? 'NA',
        json['st']?.toString() ?? 'NA',
        json['relationDescription']?.toString() ?? 'NA',
        json['aadhaarNo']?.toString() ?? 'NA',
        json['srPageNumber']?.toString() ?? 'NA',
        json['mobileNumber']?.toString() ?? 'NA',
        json['relationCode']?.toString() ?? 'NA',
        json['nomineeSrNo']?.toString() ?? 'NA',
        json['nomineeName']?.toString() ?? 'NA',
        json['dateWef']!=null? format_date(json['dateWef']): 'NA',
        json['hrmsEmployeeId']?.toString() ?? 'NA',
        json['nomineeAge']?.toString() ?? 'NA',
        json['otherRelation']?.toString() ?? 'NA',
        json['accountNature']?.toString() ?? 'NA',
        json['accountNo']?.toString() ?? 'NA',
        json['remarks']?.toString() ?? 'NA',
        json['contigencyNominee']?.toString() ?? 'NA',
        json['status']?.toString() ?? 'NA',
    );
  }

  @override
  String toString() {
    return 'EmployeeSRNominationDetailsModel{nomineeAddress: $nomineeAddress, amountPercentage: $amountPercentage, st: $st, relationDescription: $relationDescription, aadhaarNo: $aadhaarNo, srPageNumber: $srPageNumber, mobileNumber: $mobileNumber, relationCode: $relationCode, nomineeSrNo: $nomineeSrNo, nomineeName: $nomineeName, dateWef: $dateWef, hrmsEmployeeId: $hrmsEmployeeId, nomineeAge: $nomineeAge, otherRelation: $otherRelation, accountNature: $accountNature, accountNo: $accountNo, remarks: $remarks, contigencyNominee: $contigencyNominee, status: $status}';
  }
}