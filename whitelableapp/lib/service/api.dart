
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wa_flutter_lib/wa_flutter_lib.dart';

class ServiceApis {

  Future<http.Response> getUserDetail({required String userId})async{

    Uri url = Uri.parse("$baseUrl/user/details/$userId");

    http.Response response = await http.Client().get(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Token ${SharedPreference.getUser()!.token}"
      },
    );

    if(response.statusCode == 200){
      printMessage("GET USER DETAIL RESPONSE = ${response.body}");
      return response;
    }else{
      printMessage("GET USER DETAIL RESPONSE = ${response.statusCode}");
      printMessage("GET USER DETAIL RESPONSE = ${response.body}");
      return response;
    }

  }

  Future<http.Response> razorpayCallback({
    required String id,
    required String paymentId,
    required String orderId,
    required String signature,
  })async{
    Uri url = Uri.parse("$baseUrl/payment/razorpay/callback/$id");

    var body = {
      "razorpay_payment_id": paymentId,
      "razorpay_order_id": orderId,
      "razorpay_signature": signature
    };

    http.Response response = await http.Client().post(
      url,
      body: body,
    );

    if(response.statusCode == 200){
      printMessage("RAZORPAY CALLBACK RESPONSE = ${response.body}");
      return response;
    }else{
      printMessage("RAZORPAY CALLBACK RESPONSE = ${response.statusCode}");
      printMessage("RAZORPAY CALLBACK RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> stripeCallback({
    required String id,
  })async{
    Uri url = Uri.parse("$baseUrl/payment/stripe/callback/$id");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    printMessage("STRIPE CALLBACK RESPONSE STATUS= ${response.statusCode}");
    if(response.statusCode == 200){
      printMessage("STRIPE CALLBACK RESPONSE = ${response.body}");
      return response;
    }else{
      printMessage("STRIPE CALLBACK RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> getPaymentDetail({required String paymentId})async{
    Uri url = Uri.parse("$baseUrl/payment/details/$paymentId");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("GET PAYMENT DETAIL RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("GET PAYMENT DETAIL RESPONSE = ${response.statusCode}");
      printMessage("GET PAYMENT DETAIL RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> getBusinessStaffList({String? search})async{
    Uri url = Uri.parse("$baseUrl/user/business/staff/list${search != null ? "?search=$search" : ""}");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("GET BUSINESS STAFF LIST RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("GET BUSINESS STAFF LIST RESPONSE = ${response.statusCode}");
      printMessage("GET BUSINESS STAFF LIST RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> getAppUserList()async{
    Uri url = Uri.parse("$baseUrl/user/business/customer/list");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("GET APP USER LIST RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("GET APP USER LIST RESPONSE = ${response.statusCode}");
      printMessage("GET APP USER LIST RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> changeUserRole({required int userId, required String type})async{
    Uri url = Uri.parse("baseUrl/user/update/role/$userId");

    var body = jsonEncode({
      "type": type,
    });

    http.Response response = await http.Client().patch(
        url,
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("CHANGE USER TYPE RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("CHANGE USER TYPE RESPONSE = ${response.statusCode}");
      printMessage("CHANGE USER TYPE RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> getProjectList()async{
    Uri url = Uri.parse("$baseUrl/tasktimertacker/project/list");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("GET PROJECT LIST RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("GET PROJECT LIST RESPONSE = ${response.statusCode}");
      printMessage("GET PROJECT LIST RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> createProject({required String projectName, String? projectDescription, List<dynamic>? team})async{
    Uri url = Uri.parse("$baseUrl/tasktimertacker/project/create");

    final body = jsonEncode({
      "name": projectName,
      "description": projectDescription ?? "",
      "team": team ?? [],
      "manager": SharedPreference.getUser()!.id,
    });

    http.Response response = await http.Client().post(
        url,
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("CREATE PROJECT RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("CREATE PROJECT RESPONSE = ${response.statusCode}");
      printMessage("CREATE PROJECT RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> updateProject({required String projectId, required String projectName, String? projectDescription, List<dynamic>? team})async{
    Uri url = Uri.parse("$baseUrl/tasktimertacker/project/update/$projectId");

    final body = jsonEncode({
      "name": projectName,
      "description": projectDescription ?? "",
      "team": team ?? [],
      "manager": SharedPreference.getUser()!.id,
    });

    http.Response response = await http.Client().patch(
        url,
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("UPDATE PROJECT RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("UPDATE PROJECT RESPONSE = ${response.statusCode}");
      printMessage("UPDATE PROJECT RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> updateProjectStatus({required String projectId, required String status,})async{
    Uri url = Uri.parse("$baseUrl/tasktimertacker/project/update/status/$projectId");

    final body = jsonEncode({
      "status": status,
    });

    http.Response response = await http.Client().patch(
        url,
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("UPDATE PROJECT STATUS RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("UPDATE PROJECT STATUS RESPONSE = ${response.statusCode}");
      printMessage("UPDATE PROJECT STATUS RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> deleteProject({required String projectId})async{
    Uri url = Uri.parse("$baseUrl/tasktimertacker/project/delete/$projectId");

    http.Response response = await http.Client().delete(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 204){
      printMessage("PROJECT DELETE RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("PROJECT DELETE RESPONSE = ${response.statusCode}");
      printMessage("PROJECT DELETE RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> createTask({required String taskName, String? taskDescription, required int projectId})async{
    Uri url = Uri.parse("$baseUrl/tasktimertacker/task/create");

    final body = jsonEncode({
      "name": taskName,
      "description": taskDescription ?? "",
      "project": projectId,
    });

    http.Response response = await http.Client().post(
        url,
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 201){
      printMessage("CREATE TASK RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("CREATE TASK RESPONSE = ${response.statusCode}");
      printMessage("CREATE TASK RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> getTaskList({String? projectId, String? search, String? ids, String? status})async{
    Uri url = Uri.parse("$baseUrl/tasktimertacker/task/list?project=${projectId ?? ""}&search=${search ?? ""}&ids=${ids ?? ""}&status=${status ?? ""}");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("GET TASK LIST RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("GET TASK LIST RESPONSE = ${response.statusCode}");
      printMessage("GET TASK LIST RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> getTask({required int taskId})async{
    Uri url = Uri.parse("$baseUrl/tasktimertacker/task/get/$taskId");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("GET TASK RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("GET TASK RESPONSE = ${response.statusCode}");
      printMessage("GET TASK RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> updateTask({required String taskId, required String taskName, String? taskDescription, required int projectId})async{
    Uri url = Uri.parse("$baseUrl/tasktimertacker/task/update/$taskId");

    final body = jsonEncode({
      "name": taskName,
      "description": taskDescription ?? "",
      "project": projectId,
    });

    http.Response response = await http.Client().patch(
        url,
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("UPDATE PROJECT RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("UPDATE PROJECT RESPONSE = ${response.statusCode}");
      printMessage("UPDATE PROJECT RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> updateTaskStatus({required String taskId, required String status,})async{
    Uri url = Uri.parse("$baseUrl/tasktimertacker/task/update/status/$taskId");

    final body = jsonEncode({
      "status": status,
    });

    http.Response response = await http.Client().patch(
        url,
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("UPDATE TASK STATUS RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("UPDATE TASK STATUS RESPONSE = ${response.statusCode}");
      printMessage("UPDATE TASK STATUS RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> deleteTask({required String taskId})async{
    Uri url = Uri.parse("$baseUrl/tasktimertacker/task/delete/$taskId");

    http.Response response = await http.Client().delete(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 204){
      printMessage("TASK DELETE RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("TASK DELETE RESPONSE = ${response.statusCode}");
      printMessage("TASK DELETE RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> assignTask({required int developerId, required int taskId, String? note})async{
    Uri url = Uri.parse("$baseUrl/tasktimertacker/assigned_task/create");

    final body = jsonEncode({
      "note": note ?? "",
      "developer": developerId,
      "task": taskId
    });

    http.Response response = await http.Client().post(
        url,
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 201){
      printMessage("ASSIGN TASK RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("ASSIGN TASK RESPONSE = ${response.statusCode}");
      printMessage("ASSIGN TASK RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> getManagerTaskList({String? taskId})async{
    Uri url = Uri.parse("$baseUrl/tasktimertacker/assigned_task/manager/list${taskId != null ? "?task_id=$taskId" : ""}");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("GET MANAGER TASK LIST RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("GET MANAGER TASK LIST RESPONSE = ${response.statusCode}");
      printMessage("GET MANAGER TASK LIST RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> getDeveloperTaskList({String? projectId, String? search, String? ids, String? status})async{
    Uri url = Uri.parse("$baseUrl/tasktimertacker/assigned_task/developer/list");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("GET DEVELOPER TASK LIST RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("GET DEVELOPER TASK LIST RESPONSE = ${response.statusCode}");
      printMessage("GET DEVELOPER TASK LIST RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> changeAssignedTaskDeveloper({required int taskId, required int developerId, String? note})async{
    Uri url = Uri.parse("$baseUrl/tasktimertacker/assigned_task/change/developer/$taskId");

    final body = jsonEncode({
      "developer": developerId,
      "note": note ?? "",
    });

    http.Response response = await http.Client().patch(
        url,
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("CHANGE ASSIGN TASK DEVELOPER RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("CHANGE ASSIGN TASK DEVELOPER RESPONSE = ${response.statusCode}");
      printMessage("CHANGE ASSIGN TASK DEVELOPER RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> deleteAssignedTask({required int assignTaskId})async{
    Uri url = Uri.parse("$baseUrl/tasktimertacker/assigned_task/delete/$assignTaskId");

    http.Response response = await http.Client().delete(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 204){
      printMessage("ASSIGN TASK DELETE RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("ASSIGN TASK DELETE RESPONSE = ${response.statusCode}");
      printMessage("ASSIGN TASK DELETE RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> createTimeLogTask({required int assignTaskId, String? startTime, String? endTime, String? note})async{
    Uri url = Uri.parse("$baseUrl/tasktimertacker/time_log_task/create");

    String currentTime = DateTime.now().toIso8601String();
    final body = jsonEncode({
      "start_time": startTime ?? currentTime,
      "end_time": endTime ?? currentTime,
      "note": note ?? "",
      "assigned_task": assignTaskId,
    });
    printMessage("----$body");

    http.Response response = await http.Client().post(
        url,
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 201){
      printMessage("ASSIGN TASK TIME LOG CREATE RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("ASSIGN TASK TIME LOG CREATE RESPONSE = ${response.statusCode}");
      printMessage("ASSIGN TASK TIME LOG CREATE RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> getTimeLogTaskList({int? assignTaskId,})async{
    Uri url = Uri.parse("$baseUrl/tasktimertacker/time_log_task/list${assignTaskId != null ? "?assigned_task_id=$assignTaskId" : ""}");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("ASSIGN TASK TIME LOG LIST RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("ASSIGN TASK TIME LOG LIST RESPONSE = ${response.statusCode}");
      printMessage("ASSIGN TASK TIME LOG LIST RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> getDeveloperReport({required String startDate, required String endDate})async{
    Uri url = Uri.parse("$baseUrl/tasktimertacker/developer/report");

    var body = jsonEncode({
      "start_date": startDate,
      "end_date": endDate,
    });

    http.Response response = await http.Client().post(
        url,
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("GET DEVELOPER REPORT RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("GET DEVELOPER REPORT RESPONSE = ${response.statusCode}");
      printMessage("GET DEVELOPER REPORT RESPONSE = ${response.body}");
      return response;
    }
  }


  Future<http.Response> getCoinTransactions({String? searchText, String? date, String? type})async{
    Uri url = Uri.parse("$baseUrl/coin/transactions/list?${searchText != null ? "search=$searchText" : ""}${date != null ? "&created_at=$date" : ""}${type != null ? "&type=$type" :  ""}");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("GET COIN TRANSACTION LIST RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("GET COIN TRANSACTION LIST RESPONSE = ${response.statusCode}");
      printMessage("GET COIN TRANSACTION LIST RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> redeemCoins({required double coin, required String upiId})async{
    Uri url = Uri.parse("$baseUrl/coin/redeem/create");

    final body = jsonEncode({
      "coin": coin,
      "upi_id": upiId,
    });

    http.Response response = await http.Client().post(
        url,
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("REDEEM COINS RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("REDEEM COINS RESPONSE = ${response.statusCode}");
      printMessage("REDEEM COINS RESPONSE = ${response.body}");
      return response;
    }
  }


  Future<http.Response> getReferralList()async{
    Uri url = Uri.parse("$baseUrl/user/referral/list");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("GET REFERRAL LIST RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("GET REFERRAL LIST RESPONSE = ${response.statusCode}");
      printMessage("GET REFERRAL LIST RESPONSE = ${response.body}");
      return response;
    }
  }

}