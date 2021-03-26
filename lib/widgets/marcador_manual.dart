part of 'widgets.dart';

class MarcadorManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state) {
        if (state.seleccionManual) {
          return _BuildMarcadorManual();
        } else {
          return Container();
        }
      },
    );
  }
}

class _BuildMarcadorManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        // Boton regresar
        Positioned(
            top: 70,
            left: 20,
            child: FadeInLeft(
              duration: Duration(milliseconds: 150),
              child: CircleAvatar(
                maxRadius: 25,
                backgroundColor: Colors.white,
                child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      BlocProvider.of<BusquedaBloc>(context)
                          .add(OnDesactivarMarcadorManual());
                    }),
              ),
            )),
        Center(
          child: Transform.translate(
            offset: Offset(0, -10),
            child: BounceInDown(
              child: Icon(
                Icons.location_on,
                size: 50.0,
              ),
            ),
          ),
        ),
        // Boton de confirmar destino
        Positioned(
            bottom: 70.0,
            left: 40.0,
            child: FadeIn(
              child: MaterialButton(
                minWidth: width - 120,
                child: Text(
                  'Confirmar destino',
                  style: TextStyle(color: Colors.white),
                ),
                shape: StadiumBorder(),
                elevation: 0,
                color: Colors.black,
                splashColor: Colors.transparent,
                onPressed: () {
                  this.calcularDestino(context);
                },
              ),
            ))
      ],
    );
  }

  void calcularDestino(BuildContext context) async {
    calculandoAlerta(context);
    final trafficService = TrafficService();
    final mapaBloc = BlocProvider.of<MapaBloc>(context);
    final inicio = BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
    final destino = mapaBloc.state.ubicacionCentral;

    //Obtener informacion del destino
    trafficService.getCoordenadasQueryInfo(destino);

    final trafficResponse =
        await trafficService.getCoordsInicioYFin(inicio, destino);

    final geometry = trafficResponse.routes[0].geometry;
    final duracion = trafficResponse.routes[0].duration;
    final distancia = trafficResponse.routes[0].distance;
    // Decodificar los puntos del geometry
    final points = Poly.decodePolyline(geometry, accuracyExponent: 6);
    final List<LatLng> rutaCoords =
        points.map((point) => LatLng(point[0], point[1])).toList();
    mapaBloc.add(OnCrearRutaInicioDestino(
        rutaCoordenadas: rutaCoords, distancia: distancia, duracion: duracion));
    Navigator.of(context).pop();
    BlocProvider.of<BusquedaBloc>(context).add(OnDesactivarMarcadorManual());
  }
}
