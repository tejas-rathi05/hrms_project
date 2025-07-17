import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'dart:math';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_filex/open_filex.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/issuedPass/Station_List.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/local_shared_pref/sharedpreferencemanager.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/login/security/hrmstokenplugin.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/util/apiurl.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hrms_cris/in/gov/indianrail/hrms/main/demo_selectlist.dart';
import '../issuedPass/Station_List.dart';
import 'my_pfloan.dart';

bool _hasBeenPressed = false;

class Save_PF extends StatefulWidget {
  var applicationNo = "";

  Save_PF(this.applicationNo);
  @override
  Save_PFState createState() => Save_PFState();
}

class Save_PFState extends State<Save_PF> {
  String result_map = "";
  var files;
  var dateb,
      dateappointmnet,
      dateretirement,
      withdrawal_reason_ipas_code = "",
      ipas_pf_loan_application_number = "",
      father_name,
      current_main_railway_unit,
      bill_unit,
      current_railway_unit,
      current_station,
      withdrawal_type,
      withdrawal_reason,
      applied_amount,
      maximum_eligible_amount,
      number_of_installments,
      installment_amount,
      remarks,
      freehold,
      constructioncost,
      constructionplan,
      locationflat,
      societyname,
      ddaflatlocation,
      daysholarfield,
      wardname,
      collegename,
      patientname,
      typeofpatient,
      reimburavail,
      pay_level,
      department,
      designation,
      hospitalname,
      service_years_completed,
      service_months_completed,
      date_of_retirement,
      date_of_appointment,
      pan_number,
      pf_number,
      account_unit,
      bank_ifsc_code,
      bank_name,
      bank_account_number,
      payment_mode,
      pf_balance,
      total_outstanding_amount;

  late Directory directory;
  String path = "";
  bool plan_progress_flag = false;
  bool doc_progress_flag = false;
  List data_listreason = [];
  List<ReasonList> selected_listreason = [];
  String? doc_file_path;
  String? plan_file_path;
  String? _selectedtype;
  String? _selectedreason;
  String draftReason = "";
  bool _selected = false;
  String basicPay = "0";
  var pfBalance = "0";
  int pfBalance_200 = 0;
  int remaining_months = 0;
  String sendw_type = "", sendw_reason = "";
  late String result;
  var doc_fileUploaded = "";
  var plan_fileUploaded = "";
  var doc_fileUploadFlag = false;
  var plan_fileUploadFlag = false;
  var withdrawal_percentage = "0", basic_pay_multiplier = "0";
  double percent = 0.0;
  bool conditonFlag = false,
      text_no_installmentFlag = false,
      text_amount_installmentFlag = false;
  List<String> w_type = ['Final', "Temporary"];
  String? _selectedlease;
  String senditem = "";
  String send_lease = "";
  List<String> _leaselist = ['Free Holding', "Lease"];
  TextEditingController society_name = TextEditingController();
  TextEditingController costConstruction = TextEditingController();
  TextEditingController locationMeasurment = TextEditingController();
  TextEditingController ddaFlat = TextEditingController();
  TextEditingController appliedAmount = TextEditingController();
  TextEditingController maximumEligibility = TextEditingController();
  TextEditingController noofInstallments = TextEditingController();
  TextEditingController installmentAmount = TextEditingController();
  TextEditingController dependentName = TextEditingController();
  String? _selectedday;
  TextEditingController namedos = TextEditingController();
  TextEditingController classInstitution = TextEditingController();
  String? mobileNo, validTo, otp_text;
  String? _selectedreimbursement;
  // String _selectedday;

  String? _selectedindore_outdoor;
  List<String> reimbursementlist = [
    "Reimbursement Available",
    "Reimbursement Not Available"
  ];
  List<String> day_list = ['Day scholar', "Hostler"];

  List<String> indoor_outdoor = ["Indoor Patient", "Outdoor Patient"];
  TextEditingController name_relation = TextEditingController();
  TextEditingController name_hospital = TextEditingController();
  Future getotp() async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    String basicAuth;
    String url =
        new UtilsFromHelper().getValueFromKey("forgot_password_details");

