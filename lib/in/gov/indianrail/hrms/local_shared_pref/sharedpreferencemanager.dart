import 'package:shared_preferences/shared_preferences.dart';

class sharedpreferencemanager {
  static String SHARED_PREF_NAME = "mysharedpreference";
  static String SHARED_PREF_PIN_NAME = "mysharedkeypinpreference";
  static String SHARED_PREF_OTP_PIN_NAME = "mysharedkeyotppinpreference";
  static String SHARED_PREF_CREATE_OTP_PIN_NAME =
      "mysharedkeycreateotppinpreference";
  static String KEY_USERNAME = "username";
  static String KEY_PASSWORD = "password";
  static String USERNAME_KEY_PIN = "username_key_pin";
  static String KEY_PIN = "pin";
  static String isFingerPrint = "false";
  static String OTP_PIN = "otp_pin";

  static String CREATE_OTP_PIN = "create_otp_pin";
  static String EMPLOYEE_PROFILE = "my_employee_profile";
  static String EMPLOYEE_EMAIL = 'employeeEmail';
  static String EMPLOYEE_NAME = "employeeName";
  static String EMPLOYEE_GENDER = "employeeGender";
  static String EMPLOYEE_DESIG = "employeeDesig";
  static String EMPLOYEE_DESIG_CODE = "employeeDesigCode";
  static String EMPLOYEE_AUTYPE = "employeeAutype";
  static String EMPLOYEE_UNITNAME = "railwayUnitName";
  static String EMPLOYEE_AUTYPEDESC = "autype_desc";
  static String EMPLOYEE_UNITCODE = "railwayUnitCode";
  static String EMPLOYEE_DOB = "dateOfBirth";
  static String EMPLOYEE_DEPT = "departmentDescription";
  static String EMPLOYEE_DEPT_CODE = "departmentDescriptionCode";
  static String EMPLOYEE_MOBILENO = "mobileNo";
  static String EMPLOYEE_BILLUNIT = "billunit";
  static String EMPLOYEE_USERID = "userId";
  static String EMPLOYEE_IPASID = "ipasEmployeeId";
  static String EMPLOYEE_STATIONCODE = "stationCode";
  static String EMPLOYEE_AU_NO = "auNo";
  static String EMPLOYEE_PAY_LEVEL = "payLevel";
  static String EMPLOYEE_RAILWAYZONE = "railwayZone";
  static String EMPLOYEE_HRMSID = "hrmsEmployeeId";
  static String EMPLOYEE_USERTYPE = "stationCode";
  static String FIN_YEAR = "fin_year";
  static String SERVICESTATUS = "serviceStatus";
  static String TOKEN = "token";
  static String LIENUNIT="lienUnit";
  static String PRCPWINDOWFLAG = "prcpWidowFlag";
  static String CHECKOFFICER = "checkofficer";
  static String NPS_FLAG = "npsflag";
  static String RETIREMENT_DATE="superannuationDate";
  static String EMPLOYEE_APPOINTMENT_DATE = "appointmentDate";
  static String EMPLOYEE_RAILWAY_GROUP = "railwayGroup";

