import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuktraapp/models/api_response_model.dart';
import 'package:tuktraapp/models/user_model.dart';
import 'package:tuktraapp/utils/constant.dart';
import 'package:http/http.dart' as http;

//register
Future<ApiResponseModel> register(String username, String email, String password, String confirm, String loginType) async {
  ApiResponseModel apiResponse = ApiResponseModel();

  try {
    final response = await http.post(
      Uri.parse(registerURL),
      headers: {'Accept': 'application/json'},
      body: {
        'username': username,
        'email': email,
        'password': password,
        'password_confirmation': confirm,
        'login_type':loginType,
      });

      switch(response.statusCode) {
        case 200:
          apiResponse.data = UserModel.fromJson(jsonDecode(response.body));
          break;
        
        case 422:
          final errors = jsonDecode(response.body)['errors'];
          apiResponse.err = errors[errors.keys.elementAt(0)][0];
          break;
        
        default:
          apiResponse.err = other;
          break;
      }
  } catch (e) {
    apiResponse.err = serverError;
  }

  return apiResponse;
}

// login
Future<ApiResponseModel> login(String username, String password) async {
  ApiResponseModel apiResponse = ApiResponseModel();

  try {
    final response = await http.post(
      Uri.parse(loginURL),
      headers: {'Accept': 'application/json'},
      body: {'username': username, 'password': password}
    );

    switch(response.statusCode) {
      case 200:
        apiResponse.data = UserModel.fromJson(jsonDecode(response.body));
        // apiResponse.err = 'case 200';
        break;
      
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.err = errors[errors.keys.elementAt(0)][0];
        // apiResponse.err = 'case 422';
        break;
      
      case 403:
        apiResponse.err = jsonDecode(response.body)['message'];
        // apiResponse.err = 'case 403';
        break;

      default:
        apiResponse.err = other;
        // apiResponse.err = 'case other';
        break;
    } 
  } catch(e) {
    apiResponse.err = serverError;
  }

  return apiResponse; 
}

// logout
Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}

// get user token
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// get user id
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

// user detail
Future<ApiResponseModel> getUserDetail() async {
  ApiResponseModel apiResponse = ApiResponseModel();

  try {
    String token = await getToken();

    final response = await http.get(
      Uri.parse(userURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      switch(response.statusCode) {
        case 200:
          apiResponse.data = UserModel.fromJson(jsonDecode(response.body));
          break;

        case 401:
          apiResponse.err = unauthorized;
          break;
        
        default:
          apiResponse.err = other;
          break;
      }
  } catch (e) {
    apiResponse.err = serverError;
  }

  return apiResponse;
}