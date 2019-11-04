import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula-model.dart';
 
 
 
 class MovieHorizontal extends StatelessWidget {
   
  final List<Pelicula> peliculas;
  final Function siguientePagina;

    
  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3
  );
  MovieHorizontal({@required this.peliculas,@required this.siguientePagina});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener((){

      if(_pageController.position.pixels >= _pageController.position.maxScrollExtent -200){
        siguientePagina();
      } 
    });


    return Container(
      height: _screenSize.height *0.25,
      child: PageView.builder(          
        pageSnapping: false,
        controller: _pageController,
        itemCount: peliculas.length,
        itemBuilder: (context,i) => _tarjeta(context,peliculas[i])
      ),
    );
  }

  Widget _tarjeta(BuildContext context,Pelicula pelicula){

    pelicula.uniqueId = '${pelicula.id}-poster';

    final tarjeta = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius:  BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()), 
                placeholder: AssetImage('assets/no-image.jpg'),
                fit: BoxFit.cover,
                height: 120.0,
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white,
            ),
          )
        ],
      ),
    );

    return GestureDetector(
      child: tarjeta,
      onTap: (){
        Navigator.pushNamed(context, 'detalle',arguments: pelicula);
      },
    );

  }


 }