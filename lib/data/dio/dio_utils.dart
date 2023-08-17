
import 'dart:convert';
import 'package:alefakaltawinea_animals_app/utils/my_utils/apis.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/appConfig.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/constants.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myUtils.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class BaseDioUtils {
  static Dio? dio;
  static Options? authOptions;
  static CacheOptions cacheOptions = CacheOptions(store: MemCacheStore(), policy: CachePolicy.noCache);
  static const String REQUEST_GET = "get";
  static const String REQUEST_POST = "post";
  static const String REQUEST_PUT = "put";
  static const String REQUEST_DELETE = "delete";

  static void initDio() {
    if (dio == null) {
      dio = Dio();
      dio!.interceptors.add(DioCacheInterceptor(options: cacheOptions));
      dio!.interceptors.add(InterceptorsWrapper(onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
           options.headers['Accept-Language'] = Constants.SELECTED_LANGUAGE;
           options.headers['App-Version'] = Constants.APP_VERSION;
           options.headers['User-Agent'] = Constants.DEVICE_TYPE;
        var url = "${options.path}";

        print("$url : REQUEST : METHOD : ${options.method}");
        print("$url : REQUEST : HEADERS : ${options.headers}");
        print("$url : REQUEST : QPARAMS : ${options.queryParameters}");

        return handler.next(options);
      }, onResponse:
          (Response response, ResponseInterceptorHandler handler) async {
        var url = "${response.realUri.path}";
        print("$url : RESPONSE : ${response.statusCode}");
        print("$url : RESPONSE : ${response.statusMessage}");
        print("$url : RESPONSE : ${response.data ?? "null"}");

        return handler.next(response);
      }, onError: (DioError e, ErrorInterceptorHandler handler) async {
       /* var url = "${e.response!.realUri.path}";

        print("$url : ERROR : ${e.error}");
        print("$url : ERROR : ${e.message}");
        print("$url : ERROR : ${e.response?.data}");
        print("$url : ERROR : ${e.response?.statusCode}");
        print("$url : ERROR : ${e.response?.statusMessage}");*/
        if(e.message.contains("Connection closed before full header was received")){
          initDio();
        }

        return handler.next(e);
      }));
    }
    ///add token
    authOptions = Options(headers: {
      'authorization': 'Bearer ${Apis.TOKEN_VALUE}',
    });
  }

  static Dio? instance() {
    initDio();
    return dio;
  }

  static Future<Response?> request(
      String requestType,
      String url, {
        String? contentType,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
        dynamic body,
        Options? requestOption,
        bool isToCache = true,
        bool forceRefresh = true,
        int daysToCache = 30,
        int hoursToCache = 0,
      }) async {
    initDio();

    if (Apis.TOKEN_VALUE.isEmpty) {
      authOptions!.headers = {};
    }

    //authOptions!.headers!["xAppVersion"] = BaseConfig.APP_VERSION_NAME;
   // authOptions!.headers!["xOsVersion"] = Platform.operatingSystemVersion;
    //authOptions!.headers!["xPlatform"] = Platform.operatingSystem;

    if (headers != null && headers.isNotEmpty) {
      headers.keys.forEach((key) {
        authOptions!.headers![key] = headers[key];
      });
    }

    if (contentType != null)
      authOptions!.headers![Headers.contentTypeHeader] = contentType;

    print("Apis.TOKEN_VALUE ${Apis.TOKEN_VALUE}");
    print("$url : headers : ${jsonEncode(authOptions!.headers)}");
    if (body != null) MyUtils.printLongLine("$url : body : ${body.toString()}");

    var options = isToCache
        ? cacheOptions.copyWith(
        policy: forceRefresh
            ? CachePolicy.refreshForceCache
            : CachePolicy.forceCache,
        maxStale: Nullable(Duration(days: daysToCache, hours: hoursToCache)))
        .toOptions()
        : authOptions;

    if(isToCache) {
      if(options!.headers == null) options.headers = {};
      options.headers!.addAll(authOptions!.headers!);
    }

    Response? response;

    try {
      switch (requestType) {
        case REQUEST_GET:
          response = await dio!.get(
            url,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case REQUEST_POST:
          response = await dio!.post(
            url,
            options: requestOption ?? options,
            queryParameters: queryParameters,
            data: body,
            onSendProgress: (int sent, int total) =>
                print("$url : sent : $sent/$total"),
            onReceiveProgress: (recieved, total) =>
                print("$url : recieved : $recieved/$total"),

          );
          break;
        case REQUEST_PUT:
          response = await dio!.put(
            url,
            options: options,
            queryParameters: queryParameters,
            data: body,
            onSendProgress: (int sent, int total) =>
                print("$url : sent : $sent/$total"),
            onReceiveProgress: (recieved, total) =>
                print("$url : recieved : $recieved/$total"),
          );
          break;
        case REQUEST_DELETE:
          response = await dio!.delete(
            url,
            options: options,
            queryParameters: queryParameters,
            data: body,
          );
          break;
      }
    } catch (e) {

      var error = e as DioError;
      if(error.message.contains("Connection closed before full header was received")){
        await request(requestType, url,body: body, contentType:contentType,
          queryParameters:queryParameters,
          headers:headers,
          requestOption:requestOption,
          isToCache:isToCache,
          forceRefresh:forceRefresh,
          daysToCache:daysToCache,
          hoursToCache:hoursToCache,
        );
      }else{
        response = error.response!;
      }

    }

    printResponse(url, response);

    return response;
  }

  static printResponse(String url, Response? response) {
    if (response != null) {
      print("$url : ${response.statusCode} ${response.data}");
    } else {
      print("$url : response == null");
    }
  }
}
