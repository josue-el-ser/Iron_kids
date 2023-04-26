import 'dart:async';

import 'package:iron_kids/bloc/receta_bloc/receta_event.dart';
import 'package:iron_kids/bloc/receta_bloc/receta_state.dart';

class RecetasBloc {
  final RecetasState _recetasState = RecetasState();

  final StreamController<RecetasEvent> _input = StreamController();
  final StreamController<List<String>> _output = StreamController();

  StreamSink<RecetasEvent> get sendEvent => _input.sink;
  Stream<List<String>> get listFilterStream => _output.stream;

  UserBloc() {
    _input.stream.listen(_onEvent);
  }

  void _onEvent(RecetasEvent event) {
    if (event is OnFilterChangeEvent) {
      _recetasState.onFilterChange(event.value);
    }

    _output.add(_recetasState.listFilter);
  }

  void dispose() {
    _input.close();
    _output.close();
  }
}