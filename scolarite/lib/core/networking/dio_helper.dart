import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:scolarite/core/navigation/app_routes.dart';
import 'package:scolarite/core/networking/endpoints.dart';
import 'package:scolarite/core/utils/secure_storage.dart';
import 'package:scolarite/core/utils/service_locator.dart';

class DioHelper {
  Dio? dio;

  DioHelper() {
    dio ??= Dio(
      BaseOptions(baseUrl: EndPoints.baseUrl, receiveDataWhenStatusError: true),
    );

    dio!.interceptors.add(PrettyDioLogger());
    dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
          bool needsToken = options.extra['needsToken'] ?? true;
          bool isTemporary = options.extra['isTemporary'] ?? false;

          if (needsToken) {
            String? token = isTemporary
                ? await sl<SecureStorage>().getauthtoken()
                : await sl<SecureStorage>().getaccessToken();

            if (token != null) {
              options.headers["Authorization"] = "Bearer $token";
            }
          }
          return handler.next(options);
        },
      ),
    );

    dio!.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, ErrorInterceptorHandler handler) async {
          bool isTemporary = e.requestOptions.extra['isTemporary'] ?? false;
          bool needsToken = e.requestOptions.extra['needsToken'] ?? true;

          if (e.response?.statusCode == 401 && needsToken && !isTemporary && e.requestOptions.extra['isRetry'] != true) {
            try {
              String? oldRefreshToken = await sl<SecureStorage>().getrefreshToken();
              if (oldRefreshToken != null) {
                Response? response = await refreshTokenMethod(oldRefreshToken);
                if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
                  String newAccess = response.data['access_token'];
                  String newRefresh = response.data['refresh_token'];

                  await sl<SecureStorage>().setAccessToken(newAccess);
                  await sl<SecureStorage>().setRefreshToken(newRefresh);

                  final options = e.requestOptions;
                  options.headers["Authorization"] = "Bearer $newAccess";
                  options.extra['isRetry'] = true;

                  final retryResponse = await dio!.fetch(options);
                  return handler.resolve(retryResponse);
                }
              }
              await _logout();
              return handler.reject(e);
            } catch (err) {
              await _logout();
              return handler.next(e);
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<void> _logout() async {
    await sl<SecureStorage>().removeaccessToken();
    await sl<SecureStorage>().removerefreshToken();
    sl<GoRouter>().pushReplacement(AppRoutes.login);
  }

  // ------------------- GET avec support query params -------------------
  Future<Response> getrequest({
    required String endpoints,
    Map<String, dynamic>? queryParameters, // <-- ajouté
  }) async {
    try {
      return await dio!.get(
        endpoints,
        queryParameters: queryParameters, // <-- passe les query params à Dio
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          extra: {'isTemporary': false, 'needsToken': true, 'isRetry': false},
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  // ------------------- Les autres méthodes POST, PATCH, DELETE restent inchangées -------------------
  Future<Response> postrequestwhithtoken({
    required String endpoints,
    required dynamic data,
    required bool isTemporary,
  }) async {
    try {
      return await dio!.post(
        endpoints,
        data: data,
        options: Options(
          headers: {
            'Content-Type': data is FormData ? 'multipart/form-data' : 'application/json',
            'Accept': 'application/json',
          },
          extra: {'isTemporary': isTemporary, 'needsToken': true, 'isRetry': false},
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> postrequest({required String endpoints, required Map<String, dynamic> data}) async {
    try {
      return await dio!.post(
        endpoints,
        data: data,
        options: Options(
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
          extra: {'needsToken': false, 'isTemporary': false},
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleterequest({required String endpoints}) async {
    try {
      return await dio!.delete(
        endpoints,
        options: Options(
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
          extra: {'needsToken': true, 'isTemporary': false, 'isRetry': false},
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> patchrequest({required String endpoints, dynamic data}) async {
    try {
      return await dio!.patch(
        endpoints,
        data: data,
        options: Options(
          headers: {
            'Content-Type': data is FormData ? 'multipart/form-data' : 'application/json',
            'Accept': 'application/json',
          },
          extra: {'needsToken': true, 'isTemporary': false, 'isRetry': false},
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  // ------------------- REFRESH TOKEN -------------------
  Future<Response?> refreshTokenMethod(String oldRefreshToken) async {
    try {
      Dio refreshDio = Dio(BaseOptions(baseUrl: EndPoints.baseUrl, receiveDataWhenStatusError: true));
      return await refreshDio.post(
        EndPoints.refreshtoken,
        data: {'refresh_token': oldRefreshToken},
        options: Options(headers: {'Content-Type': 'application/json', 'Accept': 'application/json'}),
      );
    } catch (e) {
      return null;
    }
  }
}