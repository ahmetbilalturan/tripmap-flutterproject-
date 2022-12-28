// ignore_for_file: unused_catch_clause

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  String ip = "192.168.1.11";
  // ignore: unnecessary_new
  Dio dio = new Dio();

  login(username, password) async {
    try {
      return await dio.post('http://$ip:5554/login',
          data: {
            "username": username,
            "password": password,
          },
          options: Options(contentType: Headers.formUrlEncodedContentType));
    } on DioError catch (e) {
      Fluttertoast.showToast(
        msg: e.response!.data['msg'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  adduser(username, password, email, fullname) async {
    try {
      return await dio.post('http://$ip:5554/adduser',
          data: {
            "username": username,
            "password": password,
            "email": email,
            'fullname': fullname,
          },
          options: Options(contentType: Headers.formUrlEncodedContentType));
    } on DioError catch (e) {
      rethrow;
    }
  }

  getinfo(usertoken) async {
    try {
      return await dio.get('http://$ip:5554/getinfo',
          options: Options(headers: {"Authorization": 'Bearer $usertoken'}));
    } on DioError catch (e) {
      Fluttertoast.showToast(
        msg: e.response!.data['msg'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<List> getlocationcomments(int locationID) async {
    try {
      final res = await dio.post(
        'http://$ip:5554/getcomments',
        data: {'locationId': locationID},
      );
      if (res.data['success']) {
        return res.data['array'];
      } else {
        return List.empty();
      }
    } on DioError catch (e) {
      rethrow;
    }
  }

  makecomment(int userid, int locationid, String content, double rating) async {
    try {
      final res = await dio.post('http://$ip:5554/addcomment', data: {
        'userId': userid,
        'locationId': locationid,
        'content': content,
        'rating': rating
      });
      return res.data['msg'];
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<List> getdistricts() async {
    try {
      final res = await dio.post('http://$ip:5554/getdistricts');
      if (res.data['success']) {
        return res.data['array'];
      } else {
        return List.empty();
      }
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<List> getlocations(int districtid) async {
    try {
      final res = await dio.post('http://$ip:5554/findlocations',
          data: {'locationdistrictId': districtid});
      if (res.data['success']) {
        return res.data['array'];
      } else {
        return List.empty();
      }
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<List> gettypes() async {
    try {
      final res = await dio.post('http://$ip:5554/gettypes');
      if (res.data['success']) {
        return res.data['array'];
      } else {
        return List.empty();
      }
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<List> getalllocations() async {
    try {
      final res = await dio.post('http://$ip:5554/getalllocations');
      if (res.data['success']) {
        return res.data['array'];
      } else {
        return List.empty();
      }
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<List> getbookmarks(int id) async {
    try {
      final res = await dio.post('http://$ip:5554/getbookmarks', data: {
        'userid': id,
      });
      if (res.data['success']) {
        return res.data['array'];
      } else {
        return List.empty();
      }
    } on DioError catch (e) {
      rethrow;
    }
  }

  removefrombookmarks(int userid, int locationid) async {
    try {
      final res = await dio.post('http://$ip:5554/removefrombookmarks',
          data: {'userid': userid, 'locationId': locationid});
      if (res.data['success']) {
        return res.data['msg'];
      }
    } on DioError catch (e) {
      rethrow;
    }
  }

  addtobookmarks(int userid, int locationid) async {
    try {
      final res = await dio.post('http://$ip:5554/addtobookmarks',
          data: {'userid': userid, 'locationId': locationid});
      if (res.data['success']) {
      } else {
        Fluttertoast.showToast(
          msg: res.data['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<bool> checkifitsinbookmarks(int userid, int locationid) async {
    try {
      final res = await dio.post('http://$ip:5554/checkifitsinbookmarks',
          data: {'userid': userid, 'locationId': locationid});
      if (res.data['success']) {
        return res.data['condition'];
      } else {
        return false;
      }
    } on DioError catch (e) {
      rethrow;
    }
  }

  getonefromlocations(locationid) async {
    try {
      final res = await dio.post('http://$ip:5554/getonefromlocations',
          data: {'locationId': locationid});
      return res.data['location'];
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<int> getlocationidfromname(String locationname) async {
    try {
      final res = await dio.post('http://$ip:5554/getlocationidfromname',
          data: {'locationname': locationname});
      return res.data['locationid'];
    } on DioError catch (e) {
      rethrow;
    }
  }

  changeusername(int userid, String username) async {
    try {
      await dio.post('http://$ip:5554/changeusername',
          data: {'userid': userid, 'username': username});
    } on DioError catch (e) {
      rethrow;
    }
  }

  changepassword(int userid, String password) async {
    try {
      await dio.post('http://$ip:5554/changepassword',
          data: {'userid': userid, 'password': password});
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<List> getroutes(int userid) async {
    try {
      final res =
          await dio.post('http://$ip:5554/getroutes', data: {'userid': userid});
      if (res.data['success']) {
        return res.data['array'];
      } else {
        return List.empty();
      }
    } on DioError catch (e) {
      rethrow;
    }
  }

  addtoroutes(int userid, String locationname) async {
    try {
      await dio.post('http://$ip:5554/addtoroutes',
          data: {'userid': userid, 'routelocationname': locationname});
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<String> getusernamefromid(int userid) async {
    try {
      final res = await dio
          .post('http://$ip:5554/getusernamefromid', data: {'userid': userid});
      if (res.data['success']) {
        return res.data['username'];
      } else {
        return 'Bilinmeyen Kullanıcı';
      }
    } on DioError catch (e) {
      rethrow;
    }
  }
}
