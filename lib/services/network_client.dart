

import 'package:dio/dio.dart';
import 'package:pixabay_image_viewer/constants/app_constants.dart';

class NetworkClient {

  static final Dio _client =Dio(
    BaseOptions(
      baseUrl: 'https://pixabay.com/api/',
      queryParameters: {
        'key':ImageViewerConstants.apiKey,
        'image_type': 'photo',
        'per_page': 50,
        'orientation':'vertical'
      }
    )
  );

  Future<Response> getImages({int pageNumber=1}) async{
    Response response = await _client.get(
      '',
      queryParameters: {
        'page': pageNumber
      }
    );
    print('AS :: Url :: ${response.realUri}');
    return response;
  }


}