import 'package:covid19app/model/model.dart';
import 'package:dio/dio.dart';

class Api {
  Dio dio = Dio();

  final String _api = 'https://corona.lmao.ninja/v2/all';

  Future<ApiModel> getTotal() async {
    try {
      Response response = await dio.get(_api);
      return ApiModel.fromJson(response.data);
    } catch (error) {
      print(error);
      return null;
    }
  }

  final String daily =
      "https://corona.lmao.ninja/v3/covid-19/historical/all?lastdays=7";
  Future<dynamic> getDaily() async {
    try {
      Response response = await dio.get((daily));

      return response.data;
    } catch (error) {
      return null;
    }
  }
}
