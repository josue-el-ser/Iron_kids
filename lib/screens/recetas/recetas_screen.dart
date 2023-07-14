import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iron_kids/bloc/receta_bloc/receta_bloc.dart';
import 'package:iron_kids/bloc/receta_bloc/receta_event.dart';
import 'package:iron_kids/bloc/receta_bloc/receta_state.dart';
import 'package:iron_kids/main.dart';
import 'package:iron_kids/screens/recetas/recetas_details.dart';
import 'package:iron_kids/styles/app_theme.dart';
import 'package:iron_kids/models/recetas.dart';
import 'package:iron_kids/styles/widgets.dart';
import 'package:iron_kids/styles/widgets/filter_chips.dart';

TextEditingController controllerBuscarReceta = TextEditingController();

bool _filterChipValue = true;

RecetasBloc _recetasBloc = RecetasBloc();
RecetasState recetasStateGlobal = RecetasState();

List<Filtro> _listFilter = [];
List<Filtro> listaRegiones = [
  Filtro(categoria: "region", valor: "Costa"),
  Filtro(categoria: "region", valor: "Sierra"),
  Filtro(categoria: "region", valor: "Selva"),
];

List<String> listaRegionesSelected = [];

class RecetasScreen extends StatefulWidget {
  const RecetasScreen({Key? key}) : super(key: key);

  @override
  State<RecetasScreen> createState() => _RecetasScreenState();
}

class _RecetasScreenState extends State<RecetasScreen> {
  @override
  void initState() {
    super.initState();
    _recetasBloc.sendEvent.add(OnFetchRecetasEvent());
  }

  @override
  void dispose() {
    _recetasBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RecetasState>(
        stream: _recetasBloc.stream,
        initialData: recetasStateGlobal,
        builder: (context, snapshot) {
          recetasStateGlobal = snapshot.data!;
          return Scaffold(
            endDrawer: SafeArea(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: Drawer(
                  width: screenW * 3 / 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing5,
                        vertical: AppTheme.spacing8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Titulo de Modal con boton cerrar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Filtrar por",
                              style: textTheme.headlineLarge,
                            ),
                            ButtonIcon(
                              icon: Icons.close,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                        AppTheme.spacingWidget6,

                        // Subtitulo REGION
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: AppTheme.borderRadiusS,
                                color: AppTheme.gray200),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: AppTheme.spacing2,
                                horizontal: AppTheme.spacing4),
                            child: Text(
                              "Región",
                              style: textTheme.headlineSmall,
                            )),
                        AppTheme.spacingWidget4,

                        // Filtros REGION
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: listaRegiones.map((Filtro filtroRegion) {
                              return MyFilterChip(
                                  selected: recetasStateGlobal
                                      .filtrosSeleccionados
                                      .contains(filtroRegion),
                                  onSelected: (value) {
                                    if (recetasStateGlobal.filtrosSeleccionados
                                        .contains(filtroRegion)) {
                                      recetasStateGlobal.filtrosSeleccionados
                                          .removeWhere((element) =>
                                              element == filtroRegion);
                                    } else {
                                      recetasStateGlobal.filtrosSeleccionados
                                          .add(filtroRegion);
                                      _listFilter.add(filtroRegion);
                                    }
                                    _recetasBloc.sendEvent.add(
                                        OnUpdateFiltrosSeleccionadosEvent(
                                            recetasStateGlobal
                                                .filtrosSeleccionados));
                                  },
                                  label: filtroRegion.getValorString);
                            }).toList()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Builder(builder: (context) {
                if (snapshot.hasData) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        //Spacing 20px
                        AppTheme.spacingWidget10,

                        //Titulo
                        ScreenApp(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recetas',
                                style: textTheme.headlineLarge,
                              ),

                              //Spacing 20px
                              AppTheme.spacingWidget6,

                              // Buscador de recetas
                              SizedBox(
                                // width: screenW,

                                child: Row(
                                  children: [
                                    //Buscador
                                    Expanded(
                                        flex: 6,
                                        child: InputField(
                                          controller: controllerBuscarReceta,
                                          placeholder: "Buscar receta",
                                          iconLeft: Icons.search_rounded,
                                        )),

                                    //Spacing 8px
                                    AppTheme.spacingWidget3,

                                    //Boton
                                    ButtonPrimary(
                                      onPressed: () {
                                        /* _listFilter.add(Filtro(categoria: "liked", valor: true));
                                    _recetasBloc..sendEvent.add(OnFilterChangeEvent(_listFilter)); */

                                        Scaffold.of(context).openEndDrawer();
                                      },
                                      'Filtrar',
                                      size: 2,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        //Botones filtros
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: <Widget>[
                              for (Filtro filtro
                                  in recetasStateGlobal.filtrosSeleccionados)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: AppTheme.spacing6,
                                    top: AppTheme.spacing4,
                                  ),
                                  child: MyFilterChip(
                                    selected: _filterChipValue,
                                    onSelected: (value) {
                                      recetasStateGlobal.filtrosSeleccionados
                                          .removeWhere(
                                              (element) => element == filtro);

                                      _recetasBloc
                                        ..sendEvent.add(
                                            OnUpdateFiltrosSeleccionadosEvent(
                                                recetasStateGlobal
                                                    .filtrosSeleccionados));
                                    },
                                    label: filtro.toString(),
                                    closeMark: true,
                                  ),
                                )
                            ],
                          ),
                        ),

                        AppTheme.spacingWidget6,

                        //Recetas
                        Center(
                          child: FutureBuilder<List<Receta>>(
                              future: RecetasService.obtenerRecetas(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<Receta>? recetas = snapshot.data;

                                  // Codigo para mostrar solo las recetas "buscadas" por Google Assistant
                                  /* if(_listFiltros
                              .isEmpty){
                                recetas = snapshot.data;
                              }else{
                                for (final receta in snapshot.data!){
                                  if(receta.id == 1 || receta.id == 3) recetas.add(receta);
                                }
                              } */

                                  return Wrap(
                                      spacing: AppTheme.spacing6,
                                      runSpacing: AppTheme.spacing6,
                                      children: <Widget>[
                                        for (final receta in recetas!)
                                          CardRecetaLarge(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          RecetasDetailsScreen(
                                                              receta: receta)));
                                            },
                                            linkImg: receta.imagen,
                                            titulo: receta.titulo,
                                            tiempo: receta.tiempo,
                                            likes: receta.likes,
                                            edad: receta.edad,
                                            liked: receta.titulo.length < 18
                                                ? false
                                                : true,
                                          )
                                      ]);
                                } else if (snapshot.hasError) {
                                  return const Text(
                                      'Error al cargar las recetas');
                                }
                                return const CircularProgressIndicator();
                              }),
                        )
                      ]);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
            ),
          );
        });
  }
}

