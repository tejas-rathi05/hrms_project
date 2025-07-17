import 'package:hrms_cris/in/gov/indianrail/hrms/util/date_time.dart';

class EmployeeSRTrainingDetailsModel{
  String trainingType;
  String hrmsEmployeeIdForTraining;
  String st;
  String trainingYear;
  String sequenceNumber;
  String trainingDescription;
  String trainingPlace;
  String trainingDuration;
  String ipAddress;
  String trainingSerialNo;
  String dateFrom;
  String userId;
  String txnTimestamp;
  String trainingSpecialization;
  String countryDescription;
  String trainingName;
  String dateTo;
  String trainingDocumentUpload;
  String srPagenumber;
  String trainingCountry;
  String trainingInstitute;
  String remarks;
  String status;

  EmployeeSRTrainingDetailsModel(
      this.trainingType,
      this.hrmsEmployeeIdForTraining,
      this.st,
      this.trainingYear,
      this.sequenceNumber,
      this.trainingDescription,
      this.trainingPlace,
      this.trainingDuration,
      this.ipAddress,
      this.trainingSerialNo,
      this.dateFrom,
      this.userId,
      this.txnTimestamp,
      this.trainingSpecialization,
      this.countryDescription,
      this.trainingName,
      this.dateTo,
      this.trainingDocumentUpload,
      this.srPagenumber,
      this.trainingCountry,
      this.trainingInstitute,
      this.remarks,
      this.status);


  factory EmployeeSRTrainingDetailsModel.fromJson(dynamic json) {
    return EmployeeSRTrainingDetailsModel(
        json['trainingType']?.toString() ?? 'NA',
        json['hrmsEmployeeIdForTraining']?.toString() ?? 'NA',
        json['st']?.toString() ?? 'NA',
        json['trainingYear']?.toString() ?? 'NA',
        json['sequenceNumber']?.toString() ?? 'NA',
        json['trainingDescription']?.toString() ?? 'NA',
        json['trainingPlace']?.toString() ?? 'NA',
        json['trainingDuration']?.toString() ?? 'NA',
        json['ipAddress']?.toString() ?? 'NA',
        json['trainingSerialNo']?.toString() ?? 'NA',
        json['dateFrom'] !=null ? format_date(json['dateFrom']):'NA',
        json['userId']?.toString() ?? 'NA',
        json['txnTimestamp'] as String,
        json['trainingSpecialization']?.toString() ?? 'NA',
        json['countryDescription']?.toString() ?? 'NA',
        json['trainingName']?.toString() ?? 'NA',
        json['dateTo']!=null? format_date(json['dateTo']):'NA',
        json['trainingDocumentUpload']?.toString() ?? 'NA',
        json['srPagenumber']?.toString() ?? 'NA',
        json['trainingCountry']?.toString() ?? 'NA',
        json['trainingInstitute']?.toString() ?? 'NA',
        json['remarks']?.toString() ?? 'NA',
        json['status']?.toString() ?? 'NA',
    );
  }

  @override
  String toString() {
    return 'EmployeeSRTrainingDetailsModel{trainingType: $trainingType, hrmsEmployeeIdForTraining: $hrmsEmployeeIdForTraining, st: $st, trainingYear: $trainingYear, sequenceNumber: $sequenceNumber, trainingDescription: $trainingDescription, trainingPlace: $trainingPlace, trainingDuration: $trainingDuration, ipAddress: $ipAddress, trainingSerialNo: $trainingSerialNo, dateFrom: $dateFrom, userId: $userId, txnTimestamp: $txnTimestamp, trainingSpecialization: $trainingSpecialization, countryDescription: $countryDescription, trainingName: $trainingName, dateTo: $dateTo, trainingDocumentUpload: $trainingDocumentUpload, srPagenumber: $srPagenumber, trainingCountry: $trainingCountry, trainingInstitute: $trainingInstitute, remarks: $remarks, status: $status}';
  }
}