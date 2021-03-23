import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/models/traffic_response.dart';

class TrafficService {
  // Singleton
  TrafficService._privateConstructor();
  static final TrafficService _instance = TrafficService._privateConstructor();

  factory TrafficService() {
    return _instance;
  }
  final _dio = new Dio();
  final _baseURL = 'https://api.mapbox.com/directions/v5/mapbox';
  final _apiKey =
      'pk.eyJ1Ijoiam9oYW5kYXZpZGNtIiwiYSI6ImNrbW1iNTA1eTBkdHMydm54Ym5tdmsyZW8ifQ.MMefF_AnqW9IQJD88nSboQ';

  Future<DrivingResponse> getCoordsInicioYFin(
      LatLng inicio, LatLng destino) async {
    final coordsString =
        '${inicio.longitude},${inicio.latitude};${destino.longitude},${destino.latitude}';
    final url = '${this._baseURL}/driving/$coordsString';
    final resp = await this._dio.get(url, queryParameters: {
      'alternatives': 'true',
      'geometries': 'polyline6',
      'steps': 'false',
      'access_token': this._apiKey,
      'language': 'es',
    });
    final data = DrivingResponse.fromJson(resp.data);
    return data;
  }
}
