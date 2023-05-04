import 'package:iron_kids/screens/recetas/recetas_screen.dart';

abstract class RecetasEvent {}

class OnFilterChangeEvent extends RecetasEvent {
  final List<Filtro> value;

  OnFilterChangeEvent(this.value);
}

class GetRecetasEvent extends RecetasEvent {}