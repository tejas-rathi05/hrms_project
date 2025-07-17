

class EmployeeSRQualificationDetailsModel{
  String st;
  String country;
  String qualificationLevel;
  String srPageNumber;
  String hrmsEmployeeIdForQualification;
  String subjects;
  String employeeQualificationSrNo;
  String otherCourse;
  String marksPercentage;
  String courseDescription;
  String boardName;
  String duration;
  String passingYear;
  String marksDocumentUpload;
  String grade;
  String course;
  String institute;
  String qualificationAtJoiningTime;
  String place;
  String otherUniversity;
  String board;

  EmployeeSRQualificationDetailsModel(
      this.st,
      this.country,
      this.qualificationLevel,
      this.srPageNumber,
      this.hrmsEmployeeIdForQualification,
      this.subjects,
      this.employeeQualificationSrNo,
      this.otherCourse,
      this.marksPercentage,
      this.courseDescription,
      this.boardName,
      this.duration,
      this.passingYear,
      this.marksDocumentUpload,
      this.grade,
      this.course,
      this.institute,
      this.qualificationAtJoiningTime,
      this.place,
      this.otherUniversity,
      this.board);

  factory EmployeeSRQualificationDetailsModel.fromJson(dynamic json) {
    return EmployeeSRQualificationDetailsModel(
      json['st']?.toString() ?? 'NA',
      json['country']?.toString() ?? 'NA',
      json['qualificationLevel']?.toString() ?? 'NA',
      json['srPageNumber']?.toString() ?? 'NA',
      json['hrmsEmployeeIdForQualification']?.toString() ?? 'NA',
      json['subjects']?.toString() ?? 'NA',
      json['employeeQualificationSrNo']?.toString() ?? 'NA',
      json['otherCourse']?.toString() ?? 'NA',
      json['marksPercentage']?.toString() ?? 'NA',
      json['courseDescription']?.toString() ?? 'NA',
      json['boardName']?.toString() ?? 'NA',
      json['duration']?.toString() ?? 'NA',
      json['passingYear']?.toString() ?? 'NA',
      json['marksDocumentUpload']?.toString() ?? 'NA',
      json['grade']?.toString() ?? 'NA',
      json['course']?.toString() ?? 'NA',
      json['institute']?.toString() ?? 'NA',
      json['qualificationAtJoiningTime']?.toString() ?? 'NA',
      json['place']?.toString() ?? 'NA',
      json['otherUniversity']?.toString() ?? 'NA',
      json['board']?.toString() ?? 'NA',
    );
  }

  @override
  String toString() {
    return 'EmployeeSRQualificationDetailsModel{st: $st,'
        ' country: $country, qualificationLevel: $qualificationLevel, srPageNumber: $srPageNumber, hrmsEmployeeIdForQualification: $hrmsEmployeeIdForQualification, subjects: $subjects, employeeQualificationSrNo: $employeeQualificationSrNo, otherCourse: $otherCourse, marksPercentage: $marksPercentage, courseDescription: $courseDescription, boardName: $boardName, duration: $duration, passingYear: $passingYear, marksDocumentUpload: $marksDocumentUpload, grade: $grade, course: $course, institute: $institute, qualificationAtJoiningTime: $qualificationAtJoiningTime, place: $place, otherUniversity: $otherUniversity, board: $board}';
  }
}