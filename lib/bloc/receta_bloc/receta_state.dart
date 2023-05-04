import 'package:iron_kids/screens/recetas/recetas_screen.dart';

class RecetasState {
  List<Filtro> _listFilter = [
    Filtro(categoria: "ingredientes", valor: "papa"),
    Filtro(categoria: "tiempo", valor: "12 min"),
    Filtro(categoria: "edad", valor: "12 a 23 meses"),
  ];

  RecetasState._();
  static final RecetasState _instance = RecetasState._();
  factory RecetasState() => _instance;

  List<Filtro> get listFilter => _listFilter;

  void onFilterChange(value) {
    _listFilter = value;
  }
}