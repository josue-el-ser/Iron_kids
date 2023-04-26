class RecetasState {
  List<String> _listFilter = ["hola", "adios"];

  RecetasState._();
  static final RecetasState _instance = RecetasState._();
  factory RecetasState() => _instance;

  List<String> get listFilter => _listFilter;

  void onFilterChange(value) {
    _listFilter = value;
  }
}