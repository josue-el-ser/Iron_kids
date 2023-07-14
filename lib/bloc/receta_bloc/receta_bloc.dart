import 'dart:async';

import 'package:iron_kids/bloc/receta_bloc/receta_event.dart';
import 'package:iron_kids/bloc/receta_bloc/receta_state.dart';

class RecetasBloc {
  final RecetasState _recetasState = RecetasState();

  final StreamController<RecetasEvent> _input = StreamController();
  final StreamController<RecetasState> _output = StreamController();

  StreamSink<RecetasEvent> get sendEvent => _input.sink;
  Stream<RecetasState> get stream => _output.stream;

  RecetasBloc() {
    _input.stream.listen(_onEvent);
  }

  void _onEvent(RecetasEvent event) {
    if (event is OnUpdateFiltrosSeleccionadosEvent) {
      _recetasState.onUpdatingFiltrosSeleccionados(event.filtrosSeleccionados);
    }

    _output.add(_recetasState);
  }

  void dispose() {
    _input.close();
    _output.close();
  }
}
