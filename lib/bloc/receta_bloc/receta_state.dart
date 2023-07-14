import 'package:iron_kids/models/recetas.dart';
import 'package:iron_kids/screens/recetas/recetas_screen.dart';

class RecetasState {
  List<Filtro> _filtrosSeleccionados = [
    Filtro(categoria: "ingredientes", valor: "papa"),
    Filtro(categoria: "tiempo", valor: "12 min"),
    Filtro(categoria: "edad", valor: "12 a 23 meses"),
  ];

  List<Receta> _recetas = [];

  RecetasState._();
  static final RecetasState _instance = RecetasState._();
  factory RecetasState() => _instance;

  List<Filtro> get filtrosSeleccionados => _filtrosSeleccionados;
  List<Receta> get recetas => _recetas;

  void onUpdatingFiltrosSeleccionados(List<Filtro> filtroSeleccionados) {
    _filtrosSeleccionados = filtrosSeleccionados;
  }

  void onUpdatingRecetas(List<Receta> grecetas) {
    _recetas = recetas;
  }
}
