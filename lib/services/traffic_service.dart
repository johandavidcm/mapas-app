import 'dart:async';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:map_app/helpers/debouncer.dart';
import 'package:map_app/models/reverse_response.dart';
import 'package:map_app/models/search_response.dart';
import 'package:map_app/models/traffic_response.dart';

class TrafficService {
  // Singleton
  TrafficService._privateConstructor();
  static final TrafficService _instance = TrafficService._privateConstructor();

  factory TrafficService() {
    return _instance;
  }
  final _dio = new Dio();
  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 400));
  Stream<SearchResponse> get sugerenciasStream =>
      this._sugerenciasStreamController.stream;
  final StreamController<SearchResponse> _sugerenciasStreamController =
      StreamController<SearchResponse>.broadcast();

  void dispose() {
    _sugerenciasStreamController?.close();
  }

  final _baseURLGeo = 'https://api.mapbox.com/geocoding/v5/mapbox.places';
  final _baseURLDir = 'https://api.mapbox.com/directions/v5/mapbox';
  final _apiKey =
      'pk.eyJ1Ijoiam9oYW5kYXZpZGNtIiwiYSI6ImNrbW1iNTA1eTBkdHMydm54Ym5tdmsyZW8ifQ.MMefF_AnqW9IQJD88nSboQ';

  Future<DrivingResponse> getCoordsInicioYFin(
      LatLng inicio, LatLng destino) async {
    final coordsString =
        '${inicio.longitude},${inicio.latitude};${destino.longitude},${destino.latitude}';
    final url = '${this._baseURLDir}/driving/$coordsString';
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

  Future<SearchResponse> getResultadosPorQuery(
      String busqueda, LatLng proximidad) async {
    try {
      final url = '${this._baseURLGeo}/$busqueda.json';
      final resp = await this._dio.get(url, queryParameters: {
        'access_token': this._apiKey,
        'autocomplete': 'true',
        'country': 'co',
        'proximity': '${proximidad.longitude},${proximidad.latitude}',
        'language': 'es'
      });
      final searchResponse = searchResponseFromJson(resp.data);
      return searchResponse;
    } catch (e) {
      return SearchResponse(features: []);
    }
  }

  void getSugerenciasPorQuery(String busqueda, LatLng proximidad) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final resultados = await this.getResultadosPorQuery(value, proximidad);
      this._sugerenciasStreamController.add(resultados);
    };

    final timer = Timer.periodic(Duration(milliseconds: 200), (_) {
      debouncer.value = busqueda;
    });

    Future.delayed(Duration(milliseconds: 201)).then((_) => timer.cancel());
  }

  Future<ReverseQueryResponse> getCoordenadasQueryInfo(
      LatLng destinoCoords) async {
    final url =
        '${this._baseURLGeo}/${destinoCoords.longitude},${destinoCoords.latitude}.json';
    final resp = await this._dio.get(url, queryParameters: {
      'access_token': this._apiKey,
      'language': 'es',
    });
    final data = reverseQueryResponseFromJson(resp.data);
    return data;
  }
}
