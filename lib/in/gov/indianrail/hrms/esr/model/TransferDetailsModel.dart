import 'package:hrms_cris/in/gov/indianrail/hrms/util/date_time.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/validation_check.dart';

class TransferDetailsModel{
  String transferFromDepartmentCode;
  String transferFlag;
  String chargeTakenFrom;
  String transferToPlaceDesc;
  String srPageNumber;
  String transferFromSubDepartmentCode;
  String achievement;
  String transferFromPlace;
  String experience;
  String dateReleaseFromPost;
  String hrmsEmployeeId;
  String transferToSection;
  String transferFromSection;
  String transferFromDesignation;
  String dateChargeTakeFromPost;
  String transferFromDesignationCode;
  String transferFromDepartment;
  String transferToPlace;
  String transferFlagDesc;
  String transferDesignationCode;
  String transferFromStation;
  String st;
  String transferToSubDepartmentCode;
  String transferDesignation;
  String transferToStation;
  String transferFromSectionDesc;
  String transferToSubDepartment;
  String transferDepartment;
  String transferReasonDesc;
  String transferOrderNo;
  String transferOrderDate;
  String transferToOffice;
  String transferFromOffice;
  String transferFromSubDepartment;
  String transferSrNo;
  String transferReason;
  String transferToSectionDesc;
  String transferDepartmentCode;
  String remarks;
  String status;
  String transferFromPlaceDesc;

  @override
  String toString() {
    return 'TransferDetailsModel{transferFromDepartmentCode: $transferFromDepartmentCode, transferFlag: $transferFlag, chargeTakenFrom: $chargeTakenFrom, transferToPlaceDesc: $transferToPlaceDesc, srPageNumber: $srPageNumber, transferFromSubDepartmentCode: $transferFromSubDepartmentCode, achievement: $achievement, transferFromPlace: $transferFromPlace, experience: $experience, dateReleaseFromPost: $dateReleaseFromPost, hrmsEmployeeId: $hrmsEmployeeId, transferToSection: $transferToSection, transferFromSection: $transferFromSection, transferFromDesignation: $transferFromDesignation, dateChargeTakeFromPost: $dateChargeTakeFromPost, transferFromDesignationCode: $transferFromDesignationCode, transferFromDepartment: $transferFromDepartment, transferToPlace: $transferToPlace, transferFlagDesc: $transferFlagDesc, transferDesignationCode: $transferDesignationCode, transferFromStation: $transferFromStation, st: $st, transferToSubDepartmentCode: $transferToSubDepartmentCode, transferDesignation: $transferDesignation, transferToStation: $transferToStation, transferFromSectionDesc: $transferFromSectionDesc, transferToSubDepartment: $transferToSubDepartment, transferDepartment: $transferDepartment, transferReasonDesc: $transferReasonDesc, transferOrderNo: $transferOrderNo, transferOrderDate: $transferOrderDate, transferToOffice: $transferToOffice, transferFromOffice: $transferFromOffice, transferFromSubDepartment: $transferFromSubDepartment, transferSrNo: $transferSrNo, transferReason: $transferReason, transferToSectionDesc: $transferToSectionDesc, transferDepartmentCode: $transferDepartmentCode, remarks: $remarks, status: $status, transferFromPlaceDesc: $transferFromPlaceDesc}';
  }

  TransferDetailsModel(
      this.transferFromDepartmentCode,
      this.transferFlag,
      this.chargeTakenFrom,
      this.transferToPlaceDesc,
      this.srPageNumber,
      this.transferFromSubDepartmentCode,
      this.achievement,
      this.transferFromPlace,
      this.experience,
      this.dateReleaseFromPost,
      this.hrmsEmployeeId,
      this.transferToSection,
      this.transferFromSection,
      this.transferFromDesignation,
      this.dateChargeTakeFromPost,
      this.transferFromDesignationCode,
      this.transferFromDepartment,
      this.transferToPlace,
      this.transferFlagDesc,
      this.transferDesignationCode,
      this.transferFromStation,
      this.st,
      this.transferToSubDepartmentCode,
      this.transferDesignation,
      this.transferToStation,
      this.transferFromSectionDesc,
      this.transferToSubDepartment,
      this.transferDepartment,
      this.transferReasonDesc,
      this.transferOrderNo,
      this.transferOrderDate,
      this.transferToOffice,
      this.transferFromOffice,
      this.transferFromSubDepartment,
      this.transferSrNo,
      this.transferReason,
      this.transferToSectionDesc,
      this.transferDepartmentCode,
      this.remarks,
      this.status,
      this.transferFromPlaceDesc);

  factory TransferDetailsModel.fromJson(dynamic json) {
    return TransferDetailsModel(
        json['transferFromDepartmentCode']?.toString() ?? 'NA',
        json['transferFlag']?.toString() ?? 'NA',
        json['chargeTakenFrom']!=null? format_date(json['chargeTakenFrom']): 'NA',
        json['transferToPlaceDesc']?.toString() ?? 'NA',
        json['srPageNumber']?.toString() ?? 'NA',
        json['transferFromSubDepartmentCode']?.toString() ?? 'NA',
        json['achievement']?.toString() ?? 'NA',
        json['transferFromPlace']?.toString() ?? 'NA',
        json['experience']?.toString() ?? 'NA',
        json['dateReleaseFromPost']!=null ? format_date(json['dateReleaseFromPost']): 'NA',
        json['hrmsEmployeeId']?.toString() ?? 'NA',
        json['transferToSection']?.toString() ?? 'NA',
        json['transferFromSection']?.toString() ?? 'NA',
        json['transferFromDesignation']?.toString() ?? 'NA',
        json['dateChargeTakeFromPost']!=null? format_date(json['dateChargeTakeFromPost']) :'NA',
        json['transferFromDesignationCode']?.toString() ?? 'NA',
        json['transferFromDepartment']?.toString() ?? 'NA',
        json['transferToPlace']?.toString() ?? 'NA',
        json['transferFlagDesc']?.toString() ?? 'NA',
        json['transferDesignationCode']?.toString() ?? 'NA',
        json['transferFromStation']?.toString() ?? 'NA',
        json['st']?.toString() ?? 'NA',
        json['transferToSubDepartmentCode']?.toString() ?? 'NA',
        json['transferDesignation']?.toString() ?? 'NA',
        json['transferToStation']?.toString() ?? 'NA',
        json['transferFromSectionDesc']?.toString() ?? 'NA',
        json['transferToSubDepartment']?.toString() ?? 'NA',
        json['transferDepartment']?.toString() ?? 'NA',
        json['transferReasonDesc']?.toString() ?? 'NA',
        json['transferOrderNo']?.toString() ?? 'NA',
        json['transferOrderDate']!=null ? format_date(json['transferOrderDate']) :'NA',
        json['transferToOffice']?.toString() ?? 'NA',
        json['transferFromOffice']?.toString() ?? 'NA',
        json['transferFromSubDepartment']?.toString() ?? 'NA',
        json['transferSrNo']?.toString() ?? 'NA',
        json['transferReason']?.toString() ?? 'NA',
        json['transferToSectionDesc']?.toString() ?? 'NA',
        json['transferDepartmentCode']?.toString() ?? 'NA',
        json['remarks']?.toString() ?? 'NA',
        json['status']?.toString() ?? 'NA',
        json['transferFromPlaceDesc']?.toString() ?? 'NA',
    );
  }
}
