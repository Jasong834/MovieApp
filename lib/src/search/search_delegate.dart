import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula-model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';


class DataSearch extends SearchDelegate{


  final peliculasProvider = new PeliculasProvider();


  @override
  List<Widget> buildActions(BuildContext context) {
    //acciones del appbar

    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono izquierda appbar
    return IconButton(
      icon: AnimatedIcon(
        icon : AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //crea los resultado a mostrar
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // sugerencias
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          
          final peliculas = snapshot.data;
          
          return ListView(
            children: peliculas.map((pelicula){
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: (){
                  close(context, null);
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList(),
          );
        }else{
          return Center(
            child:  CircularProgressIndicator(),
          );
        }
      },
    );
  }



}