    basicAuth = await Hrmstokenplugin.hrmsToken;

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    Map map = {
      'hrmsId': await pref.getEmployeeHrmsid(),
    };

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    if (responseJSON['status']) {
      setState(() {
        validTo = responseJSON['valid_to'];
        mobileNo = responseJSON['replacemobileno'];
        otp_text = responseJSON['otp_final'];
      });
      showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog(
            Dob: dateb,
            DateAppintmnet: dateappointmnet,
            DateRetirement: dateretirement,
            Withdrawal_reason_ipas_code: withdrawal_reason_ipas_code,
            Ipas_pf_loan_application_number: ipas_pf_loan_application_number,
            Father_name: father_name,
            Current_main_railway_unit: current_main_railway_unit,
            Bill_unit: bill_unit,
            Current_railway_unit: current_railway_unit,
            Current_station: current_station,
            Withdrawal_type: sendw_type,
            Withdrawal_reason: _selectedreason!,
            Applied_amount: appliedAmount.text,
            Maximum_eligible_amount: maximumEligibility.text,
            Number_of_installments: noofInstallments.text,
            Installment_amount: installmentAmount.text,
            Remark: dependentName.text,
            Free_hold: send_lease,
            Construction_cost: costConstruction.text,
            Construction_plan: constructionplan,
            Location_flat: locationMeasurment.text,
            Societyname: society_name.text,
            Ddaflatlocation: ddaFlat.text,
            Daysholarfield: _selectedday!,
            Wardname: namedos.text,
            Collegename: classInstitution.text,
            Patientname: name_relation.text,
            Typeofpatient: _selectedindore_outdoor!,
            Reimburavail: _selectedreimbursement!,
            Pay_level: pay_level,
            Department: department,
            Designation: designation,
            Hospitalname: name_hospital.text,
            Service_years_completed: service_years_completed,
            Service_months_completed: service_months_completed,
            Date_of_retirement: dateretirement,
            Date_of_appointment: dateappointmnet,
            Pan_number: pan_number,
            Pf_number: pf_number,
            Account_unit: account_unit,
            BankIfscCode: bank_ifsc_code,
            BankName: bank_name,
            BasicPay: basicPay,
            BankAccountNumber: bank_account_number,
            PaymentMode: payment_mode,
            PfBalance: pf_balance,
            TotalOutstandingAmount: total_outstanding_amount,
            Application_no: widget.applicationNo,
            validdate: validTo!,
            mobileno: mobileNo!,
            varifiedOtp: otp_text!,
            filename: doc_fileUploaded,
            fileconstructionPlan: plan_fileUploaded),
      );
    } else {
      // Fluttertoast.showToast(
      //     msg: responseJSON['message'],
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIos: 5,
      //     backgroundColor: Colors.pink,
      //     textColor: Colors.white,
      //     fontSize: 14.0
      // );
    }
  }

  Future save_as_draft() async {
    final String url =
        new UtilsFromHelper().getValueFromKey("submit_pf_loan_application");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    sharedpreferencemanager pref = sharedpreferencemanager();

    Map map = {
      "applicationNo": widget.applicationNo,
      "mobileNo": await pref.getEmployeeMobileno(),
      "status": "DS",
      "service_years_completed": service_years_completed,
      "service_months_completed": service_months_completed,
      "ipas_no": await pref.getEmployeeIpasid(),
      "hrms_id": await pref.getEmployeeHrmsid(),
      "name": await pref.getEmployeeName(),
      "date_of_birth": dateb,
      "father_name": father_name,
      "date_of_retirement": dateretirement,
      "date_of_appointment": dateappointmnet,
      "current_main_railway_unit": current_main_railway_unit,
      "current_railway_unit": current_railway_unit,
      "current_station": current_station,
      "bill_unit": bill_unit,
      "department": department,
      "designation": designation,
      "basic_pay": int.parse(basicPay),
      "pay_level": pay_level,
      "pan_number": pan_number,
      "pf_number": pf_number,
      "account_unit": account_unit,
      "bank_ifsc_code": bank_ifsc_code,
      "bank_name": bank_name,
      "bank_account_number": bank_account_number,
      "payment_mode": payment_mode,
      "pf_balance": int.parse(pf_balance),
      "withdrawal_type": sendw_type,
      "withdrawal_reason": _selectedreason,
      "submitting_user_id": await pref.getEmployeeHrmsid(),
      "remarks": dependentName.text,
      "transaction_date_time": "",
      "ipas_pf_loan_application_number": ipas_pf_loan_application_number,
      "withdrawal_reason_ipas_code": withdrawal_reason_ipas_code,
      "document_id": doc_fileUploaded,
      "otpSubmit": "",
      "patientName": name_relation.text,
      "hospitalName": name_hospital.text,
      "typeOfPatient": _selectedindore_outdoor,
      "reimburAvail": _selectedreimbursement,
      "ddaFlatLocation": ddaFlat.text,
      "wardName": namedos.text,
      "collegeName": classInstitution.text,
      "daySholarField": _selectedday,
      "locationFlat": locationMeasurment.text,
      "freehold": senditem,
      "societyName": society_name.text,
      "constructionPlan": plan_fileUploaded,
      "constructionCost": costConstruction.text,
      "total_outstanding_amount": int.parse(total_outstanding_amount),
      "number_of_installments": int.parse(noofInstallments.text),
      "applied_amount": int.parse(appliedAmount.text),
      "maximum_eligible_amount": int.parse(maximumEligibility.text),
      "installment_amount": int.parse(installmentAmount.text)
    };

    HttpClientRequest request = await client.postUrl(
      Uri.parse(url),
    );
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));

    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    if (responseJSON['result']) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: 'Your PF application save successfully ' +
              responseJSON['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          //timeInSecForIos: 15,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);
    }
    setState(() {
      _hasBeenPressed = false;
    });
  }

  void _changed(bool visibility, String field, String type) {
    setState(() {
      if (field == "start") {
        if (type == "uploaddocument") {
          doc_progress_flag = visibility;
          plan_progress_flag = false;
        } else {
          doc_progress_flag = false;
          plan_progress_flag = visibility;
        }
      }
      if (field == "finish") {
        if (type == "uploaddocument") {
          doc_progress_flag = visibility;
          plan_progress_flag = false;
        } else {
          doc_progress_flag = false;
          plan_progress_flag = visibility;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    get_application_details();

    getFiles();
  }

  Future downloadPdf(String type, String code) async {
    sharedpreferencemanager pref = sharedpreferencemanager();
    var hrmsId = (await pref.getEmployeeHrmsid())! + "" + code;
    Fluttertoast.showToast(
        msg: "Processing, please wait…!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        // timeInSecForIos: 8,
        backgroundColor: Colors.pink,
        textColor: Colors.white,
        fontSize: 14.0);

    Map map = {'folder': "PFLOAN", 'file': hrmsId, 'ext': "pdf"};

    final String url = new UtilsFromHelper().getValueFromKey("file_download");
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', "application/json");
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    String msgtext = responseJSON['message'];
    String filepdf = responseJSON['fileString'];
    if (responseJSON['fileString'] != '[]') {
      if (type == "uploaddocument") {
        doc_fileUploadFlag = true;
      } else {
        plan_fileUploadFlag = true;
      }
      _write(filepdf, hrmsId);
    } else {}
  }

  Future _write(String textmy, String hrmsId) async {
    directory = await Directory('$path/HRMS').create(recursive: true);
    final File file = File('${directory.path}/PFLOAN${hrmsId}.pdf');
    var base64str = base64.decode(textmy);
    await file.writeAsBytes(base64str);
    //OpenFile.open('$path/HRMS/PFLOAN${hrmsId}.pdf');
    Fluttertoast.showToast(
        msg: "Downloaded Successfully:" +
            directory.path +
            '/PFLOAN${hrmsId}.pdf',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        //timeInSecForIos: 15,
        backgroundColor: Colors.pinkAccent,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  /*void getFiles() async {
    //asyn function to get list of files
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    var root = storageInfo[0]
        .rootDir; //storageInfo[1] for SD card, geting the root directory
    var fm = FileManager(root: Directory(root)); //
    files = await fm.filesTree(
        excludedPaths: ["/storage/emulated/0/Android"],
        extensions: ["pdf"] //optional, to filter files, list only pdf files
        );
    setState(() {}); //update the UI
  }*/
  Future<List<File>> getFiles() async {
    List<File> fileList = [];

    Directory? externalStorageDir = await getExternalStorageDirectory();
    if (externalStorageDir != null) {
      Directory directory = Directory(externalStorageDir.path);
      List<FileSystemEntity> files = directory.listSync();

      for (FileSystemEntity file in files) {
        if (file is File) {
          fileList.add(file);
        }
      }
    }

    return fileList;
  }

  Future getselecteddata(String categoryReason) async {
    selected_listreason.forEach((element) {
      if (categoryReason.compareTo(element.reason_code) == 0) {
        setState(() {
          basic_pay_multiplier = element.basic_pay_multiplier.toString();
          withdrawal_percentage = element.withdrawal_percentage.toString();
        });
      }
    });
  }

  Future get_application_details() async {
    //path = await ExtStorage.getExternalStoragePublicDirectory(
    //   ExtStorage.DIRECTORY_DOWNLOADS);
    String path;
    Directory? externalStorageDirectory = await getExternalStorageDirectory();
    List<Directory>? externalStorageDirectories =
        await getExternalStorageDirectories();

    if (externalStorageDirectory != null) {
      print('External Storage Directory: ${externalStorageDirectory.path}');
    }

    if (externalStorageDirectories != null) {
      print('External Storage Directories:');
      for (Directory directory in externalStorageDirectories) {
        print(directory.path);
        path = directory.path;
      }
    }

    final String url =
        new UtilsFromHelper().getValueFromKey("get_loanapplication_details");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    sharedpreferencemanager pref = sharedpreferencemanager();
    Map map = {
      "hrmsId": await pref.getEmployeeHrmsid(),
      "pfLoanApplicationNo": widget.applicationNo
    };
    print('map $map');
    print('url $url');
    HttpClientRequest request = await client.postUrl(
      Uri.parse(url),
    );
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    print('responseJSON $responseJSON');
    setState(() {
      if (responseJSON['basic_pay'] != null ||
          responseJSON['basic_pay'] != "") {
        basicPay = responseJSON['basic_pay'].toString();
      } else {
        basicPay = "0";
      }

      pfBalance = responseJSON['pf_balance'].toString();
      if (responseJSON['pf_balance'] != null) {
        pfBalance_200 = int.parse(responseJSON['pf_balance'].toString()) - 200;
      }
    });
    if (responseJSON['status'] == "DS") {
      sendw_type = responseJSON['withdrawal_type'].toString();

      withdrawal_type = responseJSON['withdrawal_type'].toString();
      _selectedreason = responseJSON['withdrawal_reason'].toString();
      _selected = true;
      sendw_reason = responseJSON['withdrawal_reason'].toString();
      appliedAmount.text = responseJSON['applied_amount'].toString();
      maximumEligibility.text =
          responseJSON['maximum_eligible_amount'].toString();
      noofInstallments.text = responseJSON['number_of_installments'].toString();
      installmentAmount.text = responseJSON['installment_amount'].toString();
      dependentName.text = responseJSON['remarks'].toString();

      if (responseJSON['freehold'] != null &&
          responseJSON['freehold'].toString() != "") {
        if (responseJSON['freehold'].toString() == "lease") {
          _selectedlease = "Lease";
        } else if (responseJSON['freehold'].toString() == "free hold") {
          _selectedlease = "Free hold";
        }
      }
      if (responseJSON['constructioncost'] != null) {
        costConstruction.text = responseJSON['constructioncost'].toString();
      }
      if (responseJSON['locationflat'] != null) {
        locationMeasurment.text = responseJSON['locationflat'].toString();
      }
      if (responseJSON['constructionplan'] != null) {
        constructionplan = responseJSON['constructionplan'].toString();
      }

      if (responseJSON['societyname'] != null) {
        society_name.text = responseJSON['societyname'].toString();
      }

      if (responseJSON['ddaflatlocation'] != null) {
        ddaFlat.text = responseJSON['societyname'].toString();
      }
      if (responseJSON['wardname'] != null) {
        namedos.text = responseJSON['wardname'].toString();
      }

      if (responseJSON['patientname'] != null) {
        name_relation.text = responseJSON['patientname'].toString();
      }

      if (responseJSON['collegename'] != null) {
        classInstitution.text = responseJSON['collegename'].toString();
      }
      if (responseJSON['hospitalname'] != null) {
        name_hospital.text = responseJSON['hospitalname'].toString();
      }

      if (responseJSON['daysholarfield'] != null) {
        if (responseJSON['daysholarfield'].toString() == "Day scholar") {
          _selectedday = "Day scholar";
        } else if (responseJSON['daysholarfield'].toString() == "Hostler") {
          _selectedday = "Hostler";
        }
      }

      if (responseJSON['typeofpatient'] != null) {
        if (responseJSON['typeofpatient'].toString() == "Indoor Patient")
          _selectedindore_outdoor = "Indoor Patient";
      } else if (responseJSON['typeofpatient'].toString() ==
          "Outdoor Patient") {
        _selectedindore_outdoor = "Outdoor Patient";
      }
      if (responseJSON['reimburavail'].toString() != 'null') {
        if (responseJSON['reimburavail'].toString() ==
            "Reimbursement Available") {
          _selectedreimbursement = "Reimbursement Available";
        } else if (responseJSON['reimburavail'].toString() ==
            "Reimbursement Not Available") {}
        _selectedreimbursement = "Reimbursement Not Available";
      }

      if (responseJSON['withdrawal_type'].toString() == "T") {
        _selectedtype = "Temporary";
        text_no_installmentFlag = true;
      } else {
        _selectedtype = "Final";
        text_no_installmentFlag = false;
      }
      get_withdrawal_Reasons_List(responseJSON['withdrawal_reason'].toString(),
          responseJSON['withdrawal_type'].toString());
    }
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    //mina
    dateb = responseJSON['date_of_birth'];
    print('dateb $dateb');
    DateTime todayDate_exp = DateTime.parse(dateb);
    dateb = DateFormat('dd-MM-yyyy').format(todayDate_exp);

    var appointmnet_date = responseJSON['date_of_appointment'];
    DateTime Date_appoinment = DateTime.parse(appointmnet_date);
    dateappointmnet = DateFormat('dd-MM-yyyy').format(Date_appoinment);
    var retirement_dt = responseJSON['date_of_retirement'];
    DateTime Date_retirment = DateTime.parse(retirement_dt);
    dateretirement = DateFormat('dd-MM-yyyy').format(Date_retirment);

    double r_month = responseJSON['remaining_month'];
    remaining_months = r_month.toInt();
    if (responseJSON['withdrawal_reason_ipas_code'] != null) {
      withdrawal_reason_ipas_code =
          responseJSON['withdrawal_reason_ipas_code'].toString();
    }
    if (responseJSON['ipas_pf_loan_application_number'] != null) {
      ipas_pf_loan_application_number =
          responseJSON['ipas_pf_loan_application_number'].toString();
    }

    father_name = responseJSON['father_name'].toString();
    current_main_railway_unit =
        responseJSON['current_main_railway_unit'].toString();
    bill_unit = responseJSON['bill_unit'].toString();
    current_railway_unit = responseJSON['current_railway_unit'].toString();
    current_station = responseJSON['current_station'].toString();
    designation = responseJSON['designation'].toString();
    department = responseJSON['department'].toString();
    var yearcom =
        double.parse(responseJSON['service_years_completed'].toString());
    service_years_completed = yearcom.toInt();
    var monthscom =
        double.parse(responseJSON['service_months_completed'].toString());
    service_months_completed = monthscom.toInt();

    date_of_retirement = responseJSON['date_of_retirement'].toString();
    date_of_appointment = responseJSON['date_of_appointment'].toString();
    // basicPay= basicPay.toString();
    pay_level = responseJSON['pay_level'].toString();
    pan_number = responseJSON['pan_number'].toString();
    pf_number = responseJSON['pf_number'].toString();
    account_unit = responseJSON['account_unit'].toString();
    bank_ifsc_code = responseJSON['bank_ifsc_code'].toString();
    bank_name = responseJSON['bank_name'].toString();
    bank_account_number = responseJSON['bank_account_number'].toString();
    payment_mode = responseJSON['payment_mode'].toString();
    pf_balance = responseJSON['pf_balance'].toString();
    total_outstanding_amount =
        responseJSON['total_outstanding_amount'].toString();
  }

  Future<void> getWithdrawalPer(String flag_Installment) async {
    var condition1 = int.parse(basicPay) * int.parse(basic_pay_multiplier);
    int Pf = int.parse(pfBalance);
    int withdrawal = int.parse(withdrawal_percentage);
    double can = Pf * withdrawal / 100;
    var condition2 = can.toInt();
    int maxAmount = 0;
    if (flag_Installment == "") {
      if (condition1 > 0) {
        maxAmount = min(condition1, condition2);
      }
      if (condition1 < 0 || condition1 == 0) {
        maxAmount = condition2;
      }
      if (int.parse(pfBalance) == maxAmount) {
        maxAmount = (maxAmount - 200) > 0 ? maxAmount - 200 : 0;
      }
      if (maxAmount < 0) {
        maxAmount = 0;
      }

      var mxamt = maxAmount.floor();

      if ( mxamt == "") {
        maximumEligibility.text = "0";
      } else {
        maximumEligibility.text = mxamt.toString();
      }
    }
    if (sendw_type == "T") {
      int installmentNo = 0;
      if (noofInstallments.text.trim().length == 0) {
        installmentNo = 0;
      } else {
        installmentNo = int.parse(noofInstallments.text);
      }
      var total;
      if (appliedAmount.text.trim().isNotEmpty && (installmentNo > 0)) {
        total = int.parse(appliedAmount.text) / installmentNo.toInt();
      } else {
        total = 0;
      }

      var installmentAmount_text;
      setState(() {
        if (total == null || total.toString() == "NaN") {
          installmentAmount_text = "0";
        } else {
          installmentAmount_text = total.round().toString();
        }

        text_amount_installmentFlag = true;
        installmentAmount.text = installmentAmount_text.toString();
        text_amount_installmentFlag = false;
      });
    }
  }

  Future get_withdrawal_Reasons_List(String reason, String wtype) async {
    final String url =
        new UtilsFromHelper().getValueFromKey("get_withdrawal_Reasons");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    Map map = {
      "w_type": wtype,
    };

    HttpClientRequest request = await client.postUrl(
      Uri.parse(url),
    );
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');
    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    setState(() {
      var reason_list = responseJSON["ReasonsList"] as List;
      for (int i = 0; i < reason_list.length; i++) {
        var code = reason_list[i]['reason_code'];
        var description = reason_list[i]['description'];
        var ipas_code = reason_list[i]['ipas_code'];
        var basic_pay_multiplier =
            reason_list[i]['basic_pay_multiplier'].toString();
        var withdrawal_percentage =
            reason_list[i]['withdrawal_percentage'].toString();

        data_listreason = responseJSON["ReasonsList"];

        setState(() {
          selected_listreason.add(ReasonList(
              reason_code: code,
              description: description,
              ipas_code: ipas_code,
              basic_pay_multiplier: basic_pay_multiplier,
              withdrawal_percentage: withdrawal_percentage));
        });

        // data_listreason.add(ReasonList(
        //     reason_code:code,
        //     description:description,ipas_code:ipas_code,basic_pay_multiplier:basic_pay_multiplier,withdrawal_percentage:withdrawal_percentage));
      }
    });
  }

  //get_withdrawal_Reasons
  Future uploadFile(String type, String code) async {
    //pr.show();
    String file_path;
    String doc_type;
    sharedpreferencemanager pref = sharedpreferencemanager();
    _changed(true, "start", type);
    if (type == "uploaddocument") {
      file_path = doc_file_path!;
      doc_type = "file1";
    } else {
      doc_type = "file2";

      file_path = plan_file_path!;
    }
    final bytes = Io.File(file_path).readAsBytesSync();

    String img64 = base64Encode(bytes);
    String basicAuth;
    String url = new UtilsFromHelper().getValueFromKey("upload_file");
    basicAuth = await Hrmstokenplugin.hrmsToken;
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    Map map = {
      'hrmsEmployeeId': await pref.getEmployeeHrmsid(),
      "module": "pfloan",
      "subModule": "PFLOAN",
      "documentType": doc_type,
      "documentKey": "Supportion",
      "file": img64,
    };

    HttpClientRequest request = await client.postUrl(Uri.parse(url));

    request.headers.set('content-type', 'application/json');
    request.headers.set('authorization', basicAuth);

    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    if (responseJSON["status"]) {
      setState(() {
        if (type == "uploaddocument") {
          doc_fileUploaded = responseJSON["file_path"];
        } else {
          plan_fileUploaded = responseJSON["file_path"];
        }

        Fluttertoast.showToast(
            msg: "File uploaded successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            //timeInSecForIos: 15,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 14.0);
        downloadPdf(type, code);
      });
    }
    setState(() {
      _changed(false, "finish", type);

      // dialog_flag=false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.lightBlueAccent,
        title: Text(" PF Loan Application",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      ),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        Container(
          margin: EdgeInsets.all(10),
          child: Visibility(
            visible: true,
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Column(children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              height: 14,
                              margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                              child: Text(
                                'Withdrawal Type*',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 0.80),
                            ),
                            child: DropdownButton(
                              isExpanded: true,

                              dropdownColor: Color(0xFFF2F2F2),
                              hint: Text(
                                'Please Select',
                                style: TextStyle(fontSize: 14),
                              ), // Not necessary for Option 1
                              value: _selectedtype,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedreason;
                                  _selectedtype = newValue!;
                                  sendw_type = "";
                                  if (newValue == "Final") {
                                    text_no_installmentFlag = false;
                                    text_amount_installmentFlag = false;
                                    noofInstallments.text = "0";
                                    installmentAmount.text = "0";
                                    sendw_type = "F";
                                  } else {
                                    sendw_type = "T";
                                    noofInstallments.text = "";
                                    text_no_installmentFlag = true;
                                    text_amount_installmentFlag = false;
                                  }
                                  if (newValue != null && newValue != "") {
                                    // if(draftReason=="")
                                    //   {
                                    //     get_withdrawal_Reasons_List(draftReason,sendw_type);
                                    //
                                    //   }else{
                                    //   _selectedreason=draftReason;
                                    //
                                    // }
                                    get_withdrawal_Reasons_List("", sendw_type);
                                  }
                                });
                              },
                              items: w_type.map((value) {
                                return DropdownMenuItem(
                                  child: new Text(value,
                                      style: TextStyle(fontSize: 13)),
                                  value: value,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              height: 14,
                              margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                              child: Text(
                                'Withdrawal Reason*',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),

                        Expanded(
                            child: Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 0.80),
                          ),
                          child: Center(
                            child: DropdownButton(
                              isExpanded: true,

                              dropdownColor: Color(0xFFF2F2F2),
                              hint: Text('Please Select',
                                  style: TextStyle(
                                      fontSize:
                                          14)), // Not necessary for Option 1
                              //value: _selectedreason,
                              onChanged: (newValue) {
                                setState(() {
                                  getselecteddata(newValue!);
                                  _selected = true;
                                  _selectedreason = newValue;
                                  sendw_reason = newValue;
                                  conditonFlag = true;
                                  getWithdrawalPer("");
                                });
                              },
                              value: _selected ? _selectedreason : null,
                              items: data_listreason.map((rlt) {
                                return DropdownMenuItem(
                                  value: rlt["reason_code"].toString(),
                                  child: Text(rlt["reason_code"].toString(),
                                      style: TextStyle(fontSize: 13)),
                                );
                              }).toList(),
                            ),
                          ),
                        )),
                        // Expanded(child: Container(child: DropdownButtonFormField(
                        //     decoration: InputDecoration(
                        //       prefixIcon: Icon(Icons.settings),
                        //       hintText: 'Organisation Type',
                        //       filled: true,
                        //       fillColor: Colors.white,
                        //       errorStyle: TextStyle(color: Colors.yellow),
                        //     ),
                        //     items: data_listreason.map((map) {
                        //       return DropdownMenuItem(
                        //         child: Text(map.reason_code),
                        //         value: map,
                        //       );
                        //     }).toList()),)),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              height: 14,
                              margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                              child: Text(
                                'Maximum Eligibility*',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                        Expanded(
                          child: TextField(
                            enabled: false,
                            controller: maximumEligibility,
                            style: new TextStyle(
                                color: Colors.black, fontSize: 13.0),
                            keyboardType: TextInputType.number,
                            textCapitalization: TextCapitalization.characters,
                            decoration: new InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF2F2F2),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              height: 14,
                              margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                              child: Text(
                                'Applied Amount *',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                        Expanded(
                          child: TextField(
                            onChanged: (String value) async {
                              if (appliedAmount.text.trim().length > 0) {
                                getWithdrawalPer("flag_Installment");
                              }
                            },
                            controller: appliedAmount,
                            style: new TextStyle(
                                color: Colors.black, fontSize: 13.0),
                            keyboardType: TextInputType.number,
                            textCapitalization: TextCapitalization.characters,
                            decoration: new InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF2F2F2),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: conditonFlag,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'The maximum eligibilty is minimum of these 2 conditions *',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Condition 1- Basic Pay (${basicPay})* Basic Pay multiplier(${basic_pay_multiplier}) *',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Condition 2- PF Balance (${pfBalance})* Withdrawal percentage(${withdrawal_percentage}) *',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              height: 14,
                              margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                              child: Text(
                                'Number of Installments*',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                        Expanded(
                          child: TextField(
                            onChanged: (String value) async {
                              if (noofInstallments.text.length > 0) {
                                getWithdrawalPer("flag_Installment");
                              }
                            },
                            enabled: text_no_installmentFlag,
                            controller: noofInstallments,
                            style: new TextStyle(
                                color: Colors.black, fontSize: 13.0),
                            keyboardType: TextInputType.number,
                            //textCapitalization: TextCapitalization.characters,
                            decoration: new InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF2F2F2),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              height: 14,
                              margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                              child: Text(
                                'Installment Amount*',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                        Expanded(
                          child: TextField(
                            enabled: text_amount_installmentFlag,
                            controller: installmentAmount,
                            style: new TextStyle(
                                color: Colors.black, fontSize: 13.0),
                            keyboardType: TextInputType.number,
                            //textCapitalization: TextCapitalization.characters,
                            decoration: new InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF2F2F2),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              height: 34,
                              margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                              child: Text(
                                'Dependent \n Name/Remarks*',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                        Expanded(
                          child: TextField(
                            controller: dependentName,
                            style: new TextStyle(
                                color: Colors.black, fontSize: 13.0),
                            //textCapitalization: TextCapitalization.characters,
                            decoration: new InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF2F2F2),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                              child: Text(
                                'Upload Document',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.lightBlueAccent)),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                  padding: EdgeInsets.fromLTRB(5, 7, 5, 7),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.lightBlueAccent)),
                                  //             <--- BoxDecoration here
                                  child: GestureDetector(
                                      onTap: () async {
                                        Fluttertoast.showToast(
                                            msg: 'Please Wait...',
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            // timeInSecForIos: 5,
                                            backgroundColor: Colors.pink,
                                            textColor: Colors.white,
                                            fontSize: 14.0);
                                        EasyLoading.show(status: "Please Waiting...");
                                        /*result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FileList(files)),
                                        );*/
                                        result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FileList()),
                                        );
                                        if (this.mounted) {
                                          // check whether the state object is in tree
                                          setState(() {
                                            doc_file_path = result;
                                            EasyLoading.dismiss();
                                          });
                                        }
                                      },
                                      child: Text(
                                        "Choose File",
                                        style: TextStyle(fontSize: 10.0),
                                      )),
                                ),
                                Expanded(
                                  child: Text(
                                    doc_file_path ?? "No file chosen",
                                    style: TextStyle(fontSize: 10.0),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: 40,
                                    color: Colors.lightBlueAccent,
                                    child: TextButton(
                                      onPressed: () {
                                        Timer timer;

                                        timer = Timer.periodic(
                                            Duration(milliseconds: 500), (_) {
                                          if (mounted) {
                                            if (this.mounted) {
                                              // check whether the state object is in tree
                                              setState(() {
                                                percent += 2;
                                                if (percent >= 100) {
                                                  percent = 0.0;
                                                  //timer .cancel();
                                                  //percent=0;
                                                }
                                              });
                                            }
                                          }
                                        });
                                        if (doc_file_path == "" ||
                                            doc_file_path == null) {
                                        } else {
                                          uploadFile('uploaddocument', "_059");
                                        }
                                      },
                                      child: Icon(
                                        Icons.file_upload,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Visibility(
                      visible: doc_fileUploadFlag,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              onPressed: () async {
                                sharedpreferencemanager pref =
                                    sharedpreferencemanager();

                                var hrmsid = await pref.getEmployeeHrmsid();
                                bool fileexist =
                                    File('$path/HRMS/PFLOAN${hrmsid}.pdf')
                                        .existsSync();
                                if (fileexist) {
                                  await OpenFilex.open(
                                      '$path/HRMS/PFLOAN${hrmsid}.pdf');
                                } else {
                                  downloadPdf("uploaddocument", "_059");
                                }
                              },
                              child: Column(
                                // Replace with a Row for horizontal icon + text
                                children: <Widget>[
                                  Icon(Icons.picture_as_pdf_sharp,
                                      color: Colors.white),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  doc_file_path;
                                  doc_fileUploaded = "";
                                  doc_fileUploadFlag = false;
                                });
                              },
                              child: Column(
                                // Replace with a Row for horizontal icon + text
                                children: <Widget>[
                                  Icon(Icons.close, color: Colors.redAccent),
                                ],
                              ),
                            ),
                            // Icon(Icons.close,color: Colors.red,),
                          ]),
                    ),
                    Visibility(
                      visible: doc_progress_flag,
                      maintainState: true,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        height: 10,
                        width: 140,
                        child: LinearProgressIndicator(
                          value: percent / 100, // Defaults to 0.5.
                          valueColor: AlwaysStoppedAnimation(Colors
                              .lightBlueAccent), // Defaults to the current Theme's accentColor.
                          backgroundColor: Colors
                              .white, // Defaults to the current Theme's backgroundColor.
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ]),
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                  padding: EdgeInsets.fromLTRB(1, 0, 5, 0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromARGB(211, 211, 211, 211), width: 1),
                    borderRadius: BorderRadius.circular(5),
                    shape: BoxShape.rectangle,
                  ),
                ),
                Positioned(
                    left: 10,
                    top: 12,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      color: Colors.white,
                      child: Text(
                        'PF1 Loan Application Details',
                        style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
        ),
        //part 2

        Container(
          margin: EdgeInsets.all(10),
          child: Visibility(
            visible: true,
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Column(children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                              child: Text(
                                'Whether the flat or plot\n is free hold or on lease',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 0.80),
                            ),
                            child: DropdownButton(
                              isExpanded: true,
                              dropdownColor: Color(0xFFF2F2F2),
                              hint: Text(
                                'Please Select ',
                                style: TextStyle(fontSize: 14),
                              ), // Not necessary for Option 1
                              value: _selectedlease,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedlease = newValue!;
                                  if (_selectedlease == "Lease") {
                                    senditem = "lease";
                                  } else {
                                    senditem = "free hold";
                                  }
                                });
                              },
                              items: _leaselist.map((value) {
                                return DropdownMenuItem(
                                  child: new Text(value,
                                      style: TextStyle(fontSize: 13)),
                                  value: value,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                              child: Text(
                                'If the flat or plot is being purchased from H.B. Society, the name of the society, the location and measurement, etc',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                        Expanded(
                          child: TextField(
                            controller: society_name,
                            style: new TextStyle(
                                color: Colors.black, fontSize: 13.0),
                            textCapitalization: TextCapitalization.characters,
                            decoration: new InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF2F2F2),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              height: 14,
                              margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                              child: Text(
                                'Cost of Construction',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                        Expanded(
                          child: TextField(
                            controller: costConstruction,
                            style: new TextStyle(
                                color: Colors.black, fontSize: 13.0),
                            keyboardType: TextInputType.number,
                            //textCapitalization: TextCapitalization.characters,
                            decoration: new InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF2F2F2),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                              child: Text(
                                'Location and measurement of the Flat or Plot',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                        Expanded(
                          child: TextField(
                            controller: locationMeasurment,
                            style: new TextStyle(
                                color: Colors.black, fontSize: 13.0),
                            //textCapitalization: TextCapitalization.characters,
                            decoration: new InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF2F2F2),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                              child: Text(
                                'If the purchase of flat is from D.D.A. or any Housing Board, etc. the location, dimension,etc. may be given',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                        Expanded(
                          child: TextField(
                            controller: ddaFlat,
                            style: new TextStyle(
                                color: Colors.black, fontSize: 13.0),
                            //textCapitalization: TextCapitalization.characters,
                            decoration: new InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF2F2F2),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                              child: Text(
                                'Plan for Construction',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.lightBlueAccent)),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                  padding: EdgeInsets.fromLTRB(5, 7, 5, 7),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.lightBlueAccent)),
                                  //             <--- BoxDecoration here
                                  child: GestureDetector(
                                      onTap: () async {
                                        Fluttertoast.showToast(
                                            msg: 'Please Wait...',
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            // timeInSecForIos: 5,
                                            backgroundColor: Colors.pink,
                                            textColor: Colors.white,
                                            fontSize: 14.0);
                                        EasyLoading.show(status: "Please Waiting...");
                                        /*result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FileList(files)),
                                        );*/
                                        result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FileList()),
                                        );
                                        if (this.mounted) {
                                          // check whether the state object is in tree
                                          setState(() {
                                            plan_file_path = result;
                                            EasyLoading.dismiss();
                                          });
                                        }
                                      },
                                      child: Text(
                                        "Choose File",
                                        style: TextStyle(fontSize: 10.0),
                                      )),
                                ),
                                Expanded(
                                  child: Text(
                                    plan_file_path ?? "No file chosen",
                                    style: TextStyle(fontSize: 10.0),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: 40,
                                    color: Colors.lightBlueAccent,
                                    child: TextButton(
                                      onPressed: () {
                                        Timer timer;

                                        timer = Timer.periodic(
                                            Duration(milliseconds: 500), (_) {
                                          if (mounted) {
                                            if (this.mounted) {
                                              // check whether the state object is in tree
                                              setState(() {
                                                percent += 2;
                                                if (percent >= 100) {
                                                  percent = 0.0;
                                                  //timer .cancel();
                                                  //percent=0;
                                                }
                                              });
                                            }
                                          }
                                        });
                                        if (plan_file_path == "" ||
                                            plan_file_path == null) {
                                        } else {
                                          uploadFile(
                                              "planconstruction", "_076");
                                        }
                                      },
                                      child: Icon(
                                        Icons.file_upload,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                    Visibility(
                      visible: plan_fileUploadFlag,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              onPressed: () async {
                                sharedpreferencemanager pref =
                                    sharedpreferencemanager();

                                var hrmsid = await pref.getEmployeeHrmsid();
                                bool fileexist =
                                    File('$path/HRMS/PFLOAN${hrmsid}.pdf')
                                        .existsSync();
                                if (fileexist) {
                                  await OpenFilex.open(
                                      '$path/HRMS/PFLOAN${hrmsid}.pdf');
                                } else {
                                  downloadPdf("plan", "_076");
                                }
                              },
                              child: Column(
                                // Replace with a Row for horizontal icon + text
                                children: <Widget>[
                                  Icon(Icons.picture_as_pdf_sharp,
                                      color: Colors.white),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  plan_file_path;
                                  plan_fileUploaded = "";
                                  plan_fileUploadFlag = false;
                                });
                              },
                              child: Column(
                                // Replace with a Row for horizontal icon + text
                                children: <Widget>[
                                  Icon(Icons.close, color: Colors.redAccent),
                                ],
                              ),
                            ),
                            // Icon(Icons.close,color: Colors.red,),
                          ]),
                    ),
                    Visibility(
                      visible: plan_progress_flag,
                      maintainState: true,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        height: 10,
                        width: 140,
                        child: LinearProgressIndicator(
                          value: percent / 100, // Defaults to 0.5.
                          valueColor: AlwaysStoppedAnimation(Colors
                              .lightBlueAccent), // Defaults to the current Theme's accentColor.
                          backgroundColor: Colors
                              .white, // Defaults to the current Theme's backgroundColor.
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                    ),
                  ]),
                  margin: EdgeInsets.fromLTRB(0, 40, 0, 10),
                  padding: EdgeInsets.fromLTRB(1, 0, 5, 0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromARGB(211, 211, 211, 211), width: 1),
                    borderRadius: BorderRadius.circular(5),
                    shape: BoxShape.rectangle,
                  ),
                ),
                Positioned(
                    left: 10,
                    top: 12,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      color: Colors.white,
                      child: Text(
                        'If advance is sought for House Building etc.,\n following information may be given',
                        style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
        ),
        //part3
        Container(
          margin: EdgeInsets.all(10),
          child: Visibility(
            visible: true,
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Column(children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              height: 14,
                              margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                              child: Text(
                                'Whether a day \nscholar or a Hostler*',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 0.80),
                            ),
                            child: DropdownButton(
                              isExpanded: true,

                              dropdownColor: Color(0xFFF2F2F2),
                              hint: Text(
                                'Please Select ',
                                style: TextStyle(fontSize: 14),
                              ), // Not necessary for Option 1
                              value: _selectedday,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedday = newValue!;
                                });
                              },
                              items: day_list.map((value) {
                                return DropdownMenuItem(
                                  child: new Text(value,
                                      style: TextStyle(fontSize: 13)),
                                  value: value,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: <Widget>[
                    //     Expanded(
                    //
                    //       child: Container(
                    //           height:14,
                    //           margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                    //           child:Text('Withdrawal Reason*', textAlign: TextAlign.left,style: TextStyle(fontSize:13,fontWeight:
                    //           FontWeight.bold,color: Colors.black),)
                    //       ),
                    //     ),
                    //     Expanded(child:
                    //     Container(
                    //       padding: EdgeInsets.symmetric(horizontal: 10.0),
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(5.0),
                    //         border: Border.all(
                    //             color: Colors.grey, style: BorderStyle.solid, width: 0.80),
                    //       ),
                    //       child:
                    //       DropdownButton(
                    //
                    //         isExpanded: true,
                    //
                    //         dropdownColor: Color(0xFFF2F2F2),
                    //         hint: Text('Please Select ',style:TextStyle(fontSize: 14)), // Not necessary for Option 1
                    //         value: _selectedgender,
                    //         onChanged: (newValue) {
                    //           setState(() {
                    //             _selectedgender = newValue;
                    //           });
                    //         },
                    //         items: g_list.map((value) {
                    //           return DropdownMenuItem(
                    //             child: new Text(value,style:TextStyle(fontSize: 13)),
                    //             value: value,
                    //           );
                    //         }).toList(),
                    //       ),
                    //
                    //     )
                    //
                    //     ),
                    //
                    //   ],
                    // ),
                    // SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              height: 14,
                              margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                              child: Text(
                                'Name of the Son/Daughter ',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                        Expanded(
                          child: TextField(
                            controller: namedos,
                            style: new TextStyle(
                                color: Colors.black, fontSize: 13.0),
                            textCapitalization: TextCapitalization.characters,
                            decoration: new InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF2F2F2),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                              child: Text(
                                'Class & Institution/ \nCollege where studying*',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                        Expanded(
                          child: TextField(
                            controller: classInstitution,
                            style: new TextStyle(
                                color: Colors.black, fontSize: 13.0),
                            //textCapitalization: TextCapitalization.characters,
                            decoration: new InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF2F2F2),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    SizedBox(
                      height: 15,
                    ),
                  ]),
                  margin: EdgeInsets.fromLTRB(0, 40, 0, 10),
                  padding: EdgeInsets.fromLTRB(1, 0, 5, 0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromARGB(211, 211, 211, 211), width: 1),
                    borderRadius: BorderRadius.circular(5),
                    shape: BoxShape.rectangle,
                  ),
                ),
                Positioned(
                    left: 10,
                    top: 12,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10, left: 5, right: 10),
                      color: Colors.white,
                      child: Text(
                        'If advance is required for education of children,\n following information may be given',
                        style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
        ),

        //part4
        Container(
          margin: EdgeInsets.all(10),
          child: Visibility(
            visible: true,
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Column(children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                              child: Text(
                                'Name of the patient & relationship ',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                        Expanded(
                          child: TextField(
                            controller: name_relation,
                            style: new TextStyle(
                                color: Colors.black, fontSize: 13.0),
                            textCapitalization: TextCapitalization.characters,
                            decoration: new InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF2F2F2),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              height: 14,
                              margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                              child: Text(
                                'Name of the Hospital/ \nDispensary/Doctor where the\n patient is undergoing treatment',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                        Expanded(
                          child: TextField(
                            controller: name_hospital,
                            style: new TextStyle(
                                color: Colors.black, fontSize: 13.0),
                            //textCapitalization: TextCapitalization.characters,
                            decoration: new InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF2F2F2),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              height: 14,
                              margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                              child: Text(
                                'Whether Outdoor/Indoor patient*',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 0.80),
                            ),
                            child: DropdownButton(
                              isExpanded: true,

                              dropdownColor: Color(0xFFF2F2F2),
                              hint: Text(
                                'Please Select ',
                                style: TextStyle(fontSize: 14),
                              ), // Not necessary for Option 1
                              value: _selectedindore_outdoor,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedindore_outdoor = newValue!;
                                });
                              },
                              items: indoor_outdoor.map((value) {
                                return DropdownMenuItem(
                                  child: new Text(value,
                                      style: TextStyle(fontSize: 13)),
                                  value: value,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              height: 14,
                              margin: EdgeInsets.fromLTRB(5, 3, 0, 0),
                              child: Text(
                                'Whether reimbursement available or not',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 0.80),
                          ),
                          // child:
                          // DropdownButton(
                          //
                          //   isExpanded: true,
                          //
                          //   dropdownColor: Color(0xFFF2F2F2),
                          //   hint: Text('Please Select ',style:TextStyle(fontSize: 14)), // Not necessary for Option 1
                          //   value: _selectedreimbursement,
                          //   onChanged: (newValue) {
                          //     setState(() {
                          //       _selectedreimbursement = newValue;
                          //     });
                          //   },
                          //   items: reimbursementlist.map((value) {
                          //     return DropdownMenuItem(
                          //       child: new Text(value,style:TextStyle(fontSize: 13)),
                          //       value: value,
                          //     );
                          //   }).toList(),
                          // ),

                          child: DropdownButton(
                            isExpanded: true,

                            dropdownColor: Color(0xFFF2F2F2),
                            hint: Text(
                              'Please Select ',
                              style: TextStyle(fontSize: 14),
                            ), // Not necessary for Option 1
                            value: _selectedreimbursement,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedreimbursement = newValue!;
                              });
                            },
                            items: reimbursementlist.map((value) {
                              return DropdownMenuItem(
                                child: new Text(value,
                                    style: TextStyle(fontSize: 13)),
                                value: value,
                              );
                            }).toList(),
                          ),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FilledButton(
                            //width: 130,
                            child: Text(
                              'Save as Draft',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            style: FilledButton.styleFrom(
                                backgroundColor: Color(0xFF40C4FF)),
                            onPressed: () {
                              if (sendw_type == "") {
                                Fluttertoast.showToast(
                                    msg: "Please select withdrawal type",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    //timeInSecForIos: 5,
                                    backgroundColor: Colors.pink,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else if (sendw_reason == "") {
                                Fluttertoast.showToast(
                                    msg: "Please select withdrawal reason",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
//timeInSecForIos: 5,
                                    backgroundColor: Colors.pink,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else if (appliedAmount.text.trim().length ==
                                  0) {
                                Fluttertoast.showToast(
                                    msg: "Please enter applied amount",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    // timeInSecForIos: 5,
                                    backgroundColor: Colors.pink,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else if (int.parse(appliedAmount.text.trim()) >
                                  int.parse(maximumEligibility.text.trim())) {
                                Fluttertoast.showToast(
                                    msg:
                                        "Applied Amount must be smaller than maximum eligibilty amount",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    // timeInSecForIos: 5,
                                    backgroundColor: Colors.pink,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else if (int.parse(appliedAmount.text.trim()) /
                                      int.parse(basicPay) >
                                  (.50) * int.parse(basicPay)) {
                                Fluttertoast.showToast(
                                    msg:
                                        "The installment amount should be less than 50% of Basic Pay. Hence adjust installment no accordingly",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    // timeInSecForIos: 5,
                                    backgroundColor: Colors.pink,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else if (int.parse(appliedAmount.text) >
                                  pfBalance_200) {
                                Fluttertoast.showToast(
                                    msg:
                                        "Applied amount must be smaller than PF Balance-200",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    // timeInSecForIos: 5,
                                    backgroundColor: Colors.pink,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else if (noofInstallments.text.trim() == "") {
                                Fluttertoast.showToast(
                                    msg: "Enter installment no.",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    // timeInSecForIos: 5,
                                    backgroundColor: Colors.pink,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else if (int.parse(
                                      noofInstallments.text.trim()) >
                                  remaining_months) {
                                Fluttertoast.showToast(
                                    msg:
                                        "The installment no needs to be less than the no of months remaining in retirement",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    // timeInSecForIos: 5,
                                    backgroundColor: Colors.pink,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else if (installmentAmount.text.length == 0) {
                                Fluttertoast.showToast(
                                    msg: "Please enter installment amount",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    //  timeInSecForIos: 5,
                                    backgroundColor: Colors.pink,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else if (dependentName.text.length == 0) {
                                Fluttertoast.showToast(
                                    msg: "Please enter dependent Name/Remarks",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    //  timeInSecForIos: 5,
                                    backgroundColor: Colors.pink,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else {
                                save_as_draft();
                              }
                            }),
                        FilledButton(
                            //width: 120,
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            style: FilledButton.styleFrom(
                                backgroundColor: Colors.lightBlueAccent),
                            onPressed: () {
                              if (sendw_type == "") {
                                Fluttertoast.showToast(
                                    msg: "Please eelect withdrawal type",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    //timeInSecForIos: 5,
                                    backgroundColor: Colors.pink,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else if (_selectedreason == null ||
                                  _selectedreason == "") {
                                Fluttertoast.showToast(
                                    msg: "Please select withdrawal reason",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    // timeInSecForIos: 5,
                                    backgroundColor: Colors.pink,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else if (appliedAmount.text.trim().length ==
                                  0) {
                                Fluttertoast.showToast(
                                    msg: "Please enter applied amount",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    // timeInSecForIos: 5,
                                    backgroundColor: Colors.pink,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else if (int.parse(appliedAmount.text.trim()) >
                                  int.parse(maximumEligibility.text.trim())) {
                                Fluttertoast.showToast(
                                    msg:
                                        "Applied amount must be smaller than maximum eligibilty amount",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    // timeInSecForIos: 5,
                                    backgroundColor: Colors.pink,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else if (int.parse(appliedAmount.text.trim()) /
                                      int.parse(basicPay) >
                                  (.50) * int.parse(basicPay)) {
                                Fluttertoast.showToast(
                                    msg:
                                        "The Installment amount should be less than 50% of Basic Pay. Hence adjust installment no accordingly",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    // timeInSecForIos: 5,
                                    backgroundColor: Colors.pink,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else if (int.parse(appliedAmount.text) >
                                  pfBalance_200) {
                                Fluttertoast.showToast(
                                    msg:
                                        "Applied amount must be smaller than PF Balance-200",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    //  timeInSecForIos: 5,
                                    backgroundColor: Colors.pink,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else if (noofInstallments.text.length == 0) {
                                Fluttertoast.showToast(
                                    msg: "Please enter no of installments",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    // timeInSecForIos: 5,
                                    backgroundColor: Colors.pink,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else if (int.parse(
                                      noofInstallments.text.trim()) >
                                  remaining_months) {
                                Fluttertoast.showToast(
                                    msg:
                                        "The installment no needs to be less than the no of months remaining in retirement",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    //  timeInSecForIos: 5,
                                    backgroundColor: Colors.pink,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else if (installmentAmount.text.length == 0) {
                                Fluttertoast.showToast(
                                    msg: "Please enter installment amount",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    // timeInSecForIos: 5,
                                    backgroundColor: Colors.pink,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else if (dependentName.text.length == 0) {
                                Fluttertoast.showToast(
                                    msg: "Please enter dependent Name/Remarks",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    //  timeInSecForIos: 5,
                                    backgroundColor: Colors.pink,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else {
                                getotp();
                              }
                            }),
                      ],
                    ),
                  ]),
                  margin: EdgeInsets.fromLTRB(0, 40, 0, 10),
                  padding: EdgeInsets.fromLTRB(1, 0, 5, 30),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromARGB(211, 211, 211, 211), width: 1),
                    borderRadius: BorderRadius.circular(5),
                    shape: BoxShape.rectangle,
                  ),
                ),
                Positioned(
                    left: 10,
                    top: 12,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10, left: 5, right: 10),
                      color: Colors.white,
                      child: Text(
                        'If advance is required for treatment of ailing family,\n Member following information may be given',
                        style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ])),
    );
  }
}

class CustomDialog extends StatefulWidget {
  final String Application_no;
  final String Dob;
  final String DateAppintmnet;
  final String DateRetirement;
  final String Withdrawal_reason_ipas_code;
  final String Ipas_pf_loan_application_number;
  final String Father_name;
  final String Current_main_railway_unit;
  final String Bill_unit;
  final String Current_railway_unit;
  final String Current_station;
  final String Withdrawal_type;
  final String Withdrawal_reason;
  final String Applied_amount;
  final String Maximum_eligible_amount;
  final String Number_of_installments;
  final String Installment_amount;
  final String Remark;
  final String Free_hold;
  final String Construction_cost;
  final String Construction_plan;
  final String Location_flat;
  final String Societyname;
  final String Ddaflatlocation;
  final String Daysholarfield;
  final String Wardname;
  final String Collegename;
  final String Patientname;
  final String Typeofpatient;
  final String Reimburavail;
  final String Pay_level;
  final String Department;
  final String Designation;
  final String Hospitalname;
  final int Service_years_completed;
  final int Service_months_completed;
  final String Date_of_retirement;
  final String Date_of_appointment;
  final String Pan_number;
  final String Pf_number;
  final String Account_unit;
  final String BankIfscCode;
  final String BankName;
  final String BankAccountNumber;
  final String BasicPay;
  final String PaymentMode;
  final String PfBalance;
  final String TotalOutstandingAmount;
  final String validdate;
  final String mobileno;
  final String varifiedOtp;
  final String filename;
  final String fileconstructionPlan;

  CustomDialog(
      {required this.Application_no,
      required this.Dob,
      required this.DateAppintmnet,
      required this.DateRetirement,
      required this.Withdrawal_reason_ipas_code,
      required this.Ipas_pf_loan_application_number,
      required this.Father_name,
      required this.Current_main_railway_unit,
      required this.Bill_unit,
      required this.Current_railway_unit,
      required this.Current_station,
      required this.Withdrawal_type,
      required this.Withdrawal_reason,
      required this.Applied_amount,
      required this.Maximum_eligible_amount,
      required this.Number_of_installments,
      required this.Installment_amount,
      required this.Remark,
      required this.Free_hold,
      required this.Construction_cost,
      required this.Construction_plan,
      required this.Location_flat,
      required this.Societyname,
      required this.Ddaflatlocation,
      required this.Daysholarfield,
      required this.Wardname,
      required this.Collegename,
      required this.Patientname,
      required this.Typeofpatient,
      required this.Reimburavail,
      required this.Pay_level,
      required this.Department,
      required this.Designation,
      required this.Hospitalname,
      required this.Service_years_completed,
      required this.Service_months_completed,
      required this.Date_of_retirement,
      required this.Date_of_appointment,
      required this.Pan_number,
      required this.Pf_number,
      required this.Account_unit,
      required this.BankIfscCode,
      required this.BankName,
      required this.BankAccountNumber,
      required this.BasicPay,
      required this.PaymentMode,
      required this.PfBalance,
      required this.TotalOutstandingAmount,
      required this.validdate,
      required this.mobileno,
      required this.varifiedOtp,
      required this.filename,
      required this.fileconstructionPlan});
  @override
  CustomDialogState createState() => CustomDialogState();
}

class CustomDialogState extends State<CustomDialog> {
  late String result;

  var phoneno = "", hrms_Id = "";
  TextEditingController otpedittext = new TextEditingController();
  sharedpreferencemanager pref = sharedpreferencemanager();
  Future save_application_details() async {
    final String url =
        new UtilsFromHelper().getValueFromKey("submit_pf_loan_application");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    String basicAuth = await Hrmstokenplugin.hrmsToken;
    sharedpreferencemanager pref = sharedpreferencemanager();

    Map map = {
      "applicationNo": widget.Application_no,
      "mobileNo": await pref.getEmployeeMobileno(),
      "status": "FS",
      "service_years_completed": widget.Service_years_completed,
      "service_months_completed": widget.Service_months_completed,
      "ipas_no": await pref.getEmployeeIpasid(),
      "hrms_id": await pref.getEmployeeHrmsid(),
      "name": await pref.getEmployeeName(),
      "date_of_birth": widget.Dob,
      "father_name": widget.Father_name,
      "date_of_retirement": widget.Date_of_retirement,
      "date_of_appointment": widget.Date_of_appointment,
      "current_main_railway_unit": widget.Current_main_railway_unit,
      "current_railway_unit": widget.Current_railway_unit,
      "current_station": widget.Current_station,
      "bill_unit": widget.Bill_unit,
      "department": widget.Department,
      "designation": widget.Designation,
      "basic_pay": int.parse(widget.BasicPay),
      "pay_level": widget.Pay_level,
      "pan_number": widget.Pan_number,
      "pf_number": widget.Pf_number,
      "account_unit": widget.Account_unit,
      "bank_ifsc_code": widget.BankIfscCode,
      "bank_name": widget.BankName,
      "bank_account_number": widget.BankAccountNumber,
      "payment_mode": widget.PaymentMode,
      "pf_balance": int.parse(widget.PfBalance),
      "withdrawal_type": widget.Withdrawal_type,
      "withdrawal_reason": widget.Withdrawal_reason,
      "submitting_user_id": await pref.getEmployeeHrmsid(),
      "remarks": widget.Remark,
      "transaction_date_time": "",
      "ipas_pf_loan_application_number": widget.Ipas_pf_loan_application_number,
      "withdrawal_reason_ipas_code": widget.Withdrawal_reason_ipas_code,
      "document_id": widget.filename,
      "otpSubmit": otpedittext.text,
      "patientName": widget.Patientname,
      "hospitalName": widget.Hospitalname,
      "typeOfPatient": widget.Typeofpatient,
      "reimburAvail": widget.Reimburavail,
      "ddaFlatLocation": widget.Ddaflatlocation,
      "wardName": widget.Wardname,
      "collegeName": widget.Collegename,
      "daySholarField": widget.Daysholarfield,
      "locationFlat": widget.Location_flat,
      "freehold": widget.Free_hold,
      "societyName": widget.Societyname,
      "constructionPlan": widget.fileconstructionPlan,
      "constructionCost": widget.Construction_cost,
      "total_outstanding_amount": int.parse(widget.TotalOutstandingAmount),
      "number_of_installments": int.parse(widget.Number_of_installments),
      "applied_amount": int.parse(widget.Applied_amount),
      "maximum_eligible_amount": int.parse(widget.Maximum_eligible_amount),
      "installment_amount": int.parse(widget.Installment_amount)
    };

    HttpClientRequest request = await client.postUrl(
      Uri.parse(url),
    );
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.headers.set('authorization', basicAuth);
    request.add(utf8.encode(json.encode(map)));

    HttpClientResponse response = await request.close();

    String value = await response.transform(utf8.decoder).join();
    var responseJSON = json.decode(value) as Map;
    if (responseJSON['result']) {
      Fluttertoast.showToast(
          msg: 'Your PF application save successfully ' +
              responseJSON['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 15,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0);

      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyPfloanList()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext contextb) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: 15.0,
              bottom: Consts.padding,
              left: Consts.padding,
              right: Consts.padding,
            ),
            margin: EdgeInsets.only(top: Consts.avatarRadius),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(Consts.padding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "OTP VERIFICATION",
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 2,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Your last Transaction OTP was sent on:",
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.5, horizontal: 30.0),
                  padding: EdgeInsets.only(left: 5),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Container(
                        child: Text(
                          "Mobile No :",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      new Container(
                        child: Text(
                          widget.mobileno ?? "",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 1),
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.5, horizontal: 30.0),
                  padding: EdgeInsets.only(left: 5),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Container(
                        child: Text(
                          "Valid upto :",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      new Container(
                        child: Text(
                          widget.validdate ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  "Enter the transaction OTP and click on 'Submit'",
                  style: TextStyle(
                    fontSize: 13.0,
                  ),
                ),
                SizedBox(height: 5.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          height: 30,
                          margin: EdgeInsets.fromLTRB(5, 15, 0, 0),
                          child: Text(
                            'Enter OTP :',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ),
                    Expanded(
                      child: Container(
                          height: 45.0,
                          width: 200.0,
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: TextField(
                            maxLength: 5,
                            controller: otpedittext,
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontSize: 13.0, color: Colors.black),
                            ),
                            keyboardType: TextInputType.phone,
                          )),
                    ),
                  ],
                ),
                // Unique Pass number
                //     : 11430
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FilledButton(
                        //width: 100,
                        //height: 40,
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                            backgroundColor: Color(0xFF40C4FF)),
                        onPressed: () {
                          setState(() {
                            _hasBeenPressed = false;
                          });

                          Navigator.of(contextb).pop();
                        }),
                    FilledButton(
                      //width: 100,
                      //height: 40,
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                          backgroundColor: _hasBeenPressed
                              ? Colors.black38
                              : Colors.lightBlueAccent),
                      onPressed: () {
                        if (_hasBeenPressed == false) {
                          setState(() {
                            _hasBeenPressed = true;
                          });
                          if (otpedittext.text.length < 0) {
                            Fluttertoast.showToast(
                                msg: 'Enter OTP',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                //  timeInSecForIos: 5,
                                backgroundColor: Colors.pink,
                                textColor: Colors.white,
                                fontSize: 14.0);
                            setState(() {
                              _hasBeenPressed = false;
                            });
                          } else if (otpedittext.text != widget.varifiedOtp) {
                            Fluttertoast.showToast(
                                msg: 'Enter Correct OTP',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                // timeInSecForIos: 5,
                                backgroundColor: Colors.pink,
                                textColor: Colors.white,
                                fontSize: 14.0);
                            setState(() {
                              _hasBeenPressed = false;
                            });
                          } else {
                            save_application_details();
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
