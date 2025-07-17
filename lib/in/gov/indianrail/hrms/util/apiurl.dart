import '../config/BuildConfig.dart';

class UtilsFromHelper {
  ///Production
  String PROD_URL = "https://hrms.indianrail.gov.in";
  String PROD_ENV = "/HRMS";

  String DEV_URL = "https://203.176.112.80";

  //String DEV_URL= "http://172.16.28.47:8085";

  String DEV_ENV = "/HRMSDEV";
  String VERSION_TYPE = "DEV";

  String getValueFromKey(String key) {
    return getValueFromKeyPrivate(key);
  }

  String getValueFromKeyPrivate(String key) {
    String URL = "";
    String ENV = "";
    if (BuildConfig.DEBUG) {
      URL = DEV_URL;
      ENV = DEV_ENV;
      VERSION_TYPE = "DEV";
    } else {
      URL = PROD_URL;
      ENV = PROD_ENV;
      VERSION_TYPE = "";
    }
    switch (key) {
      //live url for Development...
      case "versiontype":
        return VERSION_TYPE;
      case "login_url":
        return URL + "/webservice/login/processLogin?";
      case "user_details":
        return URL + "/webservice/user/get_user_details";
      case "file_download":
        return URL + "/webservice/download2?";
      case "upload_profile_image":
        return URL + "/webservice/uploadprofileimage?";
      case "remove_profile_image":
        return URL + "/webservice/removeprofileimage?";
      case "otp_verification":
        return URL + "/webservice/otpVerification?";
      case "electronic_sr":
        return URL +
            ENV +
            "/android/esr-view-android?authorizationToken=HrMs@T0k3n&hrmsId=";
      case "dashboard_url":
        return URL +
            ENV +
            "/android/dashboard?authorizationToken=HrMs@T0k3n&hrmsId=";
      case "last_login_message":
        return URL + "/webservice/lastLoginMessage?";
      case "registration":
        return URL + "/webservice/registration/getEmpNameByEmpId?";
      case "registrationOTPVerification":
        return URL + "/webservice/registration/transactionOTPVerification?";
      case "mobile_app_version":
        return URL + "/webservice/mobileAppVersion?";
      case "mobile_module_check":
        return URL + "/webservice/mobileModule?";
      case "mobile_device_id":
        return URL + "/webservice/mobileDeviceCheck?";
      case "save_previous_mobile_details":
        return URL + "/webservice/savePreviousMobileDetails?";
      case "api_token":
        return URL + "/webservice/login/token";

//E-SR
      case "show_e_sr_biodata":
        return URL + "/webservice/show-employee-esr-bioData";
      case "show_e_sr_appointment":
        return URL + "/webservice/show-employee-esr-appointment";
      case "show_e_sr_family":
        return URL + "/webservice/show-employee-esr-family";
      case "show_e_sr_qualification":
        return URL + "/webservice/show-employee-esr-qualification";
      case "show_e_sr_punishment":
        return URL + "/webservice/show-employee-esr-punishment";
      case "show_e_sr_promotions":
        return URL + "/webservice/show-employee-esr-promotions";
      case "show_e_sr_nominations":
        return URL + "/webservice/show-employee-esr-nominations";
      case "show_e_sr_award":
        return URL + "/webservice/show-employee-esr-award";
      case "show_e_sr_transfer":
        return URL + "/webservice/show-employee-esr-transfer";
      case "show_e_sr_leave":
        return URL + "/webservice/show-employee-esr-leave";
      case "show_e_sr_paychange_history":
        return URL + "/webservice/show-employee-esr-paychange-history";
      case "show_e_sr_publications":
        return URL + "/webservice/show-employee-esr-publications";
      case "show_e_sr_deputations":
        return URL + "/webservice/show-employee-esr-deputations";
      case "show_e_sr_training":
        return URL + "/webservice/show-employee-esr-training";

      //Pass Module
      case "pass_application_status":
        return URL + "/webservice/pass/passapplicationstatus";
      case "issued_pass_list":
        return URL + "/webservice/pass/issuedpasslist";
      case "issued_pass_sms":
        return URL + "/webservice/pass/issuedpassdetailsms";
      case "issued_pass_otpgeneration":
        return URL + "/webservice/pass/otpgeneration";
      case "issued_passpdf":
        return URL + "/webservice/pass/issuedpasspdf";
      case "delete_pass":
        return URL + "/webservice/pass/delete-draft-pass-application";
      /*@Minakshi*/

      case "pass_set_list":
        return URL + "/webservice/pass/passset-list";
      case "get_pass_set_list":
        return URL + "/webservice/pass/get-passset-list";
      case "get_station_des":
        return URL + "/webservice/pass/getSationDes";
      case "get_station":
        return URL + "/webservice/pass/getSation";

      case "get_family_list":
        return URL + "/webservice/pass/get_basic_family_details";
      case "submit_pass":
        return URL + "/webservice/pass/submit-pass-application_new";
      case "cancel-pass":
        return URL + "/webservice/pass/cancel-pass";
      case "pass-application_list":
        return URL + "/webservice/pass/pass-application";
      case "pass-draft_details":
        return URL + "/webservice/pass/get-pass-application";
      case "pass-withdraw":
        return URL + "/webservice/pass/withdraw-pass-application";

      //update_communication_details
      case "get_communication_details":
        return URL + "/webservice/user_profile/get_user_communication_details";
      case "update_communication_details":
        return URL + "/webservice/user_profile/mobilesUpdate";

      // /pass/cancel-pass
      //pass/save-pass-application

      //Localhost 172.16.12.101 //IP Address
      case "local_login_url":
        return URL + "/login/processLogin?";
      case "local_file_download":
        return URL + "/download2?";
      case "local_otp_verification":
        return URL + "otpVerification?";

      case "hrml_link":
        return "https://hrms.indianrail.gov.in/HRMS/";

      case "change_password":
        return URL + "/webservice/changePassword";
      case "get_change_password_history":
        return URL + "/webservice/getlast_password_details";
      case "last_change_password_datetime":
        return URL + "/webservice/getlast_password";
      case "view_update_family_ess":
        return URL + ENV;
      case "report_emp":
        return URL + ENV;

      // case "Add_reporting_officer":
      //
      //   return URL+"/webservice/add_reporting_section";
      // case "get_reporting_section":
      //   return URL+"/webservice/select_reporting_section";
      case "forgot_password_details":
        return URL + "/webservice/forgot_password_details";
      case "match_transaction_otp":
        return URL + "/webservice/match_transaction_otp";
      case "forgot_get_change_password_history":
        return URL + "/webservice/forgot_getlast_password_details";
      case "get_emp_details12":
        return URL + "/webservice/get_emp_details";
      case "get_AllStates":
        return URL + "/webservice/getAllStates";
      case "get_districts_byState":
        return URL + "/webservice/get_districts_byState";

      /*Apar*/
      case "Add_reporting_officer":
        return URL + "/webservice/apar/add_reporting_section";
      case "get_reporting_section":
        return URL + "/webservice/apar/select_reporting_section";
      case "check_officer":
        return URL + "/webservice/apar/check_officer_gazetted";
      case "list_emp_underofficer":
        return URL + "/webservice/apar/listempunderofficer";
      case "update_re_officer":
        return URL + "/webservice/apar/update_re_officer";
      case "update_accepting_officer":
        return URL + "/webservice/apar/update_accepting_officer";
      case "select_no_gazetted_officer":
        return URL + "/webservice/apar/select_no_gazetted_officer";
      case "get_fin_year":
        return URL + "/webservice/apar/get_fin_year";
      case "select_self_apprasial":
        return URL + "/webservice/apar/select_self_apprasial";
      case "count_available_emp":
        return URL + "/webservice/apar/count_available_emp";
      case "count_pending_emp_reporting":
        return URL + "/webservice/apar/count_pending_emp_reporting";
      case "count_pending_emp_reviewing":
        return URL + "/webservice/apar/count_pending_emp_reviewing";
      case "count_pending_emp_accepting":
        return URL + "/webservice/apar/count_pending_emp_accepting";

      case "add_self_appraisal_emp":
        return URL + "/webservice/apar/add_self_appraisal_emp";
      case "details_self_appraisal":
        return URL + "/webservice/apar/details_self_appraisal";

      case "resend_otp":
        return URL + "/webservice/otp/resendOtp";

      case "get_apar_year":
        return URL + "/webservice/apar/get_apar_year";
      case "downloadAparUrl":
        return URL + "/webservice/apar/download-apar-file";

/*Ess Module*/

      case "ess_basic_info":
        //ess/
        return URL + "/webservice/ess/get_basic_tab_details";
      //return URL+"/webservice/ess/getbasicinfotab";
      // http://203.176.112.80/webservice/ess/submit-basic-info-by-employee
      case "save_ess_employee":
        return URL + "/webservice/ess/submit-basic-info-by-employee";
      case "get_change_request_status":
        //http://203.176.112.80/webservice/get-last-change-request
        return URL + "/webservice/get-last-change-request";
      case "upload_file":
        return URL + "/webservice/upload-file";
      /*Grivance Module*/
      case "get_grievance_category_complaint":
        return URL + "/webservice/grievance/get_grievance_category";
      case "get_grievance_sub_category_complaint":
        return URL + "/webservice/grievance/get_grievance_sub_category";
      case "save_complaint_data":
        return URL + "/webservice/grievance/save-grievance-api";
      case "find_employee_type":
        return URL + "/webservice/grievance/find_employee";
      case "grievance_status":
        return URL + "/webservice/grievance/get_complaint_status";
      case "get_total_count_remarks":
        return URL + "/webservice/grievance/get_total_count_remarks";
      case "get_communicationInfo":
        return URL + "/webservice/ess/get-communicationInfo";
      case "save_communicationInfo":
        return URL +
            "/webservice/ess/save-draft-communication-details-by-employee";
      case "get_all_states":
        return URL + "/webservice/ess/get_all_state";
      case "get_get_districts_byState":
        return URL + "/webservice/ess/get_get_districts_byState";
      case "get_loanapplication_details":
        return URL + "/webservice/pfloan/get_loanapplication_details";
      case "submit_pf_loan_application":
        return URL + "/webservice/pfloan/submitpfloan";
      case "get_withdrawal_Reasons":
        return URL + "/webservice/pfloan/getwithdrawalReasons";
      case "get_pfloan_applocationlist":
        return URL + "/webservice/pfloan/pf-applicationslist";

      case "withdraw_pfloan_applocation":
        return URL + "/webservice/pfloan/withdrawPfLoanApplication";
      case "check_nps":
        return URL + "/webservice/pfloan/check_nps_details";

      /*Leave Module*/
      case "getAllZones":
        return URL + "/webservice/get-zones";
      case "getDivisionsByZones":
        return URL + "/webservice/get-divisions-by-zones";
      case "getAllDepartments":
        return URL + "/webservice/get-all-departments";
      case "getSubDepartments":
        return URL + "/webservice/emp-master/get-sub-department";
      case "getLeaveBalanceDetails":
        return URL + "/webservice/get-basic-leave-balances-by-employee";
      case "getLeavesLeft":
        return URL + "/webservice/getLeavesLeft";
      case "isLeaveAvailed":
        return URL + "/webservice/is-leave-applied";
      case "show_past_sanction_leave_details":
        return URL + "/webservice/get-leaves-history-by-employee";
      case "fetch_my_leave_details":
        return URL + "/webservice/fetch-my-leave-details";
      case "get_frwd_leave_authorities_list":
        return URL + "/webservice/get-authorities-by-zone-unit-dept";
      case "submit_leave_application":
        return URL + "/webservice/submit-leave-application";
      case "cancel_leave_application":
        return URL + "/webservice/cancel-leave-application";
      case "withdraw_leave_application":
        return URL + "/webservice/withdraw-leave-application";
      case "fetch_leave_details_to_view":
        return URL + "/webservice/fetch-my-leave-details-to-view";
      case "get_employee_name_by_hrms_id":
        return URL + "/webservice/emp-master/getEmpNameByEmpId";
      case  "leave_file_download":
        return URL + "/webservice/leave-application/downloadpdf";
      case  "is_overlapping_leave":
        return URL + "/webservice/is-overlapping-leave";
      case "qrdata_url":
        return URL + "/webservice/qrcodereader";

      default:
        return "";
    }

    //development
    /* switch (key) {
    //live url for Development...
      case "versiontype":
        return VERSION_TYPE;
      case "login_url":
        return URL+"/login/processLogin?";
      case "file_download":
        return URL+"/download2?";
      case "otp_verification":
        return URL+"/otpVerification?";
      case "electronic_sr":
        return URL+ENV+"/android/esr-view-android?authorizationToken=HrMs@T0k3n&hrmsId=";
      case "dashboard_url":
        return URL+ENV+"/android/dashboard?authorizationToken=HrMs@T0k3n&hrmsId=";
      case "last_login_message":
        return URL+"/lastLoginMessage?";
      case "registration":
        return URL+"/registration/getEmpNameByEmpId?";
      case "registrationOTPVerification":
        return URL+"/registration/transactionOTPVerification?";
      case "mobile_app_version":
        return URL+"/mobileAppVersion?";
      case "api_token":
        return URL+"/login/token";

    //Pass Module
      case "pass_application_status":
        return URL+"/pass/passapplicationstatus";
      case "issued_pass_list":
        return URL+"/pass/issuedpasslist";
      case "issued_pass_sms":
        return URL+"/pass/issuedpassdetailsms";
      case "issued_pass_otpgeneration":
        return URL+"/pass/otpgeneration";
      case "issued_passpdf":
        return URL+"/pass/issuedpasspdf";
      case "delete_pass":
        return URL+"/pass/delete-draft-pass-application";
    /*@Minakshi*/


      case "pass_set_list":
        return URL+"/pass/passset-list";
      case "get_pass_set_list":
        return URL+"/pass/get-passset-list";
      case "get_station_des":
        return URL+"/pass/getSationDes";
      case "get_station":
        return URL+"/pass/getSation";

      case "get_family_list":
        return URL+"/pass/get_basic_family_details";
      case "submit_pass":
        return URL+"/pass/submit-pass-application_new";
      case "cancel-pass":
        return URL+"/pass/cancel-pass";
      case "pass-application_list":
        return URL+"/pass/pass-application";
      case "pass-draft_details":
        return URL+"/pass/get-pass-application";
    //update_communication_details
      case "get_communication_details":
        return URL+"/user_profile/get_user_communication_details";
      case "update_communication_details":
        return URL+"/user_profile/mobilesUpdate";


    // /pass/cancel-pass
    //pass/save-pass-application



    //Localhost 172.16.12.101 //IP Address
      case "local_login_url":
        return URL+"/login/processLogin?";
      case "local_file_download":
        return URL+"/download2?";
      case "local_otp_verification":
        return URL+"otpVerification?";

      case "hrml_link":
        return "https://hrms.indianrail.gov.in/HRMS/";


      case "change_password":
        return URL+"/changePassword";
      case "get_change_password_history":
        return URL+"/getlast_password_details";
      case "last_change_password_datetime":
        return URL+"/getlast_password";
      case "view_update_family_ess":
        return URL+ENV;
      case "report_emp":
        return URL+ENV;

    // case "Add_reporting_officer":
    //
    //   return URL+"/add_reporting_section";
    // case "get_reporting_section":
    //   return URL+"/select_reporting_section";
      case "forgot_password_details":
        return URL+"/forgot_password_details";
      case "match_transaction_otp":
        return URL+"/match_transaction_otp";
      case "forgot_get_change_password_history":
        return URL+"/forgot_getlast_password_details";
      case "get_emp_details12":
        return URL+"/get_emp_details";
      case "get_AllStates":
        return URL+"/getAllStates";
      case "get_districts_byState":
        return URL+"/get_districts_byState";



    /*Apar*/
      case "Add_reporting_officer":

        return URL+"/add_reporting_section";
      case "get_reporting_section":
        return URL+"/select_reporting_section";
      case "check_officer":
        return URL+"/check_officer_gazetted";
      case "list_emp_underofficer":
        return URL+"/listempunderofficer";
      case "update_re_officer":
        return URL+"/update_re_officer";
      case "update_accepting_officer":
        return URL+"/update_accepting_officer";
      case "select_no_gazetted_officer":
        return URL+"/apar/select_no_gazetted_officer";
      case "get_fin_year":



        return URL+"/apar/get_fin_year";
      case "select_self_apprasial":
        return URL+"/apar/select_self_apprasial";
      case "count_available_emp":
        return URL+"/apar/count_available_emp";
      case "count_pending_emp_reporting":
        return URL+"/apar/count_pending_emp_reporting";
      case "count_pending_emp_reviewing":
        return URL+"/apar/count_pending_emp_reviewing";
      case "count_pending_emp_accepting":
        return URL+"/apar/count_pending_emp_accepting";

      case "add_self_appraisal_emp":
        return URL+"/apar/add_self_appraisal_emp";
      case "details_self_appraisal":
        return URL+"/apar/details_self_appraisal";

      case "resend_otp":
        return URL+"/otp/resendOtp";

/*Ess Module*/

      case "ess_basic_info":
      //ess/
        return URL+"/ess/get_basic_tab_details";
    //return URL+"/ess/getbasicinfotab";
    // http://203.176.112.80/ess/submit-basic-info-by-employee
      case "save_ess_employee":
        return URL+"/ess/submit-basic-info-by-employee";
      case "get_change_request_status":
      //http://203.176.112.80/get-last-change-request
        return URL+"/get-last-change-request";
      case "upload_file":
        return URL+"/upload-file";
    /*Grivance Module*/
      case "get_grievance_category_complaint":
        return URL+"/grievance/get_grievance_category";
      case "get_grievance_sub_category_complaint":
        return URL+"/grievance/get_grievance_sub_category";
      case "save_complaint_data":
        return URL+"/grievance/save-grievance-api";
      case "find_employee_type":
        return URL+"/grievance/find_employee";
      case "grievance_status":
        return URL+"/grievance/get_complaint_status";
      case "get_total_count_remarks":
        return URL+"/grievance/get_total_count_remarks";
      case "get_communicationInfo":
        return URL+"/ess/get-communicationInfo";
      case "save_communicationInfo":
        return URL+"/ess/save-draft-communication-details-by-employee";
      case "get_all_states":
        return URL+"/ess/get_all_state";
      case "get_get_districts_byState":
        return URL+"/ess/get_get_districts_byState";
      case "get_loanapplication_details":
        return URL+"/pfloan/get_loanapplication_details";
      case "submit_pf_loan_application":
        return URL+"/pfloan/submitpfloan";
      case "get_withdrawal_Reasons":
        return URL+"/pfloan/getwithdrawalReasons";
      case "get_pfloan_applocationlist":
        return URL+"/pfloan/pf-applicationslist";

      case "withdraw_pfloan_applocation":
        return URL+"/pfloan/withdrawPfLoanApplication";
      case "check_nps":
        return URL+"/pfloan/check_nps_details";




      default:
        return null;
    }*/
  }
}
