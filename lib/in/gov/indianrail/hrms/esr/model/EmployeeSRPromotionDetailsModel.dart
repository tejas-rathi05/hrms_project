import 'dart:core';
import 'dart:core';

import 'package:hrms_cris/in/gov/indianrail/hrms/util/date_time.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/validation_check.dart';

class EmployeeSRPromotionDetailsModel {

  String srPageNumber;
  String promotionRefusedAccepted;
  String section;
  String payCommission;
  String otherDesignation;
  String hrmsEmployeeId;
  String officeOrderDate;
  String officeOrderNumber;
  String authorityDesignation_code;
  String station;
  String promotionSrNo;
  String department;
  String scaleCode;
  String st;
  String promotionType;
  String payLevel;
  String promotionDate;
  String sectionDesc;
  String documentDoc;
  String fixationDate;
  String scaleDesc;
  String authorityDesignation;
  String payScale;
  String basicPay;
  String designation_code;
  String designation;
  String promotionTypeCode;
  String remarks;
  String status;

  EmployeeSRPromotionDetailsModel(
      this.srPageNumber,
      this.promotionRefusedAccepted,
      this.section,
      this.payCommission,
      this.otherDesignation,
      this.hrmsEmployeeId,
      this.officeOrderDate,
      this.officeOrderNumber,
      this.authorityDesignation_code,
      this.station,
      this.promotionSrNo,
      this.department,
      this.scaleCode,
      this.st,
      this.promotionType,
      this.payLevel,
      this.promotionDate,
      this.sectionDesc,
      this.documentDoc,
      this.fixationDate,
      this.scaleDesc,
      this.authorityDesignation,
      this.payScale,
      this.basicPay,
      this.designation_code,
      this.designation,
      this.promotionTypeCode,
      this.remarks,
      this.status);

  factory EmployeeSRPromotionDetailsModel.fromJson(dynamic json) {
    return EmployeeSRPromotionDetailsModel(
        json['srPageNumber']?.toString() ?? 'NA',
        json['promotionRefusedAccepted']?.toString() ?? 'NA',
        json['section']?.toString() ?? 'NA',
        json['payCommission']?.toString() ?? 'NA',
        json['otherDesignation']?.toString() ?? 'NA',
        json['hrmsEmployeeId']?.toString() ?? 'NA',
        json['officeOrderDate']!= null ? format_date(json['officeOrderDate']) :'NA',
        json['officeOrderNumber']?.toString() ?? 'NA',
        json['authorityDesignation_code']?.toString() ?? 'NA',
        json['station']?.toString() ?? 'NA',
        json['promotionSrNo']?.toString() ?? 'NA',
        json['department']?.toString() ?? 'NA',
        json['scaleCode']?.toString() ?? 'NA',
        json['st']?.toString() ?? 'NA',
        json['promotionType']?.toString() ?? 'NA',
        json['payLevel']?.toString() ?? 'NA',
        json['promotionDate']!= null ? format_date(json['promotionDate']): 'NA',
        json['sectionDesc']?.toString() ?? 'NA',
        json['documentDoc']?.toString() ?? 'NA',
        json['fixationDate']!=null ? format_date(json['fixationDate']): 'NA',
        json['scaleDesc']?.toString() ?? 'NA',
        json['authorityDesignation']?.toString() ?? 'NA',
        json['payScale']?.toString() ?? 'NA',
        json['basicPay']?.toString() ?? 'NA',
        json['designation_code']?.toString() ?? 'NA',
        json['designation']?.toString() ?? 'NA',
        json['promotionTypeCode']?.toString() ?? 'NA',
        json['remarks']?.toString() ?? 'NA',
        json['status']?.toString() ?? 'NA',
    );
  }

  @override
  String toString() {
    return 'EmployeeSRPromotionDetailsModel{srPageNumber: $srPageNumber, promotionRefusedAccepted: $promotionRefusedAccepted, section: $section, payCommission: $payCommission, otherDesignation: $otherDesignation, hrmsEmployeeId: $hrmsEmployeeId, officeOrderDate: $officeOrderDate, officeOrderNumber: $officeOrderNumber, authorityDesignation_code: $authorityDesignation_code, station: $station, promotionSrNo: $promotionSrNo, department: $department, scaleCode: $scaleCode, st: $st, promotionType: $promotionType, payLevel: $payLevel, promotionDate: $promotionDate, sectionDesc: $sectionDesc, documentDoc: $documentDoc, fixationDate: $fixationDate, scaleDesc: $scaleDesc, authorityDesignation: $authorityDesignation, payScale: $payScale, basicPay: $basicPay, designation_code: $designation_code, designation: $designation, promotionTypeCode: $promotionTypeCode, remarks: $remarks, status: $status}';
  }
}
