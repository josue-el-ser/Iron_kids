import 'package:iron_kids/screens/recetas/recetas_screen.dart';

abstract class RecetasEvent {}

class OnUpdateFiltrosSeleccionadosEvent extends RecetasEvent {
  final List<Filtro> filtrosSeleccionados;

  OnUpdateFiltrosSeleccionadosEvent(this.filtrosSeleccionados);
}

class OnFetchRecetasEvent extends RecetasEvent {}
