part of 'mapa_bloc.dart';

@immutable
class MapaState {
  final bool mapaListo;
  final bool seguirUbicacion;
  final bool dibujarRecorrido;
  final LatLng ubicacionCentral;

  // Polylines
  final Map<String, Polyline> polylines;

  MapaState(
      {this.dibujarRecorrido = false,
      this.mapaListo = false,
      this.seguirUbicacion = false,
      Map<String, Polyline> polylines,
      this.ubicacionCentral})
      : this.polylines = polylines ?? Map();

  copyWith(
          {bool mapaListo,
          bool dibujarRecorrido,
          bool seguirUbicacion,
          LatLng ubicacionCentral,
          Map<String, Polyline> polylines}) =>
      MapaState(
          mapaListo: mapaListo ?? this.mapaListo,
          dibujarRecorrido: dibujarRecorrido ?? this.dibujarRecorrido,
          seguirUbicacion: seguirUbicacion ?? this.seguirUbicacion,
          ubicacionCentral: ubicacionCentral ?? this.ubicacionCentral,
          polylines: polylines ?? this.polylines);
}