  Future<bool> employeeProfile(
      String employeeEmail,
      String employeeName,
      String gender,
      String designationDescription,
      String designationCode,
      String autype,
      String railwayUnitName,
      String autype_desc,
      String railwayUnitCode,
      String dateOfBirth,
      String departmentDescription,
      String departmentCode,
      String mobileNo,
      String billunit,
      String userId,
      String ipasEmployeeId,
      String stationCode,
      String AU_NO,
      String lienUnit,
      String payLevel,
      String hrmsEmployeeId,
      String railwayZone,
      String userType,
      String serviceStatus,
      String prcpWidowFlag,
      String superannuationDate,
      String appointmentDate,
      String railwayGroup) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(EMPLOYEE_EMAIL, employeeEmail);
    preferences.setString(EMPLOYEE_NAME, employeeName);
    preferences.setString(EMPLOYEE_GENDER, gender);
    preferences.setString(EMPLOYEE_DESIG, designationDescription);
    preferences.setString(EMPLOYEE_DESIG_CODE, designationCode);
    preferences.setString(EMPLOYEE_AUTYPE, autype);
    preferences.setString(EMPLOYEE_UNITNAME, railwayUnitName);
    preferences.setString(EMPLOYEE_AUTYPEDESC, autype_desc);
    preferences.setString(EMPLOYEE_UNITCODE, railwayUnitCode);
    preferences.setString(EMPLOYEE_DOB, dateOfBirth);
    preferences.setString(EMPLOYEE_DEPT, departmentDescription);
    preferences.setString(EMPLOYEE_DEPT_CODE, departmentCode);
    preferences.setString(EMPLOYEE_MOBILENO, mobileNo);
    preferences.setString(EMPLOYEE_BILLUNIT, billunit);
    preferences.setString(EMPLOYEE_USERID, userId);
    preferences.setString(EMPLOYEE_IPASID, ipasEmployeeId);
    preferences.setString(EMPLOYEE_STATIONCODE, stationCode);
    preferences.setString(EMPLOYEE_AU_NO, AU_NO);
    preferences.setString(LIENUNIT, lienUnit);
    preferences.setString(EMPLOYEE_PAY_LEVEL, payLevel);
    preferences.setString(EMPLOYEE_RAILWAYZONE, railwayZone);
    preferences.setString(EMPLOYEE_HRMSID, hrmsEmployeeId);
    preferences.setString(EMPLOYEE_USERTYPE, userType);
    preferences.setString(SERVICESTATUS, serviceStatus);
    preferences.setString(PRCPWINDOWFLAG, prcpWidowFlag);
    preferences.setString(RETIREMENT_DATE, superannuationDate);
    preferences.setString(EMPLOYEE_APPOINTMENT_DATE, appointmentDate);
    preferences.setString(EMPLOYEE_RAILWAY_GROUP, railwayGroup);
    return true;
  }

  Future<String?> getEmployeeRailwayGroup() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(EMPLOYEE_RAILWAY_GROUP);
  }

  Future<String?> getEmployeeAppointmentDate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(EMPLOYEE_APPOINTMENT_DATE);
  }

  Future<String?> getEmployeeName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(EMPLOYEE_NAME);
  }

  Future<String?> getEmployeeEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(EMPLOYEE_EMAIL);
  }

  Future<String?> getToekn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(TOKEN);
  }

  Future<String?> getEmployeeGender() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(EMPLOYEE_GENDER);
  }

  Future<String?> getEmployeeDesig() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(EMPLOYEE_DESIG);
  }

  Future<String?> getEmployeeAutype() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(EMPLOYEE_AUTYPE);
  }

  Future<String?> getEmployeeUnitname() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(EMPLOYEE_UNITNAME);
  }

  Future<String?> getEmployeeAutypedesc() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(EMPLOYEE_AUTYPEDESC);
  }

  Future<String?> getEmployeeUnitcode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(EMPLOYEE_UNITCODE);
  }

  Future<String?> getEmployeeDob() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(EMPLOYEE_DOB);
  }

  Future<String?> getEmployeeDept() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(EMPLOYEE_DEPT);
  }

  Future<String?> getEmployeeIpasid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(EMPLOYEE_IPASID);
  }

  getEmployeeBillunit() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(EMPLOYEE_BILLUNIT);
  }

  Future<String?> getEmployeeUserid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(EMPLOYEE_USERID);
  }

  Future<String?> getEmployeeAuNo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(EMPLOYEE_AU_NO);
  }
  Future<String?> getEmployeeLienUnit() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(LIENUNIT);
  }

  Future<String?> getEmployeeMobileno() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(EMPLOYEE_MOBILENO);
  }

  getEmployeeStationcode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(EMPLOYEE_STATIONCODE);
  }

  Future<String?> getEmployeeRailwayzone() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(EMPLOYEE_RAILWAYZONE);
  }

  Future<String?> getEmployeeHrmsid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(EMPLOYEE_HRMSID);
  }

  Future<String?> getEmployeeUsertype() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(EMPLOYEE_USERTYPE);
  }

  Future<bool> userlogin(String username, String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(KEY_USERNAME, username);
    preferences.setString(KEY_PASSWORD, password);
    return true;
  }

  Future<bool> editCommunication(String email, String phoneNo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(EMPLOYEE_EMAIL, email);
    preferences.setString(EMPLOYEE_MOBILENO, phoneNo);
    return true;
  }

  Future<bool> token(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(TOKEN, token);

    return true;
  }

  Future<bool> userImage(String imagePath) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("UserImage", imagePath);
    // preferences.setString(USERNAME_KEY_PIN,username);
    return true;
  }

  Future<String?> getuserImage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString("UserImage");
  }

  Future<bool> userpin(String pin, String username) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(KEY_PIN, pin);
    preferences.setString(USERNAME_KEY_PIN, username);
    return true;
  }

  Future<bool> userfingerPrint(String yesNo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(isFingerPrint, yesNo);
    return true;
  }

  Future<bool> isfingerPrint() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString(isFingerPrint) != null) {
      //Check User Is Not logged Out
      return true;
    }
    return false; //User not loggedIn
  }

  Future<bool> otppin(String pin) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(OTP_PIN, pin);
    return true;
  }

  Future<bool> createotppin(String createotppin) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(CREATE_OTP_PIN, createotppin);
    return true;
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString(KEY_USERNAME) != null) {
      //Check User Is Not logged Out
      return true;
    }
    return false; //User not loggedIn
  }

  Future<bool> isKeyIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString(KEY_PIN) != null) {
      //Check User Is Not logged Out
      return true;
    }
    return false; //User not loggedIn
  }

  Future<bool> isOtpIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString(OTP_PIN) != null) {
      //Check User Is Not logged Out
      return true;
    }
    return false; //User not loggedIn
  }

  Future<bool> isCreateOtpPin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString(CREATE_OTP_PIN) != null) {
      //Check User Is Not logged Out
      return true;
    }
    return false; //User not loggedIn
  }

  Future<bool> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    return true;
  }

  Future<bool> otpClear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    return true;
  }

  Future<bool> clearCreateOtpPin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    return true;
  }

  Future<bool> keyClear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    return true;
  }

  Future<String?> getUsername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(KEY_USERNAME);
  }

  Future<String?> getPassword() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(KEY_PASSWORD);
  }

  Future<String?> getuserpin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(KEY_PIN);
  }

  Future<String?> getotppin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(OTP_PIN);
  }

  Future<String?> getKeyPinUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(USERNAME_KEY_PIN);
  }

  Future<bool> forgetpin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    return true;
  }

  Future finyear(
    String finyear,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(FIN_YEAR, finyear);
  }

  Future<String?> get_finyear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(FIN_YEAR);
  }

  Future nps_flag(
    String npsflag,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(NPS_FLAG, npsflag);
  }

  Future<String?> get_nps_flag() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(NPS_FLAG);
  }
  Future<String?> getPayLevel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(EMPLOYEE_PAY_LEVEL);
  }

  Future checkOfficer(
    String checkofficer,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(CHECKOFFICER, checkofficer);
  }

  Future<String?> get_checkOfficer() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(CHECKOFFICER);
  }

  Future<String?> getServiceStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(SERVICESTATUS);
  }

  Future<String?> getPrcpWindowFlag() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(PRCPWINDOWFLAG);
  }

  Future<String?> getRetirementDate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(RETIREMENT_DATE);
  }
  Future<String?> getDesignationCode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(EMPLOYEE_DESIG_CODE);
  }

  Future<String?> getDepartmentCode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(EMPLOYEE_DEPT_CODE);
  }

}
