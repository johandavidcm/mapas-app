part of 'widgets.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state) {
        if (state.seleccionManual) {
          return Container();
        } else {
          return FadeInDown(
              duration: Duration(milliseconds: 300),
              child: buildSearcchBar(context));
        }
      },
    );
  }

  Widget buildSearcchBar(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        width: width,
        child: GestureDetector(
          onTap: () async {
            final proximidad = BlocProvider.of<MiUbicacionBloc>(context);
            final historial =
                BlocProvider.of<BusquedaBloc>(context).state.historial;
            final resultado = await showSearch(
                context: context,
                delegate:
                    SearchDestination(proximidad.state.ubicacion, historial));
            this.retornoBusqueda(context, resultado);
          },
          child: Container(
            width: double.infinity,
            height: 50.0,
            child: Center(
                child: Text(
              '¿Donde quieres ir?',
              style: TextStyle(color: Colors.black87),
            )),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 5))
                ]),
          ),
        ),
      ),
    );
  }

  Future retornoBusqueda(BuildContext context, SearchResult result) async {
    if (result.cancelo) return;
    if (result.manual) {
      BlocProvider.of<BusquedaBloc>(context).add(OnActivarMarcadorManual());
      return;
    }
    calculandoAlerta(context);
    // Calcular la ruta en base al valor recibido
    final trafficService = TrafficService();
    final mapaBlock = BlocProvider.of<MapaBloc>(context);
    final inicio = BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
    final destino = result.posicion;
    final drivingResponse =
        await trafficService.getCoordsInicioYFin(inicio, destino);
    final geometry = drivingResponse.routes[0].geometry;
    final duracion = drivingResponse.routes[0].duration;
    final distancia = drivingResponse.routes[0].distance;
    final points = Poly.decodePolyline(geometry, accuracyExponent: 6);
    final List<LatLng> rutaCoordenadas =
        points.map((point) => LatLng(point[0], point[1])).toList();

    mapaBlock.add(OnCrearRutaInicioDestino(
        rutaCoordenadas: rutaCoordenadas,
        distancia: distancia,
        duracion: duracion));

    Navigator.of(context).pop();
    // Agregar al historial
    final busquedaBloc = BlocProvider.of<BusquedaBloc>(context);
    busquedaBloc.add(OnAgregarHistorial(result));
  }
}
