import 'dart:async';

import 'package:dio/dio.dart';
import 'package:ptit_quiz_frontend/di.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../data/providers/local_data.dart';
import '../../data/providers/remote_data.dart';

class DioTools {
  static String getBaseUrl() {
    return dotenv.get('API_URL', fallback: 'quiz-management-sandy.vercel.app');
  }

  static Dio get dio {
    Dio dio = Dio(BaseOptions(
      baseUrl: getBaseUrl(),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      validateStatus: (status) => status! < 500,
      headers: {
        'Content-Type': 'application/json',
      },
    ));
    return dio;
  }

  static Stream<bool> registerInceptor(Dio dio) {
    StreamController<bool> streamController = StreamController<bool>();
    Stream<bool> stream = streamController.stream;

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Authorization'] =
            'Bearer ' + DependencyInjection.sl<LocalData>().getToken();
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        if (response.statusCode == 401) {
          String refreshToken =
              DependencyInjection.sl<LocalData>().getRefreshToken();

          try {
            Map<String, dynamic> newToken =
                await DependencyInjection.sl<RemoteData>()
                    .refreshToken(refreshToken);
            if (newToken['access_token'] != null) {
              DependencyInjection.sl<LocalData>()
                  .saveToken(newToken['access_token']);
              DependencyInjection.sl<LocalData>()
                  .saveRefreshToken(newToken['refresh_token']);
              response.requestOptions.headers['access_token'] =
                  newToken['access_token'];
            }
          } catch (e) {
            return handler.reject(DioException(
                requestOptions: response.requestOptions, response: response));
          }

          try {
            Map<String, dynamic> newTokenAdmin =
                await DependencyInjection.sl<RemoteData>()
                    .refreshTokenAdmin(refreshToken);
            if (newTokenAdmin['access_token'] != null) {
              DependencyInjection.sl<LocalData>()
                  .saveToken(newTokenAdmin['access_token']);
              DependencyInjection.sl<LocalData>()
                  .saveRefreshToken(newTokenAdmin['refresh_token']);
              response.requestOptions.headers['access_token'] =
                  newTokenAdmin['access_token'];
            }
          } catch (e) {
            return handler.reject(DioException(
                requestOptions: response.requestOptions, response: response));
          }
          return handler.resolve(await dio.fetch(response.requestOptions));
        }
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        streamController.add(false);
        return handler.next(error);
      },
    ));

    return stream;
  }
}
