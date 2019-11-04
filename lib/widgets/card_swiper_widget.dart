import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula-model.dart';


class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;

  CardSwiper({@required this.peliculas});
 
  @override
  Widget build(BuildContext context) {
    
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      
      padding: EdgeInsets.only(top: 5),
        child: Swiper(
          layout: SwiperLayout.STACK,   
          itemWidth: _screenSize.width * 0.7,
          itemHeight: _screenSize.height *0.53,
          itemBuilder: (BuildContext context,int index){

            peliculas[index].uniqueId = '${peliculas[index].id}-tajeta';

            return Hero(
              tag: peliculas[index].uniqueId,
              child: ClipRRect( 
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  onTap: ()=>Navigator.pushNamed(context, 'detalle',arguments : peliculas[index]),
                  child: FadeInImage(
                    image: NetworkImage(peliculas[index].getPosterImg()),
                    placeholder: AssetImage('assets/no-image.jpg'),
                    fit: BoxFit.cover,
                  ),
                )
              ),
            );
          },
        itemCount: peliculas.length,
        viewportFraction: 0.8,
        scale: 0.9,
        autoplay: true,
      )
    );
  }
}
