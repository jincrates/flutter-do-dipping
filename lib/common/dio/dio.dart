import 'package:actual/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });

  // 1) 요청을 보낼 때
  // 요청이 보내질 때마다
  // 만약에 요청의 Header에 accessToken: true라는 값이 있다면
  // 실제로 토큰을 가져와서 (storage에서) authorization: Bearer $token으로
  // Header를 변경한다.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');

    //요청이 보내지기 전에 처리
    if (options.headers['accessToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('accessToken');
      
      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      // 실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      // 실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    // 요청이 보내지는 순간
    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을 때

  // 3) 에러가 났을 때
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // 401 에러가 났을 때(status code)
    // 토큰을 재발급 받는 시도를 하고 토큰이 재발급 되면
    // 다시 새로운 토큰으로 요청을 한다.
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // refreshToken 아예 없으면 에러를 던진다.
    if (refreshToken == null) {
      // 에러를 던질 때는 handler.reject를 사용한다.
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    // 토큰을 새로 refresh를 하려는 의도가 아닌데, 401이 터진 경우 동작
    // isPathRefresh를 true로 검증하는 경우, 무한 루프에 빠지겠지?
    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );

        final accessToken = resp.data['accessToken'];

        final options = err.requestOptions;

        // 토큰 변경하기
        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });

        // 스토리지에도 저장
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 요청 재전송: 에러를 발생시킨 요청을 잡아서 토큰만 변경하여 다시 재요청
        final response = await dio.fetch(options);

        return handler.resolve(response);
      } on DioError catch(e) {
        return handler.reject(e);
      }
    }

    return handler.reject(err);
  }
}