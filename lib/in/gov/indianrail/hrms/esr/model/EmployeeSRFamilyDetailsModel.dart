import 'package:hrms_cris/in/gov/indianrail/hrms/util/date_time.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/validation_check.dart';

class EmployeeSRFamilyDetailsModel {
  String st;
  String familyMemberName;
  String relationCode;
  String memberDateOfBirth;
  String dependent;
  String familyMemberSrNo;
  String gender;

  EmployeeSRFamilyDetailsModel(this.st, this.familyMemberName,
      this.relationCode, this.memberDateOfBirth, this.dependent, this.familyMemberSrNo, this.gender);

  factory EmployeeSRFamilyDetailsModel.fromJson(dynamic json) {
    return EmployeeSRFamilyDetailsModel(
        json['st']?.toString() ?? 'NA',
        json['familyMemberName']?.toString() ?? 'NA',
        json['relationCode']?.toString() ?? 'NA',
        json['memberDateOfBirth']!=null? format_date(json['memberDateOfBirth']): 'NA',
        json['dependent']?.toString() ?? 'NA',
        json['familyMemberSrNo']?.toString() ?? 'NA',
        json['gender']?.toString() ?? 'NA',
    );
  }

  @override
  String toString() {
    return 'EmployeeSRFamilyDetailsModel{st: $st, familyMemberName: $familyMemberName, relationCode: $relationCode, memberDateOfBirth: $memberDateOfBirth, dependent: $dependent, familyMemberSrNo: $familyMemberSrNo, gender: $gender}';
  }
}