/* return Navigator(
      key: navigatorKeys[indexRecetasScreen],
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (context) {
      )
    );
  } */

// Estructura

/* 
class BotonsFilter extends StatelessWidget {
  const BotonsFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: ListFilter(list: _listFiltros, onSelected:(value) {
        print("Ga");
      },),
    );
  }
}

// Widget locals

// lista de filtros
class ListFilter extends StatefulWidget {
  final List<Filtro> list;
  final ValueChanged<bool>? onSelected;
  const ListFilter({super.key, this.onSelected, required this.list});

  @override
  State<ListFilter> createState() => _ListFilterState();
}

class _ListFilterState extends State<ListFilter> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: <Widget>[
          for (final filtro in widget.list)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing4, horizontal: AppTheme.spacing6),
              child: MyFilterChip(selected: _filterChipValue, onSelected: widget.onSelected, label: filtro.valor, closeMark: true,),
            )
        ],
      ),
    );
  }
}

final List<Filtro> _listFiltros
 = [
  //Filtro(id: 0, color: AppTheme.primary50, text: 'Papa amarilla'),
]; */

class Filtro {
  final int id;
  final String categoria;
  final dynamic valor;

  Filtro({this.id = 0, required this.categoria, required this.valor});

  int get getId => id;
  String get getValorString => valor.toString();

  @override
  String toString() {
    switch (categoria) {
      case "ingredientes":
        return valor.toString();
      case "tiempo":
        return valor.toString();
      case "edad":
        return valor.toString();
      case "liked":
        return "Likeadas";
      case "region":
        return valor.toString();
      default:
        return "";
    }
  }
}
