import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/actore_model.dart';
import 'package:peliculas/src/models/pelicula-model.dart';

class PeliculasProvider{
  String _apikey = '916355f9a2c6ba1892d27e7b84c53b35';
  String _url = 'api.themoviedb.org';
  String _lenguage = 'es-ES';

  int _popularesPages = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();

  final _popularStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>)get popularesSink => _popularStreamController.sink.add;

  Stream<List<Pelicula>>  get popularesStream => _popularStreamController.stream;



  void disposeStream(){
    _popularStreamController.close();
  }


  Future<List<Pelicula>> _procesarURL(Uri url)async{
    
    final resp = await http.get(url);  
    final decodedData = json.decode(resp.body);
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);    
    
    return peliculas.items;
  }



  Future<List<Pelicula>> getEnCines()async{

    final url = Uri.https(_url,'3/movie/now_playing',{
      'api_key' : _apikey,
      'language' : _lenguage
    });

  
    return await _procesarURL(url);

  }

  Future<List<Pelicula>> getPupolares()async{
    if(_cargando) return [];

    _cargando = true;
    _popularesPages++;

    final url = Uri.https(_url,'/3/movie/popular',{
      'api_key'  : _apikey,
      'language' : _lenguage,
      'page'     : _popularesPages.toString()
    });

    final resp = await _procesarURL(url);

    _populares.addAll(resp);
    popularesSink(_populares);

    _cargando = false;
    return resp;
  }



  Future<List<Actor>>getCast(String peliId)async{
  
    final url = Uri.https(_url,'3/movie/$peliId/credits',{
      'api_key'  : _apikey,
      'language' : _lenguage,
    });

    final resp = await http.get(url); 
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fomJsonList(decodedData['cast']);

    return cast.actores;

  }


  Future<List<Pelicula>> buscarPelicula(String query)async{

    final url = Uri.https(_url,'3/search/movie',{
      'api_key' : _apikey,
      'language' : _lenguage,
      'query' : query
    });

  
    return await _procesarURL(url);

  }



}

