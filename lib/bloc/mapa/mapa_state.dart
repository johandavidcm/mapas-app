part of 'mapa_bloc.dart';

@immutable
class MapaState {
  final bool mapaListo;
  final bool seguirUbicacion;
  final bool dibujarRecorrido;
  final LatLng ubicacionCentral;

  // Polylines
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

  MapaState(
      {this.dibujarRecorrido = false,
      this.mapaListo = false,
      this.seguirUbicacion = false,
      Map<String, Polyline> polylines,
      Map<String, Marker> markers,
      this.ubicacionCentral})
      : this.polylines = polylines ?? Map(),
        this.markers = markers ?? Map();

  copyWith({
    bool mapaListo,
    bool dibujarRecorrido,
    bool seguirUbicacion,
    LatLng ubicacionCentral,
    Map<String, Polyline> polylines,
    Map<String, Marker> markers,
  }) =>
      MapaState(
        mapaListo: mapaListo ?? this.mapaListo,
        dibujarRecorrido: dibujarRecorrido ?? this.dibujarRecorrido,
        seguirUbicacion: seguirUbicacion ?? this.seguirUbicacion,
        ubicacionCentral: ubicacionCentral ?? this.ubicacionCentral,
        polylines: polylines ?? this.polylines,
        markers: markers ?? this.markers,
      );
}
