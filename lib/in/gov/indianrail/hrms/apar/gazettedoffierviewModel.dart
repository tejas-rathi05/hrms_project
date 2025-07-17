class GazettedOfficerModel {
  String hrmsEmployeeId;
  String aparFinYr;
  String vafCode;
  String employeeName;
  String Designation;
  int DesigatnionCode;

  GazettedOfficerModel(this.hrmsEmployeeId, this.aparFinYr, this.vafCode,
      this.employeeName, this.Designation, this.DesigatnionCode);

  factory GazettedOfficerModel.fromJson(dynamic json) {
    return GazettedOfficerModel(json['hrmsEmployeeId'] as String, json['aparFinYr'] as String,json['vafCode'] as String,
        json['employeeName'] as String,json['Designation'] as String,
        json['DesigatnionCode'] as int,
        );
  }

  @override
  String toString() {
    return 'GazettedOfficerModel{hrmsEmployeeId: $hrmsEmployeeId, aparFinYr: $aparFinYr, vafCode: $vafCode, employeeName: $employeeName, Designation: $Designation, DesigatnionCode: $DesigatnionCode}';
  }
}