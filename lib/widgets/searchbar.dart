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
            final resultado = await showSearch(
                context: context,
                delegate: SearchDestination(proximidad.state.ubicacion));
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

  void retornoBusqueda(BuildContext context, SearchResult result) {
    if (result.cancelo) return;
    if (result.manual) {
      BlocProvider.of<BusquedaBloc>(context).add(OnActivarMarcadorManual());
      return;
    }
  }
}
