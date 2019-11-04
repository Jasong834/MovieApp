import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';

import 'package:peliculas/widgets/card_swiper_widget.dart';
import 'package:peliculas/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  
  final peliculasProvider = new PeliculasProvider();
  

  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPupolares();
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.indigo,
        title: Text('Peliculas'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showSearch(context: context,delegate: DataSearch());
            },
          )
        ],
      ),  
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo,Colors.blue],
            stops: [0.4,0.5],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swipTarjetas(),
            _footer(context),
          ],
        ),
      ),    
    );
  }

  Widget _swipTarjetas() {

    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return  CardSwiper(peliculas: snapshot.data);    
        } else {
          return Container(
            height: 400.0,
            child : Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              )
            )
          );
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Populares',style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            )),
          ),
          SizedBox(height: 15.0),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPupolares,
                ); 
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  )
                );
              }
            },
          ),
        ],
      ),
    );
    
  }
}