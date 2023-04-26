abstract class RecetasEvent {}

class OnFilterChangeEvent extends RecetasEvent {
  final List<String> value;

  OnFilterChangeEvent(this.value);
}

class GetRecetasEvent extends RecetasEvent {}