import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:dio/dio.dart';
import 'package:esamudaayapp/modules/login/actions/login_actions.dart';
import 'package:esamudaayapp/store.dart';
import 'package:esamudaayapp/utilities/URLs.dart';
import 'package:esamudaayapp/utilities/user_manager.dart';
import 'package:flutter/cupertino.dart';

class APIManager {
  static var shared = APIManager();
  static beginRequest() {}
//  DioComputeParams data;

  static Future<ResponseModel> postRequest(List params) async {
    Dio dio = new Dio(new BaseOptions(
      baseUrl: ApiURL.baseURL,
      connectTimeout: 50000,
      receiveTimeout: 100000,
      followRedirects: false,
      validateStatus: (status) {
        return status < 500;
      },
      responseType: ResponseType.json,
    ));
//    dio.head(params[1]);
//    dio.interceptors.add(CookieManager(params.last));
    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      request: true,
      requestBody: true,
    ));
    return await dio
        .post(
      params[1],
      data: params.first,
    )
        .then((res) {
      if (res.statusCode == 400) {
        return ResponseModel(res.data, ResponseStatus.error404);
      } else if (res.statusCode >= 500) {
        return ResponseModel(res.data, ResponseStatus.error500);
      } else if (res.statusCode == 401) {
        return ResponseModel(res.data, ResponseStatus.error401);
      } else {
        return ResponseModel(res.data, ResponseStatus.success200);
      }
    }).catchError((error) {
      print(error);
      return ResponseModel(null, ResponseStatus.error500);
    });
  }

  Future<ResponseModel> request(
      {params: dynamic,
      url: String,
      requestType: RequestType,
      beginCallback: Function}) async {
    emptyParams[''] = '';

    String token = await UserManager.getToken();
    var dio = new Dio(new BaseOptions(
      baseUrl: ApiURL.baseURL,
      connectTimeout: 50000,
      receiveTimeout: 100000,
      followRedirects: false,
      validateStatus: (status) {
        return status < 500;
      },
      responseType: ResponseType.json,
//      contentType: ContentType.json,
    ));
//    Directory appDocDir = await getApplicationDocumentsDirectory();
//    String appDocPath = appDocDir.path;
//    var cookieJar = PersistCookieJar(dir: appDocPath + "/.cookies/");
//    cookieJar.loadForRequest(Uri.parse(ApiURL.baseURL + url));
//    dio.interceptors.add(CookieManager(cookieJar));
    if (token != null && token != "") {
      dio.options.headers = {
        "Authorization": "JWT $token",
      };
    }
    dio.interceptors.add(LogInterceptor(
        responseBody: true,
        request: true,
        requestBody: true,
        requestHeader: true));

    switch (requestType) {
      case RequestType.get:
        try {
          return await dio.get(url, queryParameters: params).then((response) {
            if (response.statusCode == 400) {
              return ResponseModel(response.data, ResponseStatus.error404);
            } else if (response.statusCode >= 500) {
              return ResponseModel(response.data, ResponseStatus.error500);
            } else if (response.statusCode == 401) {
              return ResponseModel(response.data, ResponseStatus.error401);
            } else if (response.statusCode == 429) {
              return ResponseModel(response.data, ResponseStatus.error404);
            } else {
              return ResponseModel(response.data, ResponseStatus.success200);
            }
          });
        } catch (e) {
          print(e);
          return ResponseModel(null, ResponseStatus.error500);
        }
        break;
      case RequestType.post:
        return await dio
            .post(
          url,
          data: params,
        )
            .then((res) {
          debugPrint(res.toString(), wrapWidth: 1024);

          if (res.data["statusCode"] == 450) {
            store.dispatch(UserExceptionAction(
              "Session expired, Please login to continue..",
            ));
            store.dispatch(CheckTokenAction());
            UserManager.deleteUser();

            store.dispatch(NavigateAction.pushNamedAndRemoveAll('/loginView'));
          }
          if (res.statusCode == 400) {
            return ResponseModel(res.data, ResponseStatus.error404);
          } else if (res.statusCode >= 500) {
            return ResponseModel(res.data, ResponseStatus.error500);
          } else if (res.statusCode == 401) {
            return ResponseModel(res.data, ResponseStatus.error401);
          } else if (res.statusCode == 429) {
            return ResponseModel(res.data, ResponseStatus.error404);
          } else {
            return ResponseModel(res.data, ResponseStatus.success200);
          }
        }).catchError((error) {
          print(error);
          return ResponseModel(null, ResponseStatus.error500);
        });

//        final Directory dir = new Directory('$appDocPath/cookies');
//        await dir.create();
//        final cookiePath = dir.path;
//        var cookieJar = PersistCookieJar(dir: cookiePath);
//        data = DioComputeParams(dio: dio, params: params, url: url);
//        return await compute(postRequest, [params, url, cookieJar]);
      case RequestType.patch:
        try {
          return await dio.patch(url, data: params).then((response) {
            if (response.statusCode == 400) {
              return ResponseModel(response.data, ResponseStatus.error404);
            } else if (response.statusCode >= 500) {
              return ResponseModel(response.data, ResponseStatus.error500);
            } else if (response.statusCode == 401) {
              return ResponseModel(response.data, ResponseStatus.error401);
            } else {
              return ResponseModel(response.data, ResponseStatus.success200);
            }
          });
        } catch (e) {
          print(e);
          return ResponseModel(null, ResponseStatus.error500);
        }
        break;

      case RequestType.delete:
        try {
          return await dio.delete(url, data: params).then((response) {
            if (response.statusCode == 400) {
              return ResponseModel(response.data, ResponseStatus.error404);
            } else if (response.statusCode >= 500) {
              return ResponseModel(response.data, ResponseStatus.error500);
            } else if (response.statusCode == 401) {
              return ResponseModel(response.data, ResponseStatus.error401);
            } else {
              return ResponseModel(response.data, ResponseStatus.success200);
            }
          });
        } catch (e) {
          print(e);
          return ResponseModel(null, ResponseStatus.error500);
        }
        break;

      case RequestType.put:
        try {
          return await dio.put(url, data: params).then((response) {
            if (response.statusCode == 400) {
              return ResponseModel(response.data, ResponseStatus.error404);
            } else if (response.statusCode >= 500) {
              return ResponseModel(response.data, ResponseStatus.error500);
            } else if (response.statusCode == 401) {
              return ResponseModel(response.data, ResponseStatus.error401);
            } else {
              return ResponseModel(response.data, ResponseStatus.success200);
            }
          });
        } catch (e) {
          print(e);
          return ResponseModel(null, ResponseStatus.error500);
        }
        break;
    }
    return null;
  }
}

Map<String, dynamic> emptyParams = Map<String, dynamic>();
enum RequestType { get, post, put, patch, delete }
enum ResponseStatus { success200, error404, error500, error401, error400 }

class ResponseModel {
  final data;
  final ResponseStatus status;
  ResponseModel(this.data, this.status);
}

class DioComputeParams {
  Dio dio;
  String url;
  dynamic params;
  DioComputeParams({this.params, this.url, this.dio});
}
