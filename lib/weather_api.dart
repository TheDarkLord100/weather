import 'dart:convert';

import 'package:weather/weather.dart';
import 'package:weather_app/request_status.dart';

class WeatherApi {
  late final WeatherFactory wf;

  WeatherApi() {
    wf = WeatherFactory('ef0f78f151c685f37bc843a251e79a10');
  }

  Future<RequestStatus<Weather?>> getWeatherData(String city) async {
    try {
      Weather w = await wf.currentWeatherByCityName(city);
      return RequestStatus(status: RequestStatus.SUCCESS, body: w);
    } on OpenWeatherAPIException catch (e) {
      String ex = e.toString();
      String s = ex.substring(ex.indexOf('{'));
      final result = jsonDecode(s);
      return RequestStatus(status: RequestStatus.FAILURE, message: result['message'].toString().toUpperCase() );
    } on Exception catch (e) {
      return RequestStatus(status: RequestStatus.FAILURE, message: 'SOMETHING WENT WRONG');
    }
  }
}