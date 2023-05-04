import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iron_kids/bloc/receta_bloc/receta_bloc.dart';
import 'package:iron_kids/bloc/receta_bloc/receta_event.dart';
import 'package:iron_kids/main.dart';
import 'package:iron_kids/screens/recetas/recetas_details.dart';
import 'package:iron_kids/styles/app_theme.dart';
import 'package:iron_kids/models/recetas.dart';
import 'package:iron_kids/styles/widgets.dart';
import 'package:iron_kids/styles/widgets/filter_chips.dart';

TextEditingController controllerBuscarReceta = TextEditingController();

bool _filterChipValue = true;

RecetasBloc _recetasBloc = RecetasBloc();

List<Filtro> _listFilter  = [];
List<String> listaRegiones = ["Costa", "Sierra", "Selva"];
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
    _recetasBloc.sendEvent.add(GetRecetasEvent());
  }
  
  @override
  void dispose() {
    _recetasBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SafeArea(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
          child: Drawer(
            width: screenW * 3/4,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing5,
                vertical: AppTheme.spacing8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Filtrar por", style: textTheme.headlineLarge,),
                      ButtonIcon(icon: Icons.close, onPressed: (){
                        Navigator.pop(context);
                      },)
                    ],
                  ),
                  AppTheme.spacingWidget6,
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: AppTheme.borderRadiusS,
                      color: AppTheme.gray200
                    ),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.spacing2,
                      horizontal: AppTheme.spacing4
                    ),
                    child: Text("Región", style: textTheme.headlineSmall,)
                  ),
                  AppTheme.spacingWidget4,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: listaRegiones.map((String region){
                      return MyFilterChip(
                        selected: listaRegionesSelected.contains(region),
                        onSelected: (value) {
                          setState(() {
                            if (listaRegionesSelected.contains(region)) {
                              listaRegionesSelected.removeWhere((element) =>
                                element == region
                              );
                              _listFilter.removeWhere((element) => 
                                element.valor == region  
                              );
                            }else{
                              listaRegionesSelected.add(region);
                              _listFilter.add(Filtro(categoria: "region", valor: region));
                            }
                            _recetasBloc..sendEvent.add(OnFilterChangeEvent(_listFilter));
                          });
                        },
                        label: region
                      );
                    }).toList()
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: StreamBuilder<List<Filtro>>(
          stream: _recetasBloc.listFilterStream,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              _listFilter = snapshot.data!;
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
                        Text('Recetas',
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
                                )
                              ),
    
                              //Spacing 8px
                              AppTheme.spacingWidget3,
                              
                              //Boton
                              ButtonPrimary(onPressed: (){
                                /* _listFilter.add(Filtro(categoria: "liked", valor: true));
                                _recetasBloc..sendEvent.add(OnFilterChangeEvent(_listFilter)); */
    
                                Scaffold.of(context).openEndDrawer();
                              },'Filtrar', size: 2,)
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
                        for (Filtro filtro in _listFilter)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: AppTheme.spacing6,
                              top: AppTheme.spacing4,
                            ),
                            child: MyFilterChip(
                              selected: _filterChipValue,
                              onSelected: (value) {
                                print("Funcionando directo sin clase abstraida");
                                _listFilter.removeWhere((element) => 
                                  element.valor == filtro.valor
                                );
                                _recetasBloc..sendEvent.add(OnFilterChangeEvent(_listFilter));
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
                                  onPressed: (){
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (BuildContext context) => RecetasDetailsScreen(receta: receta)
                                      )
                                    );
                                  },
                                  linkImg: receta.imagen,
                                  titulo: receta.titulo,
                                  tiempo: receta.tiempo,
                                  likes: receta.likes,
                                  edad: receta.edad,
                                  liked: receta.titulo.length < 18 ? false : true,
                                ) 
                            ]
                          );
                        }else if(snapshot.hasError){
                          return const Text('Error al cargar las recetas');
                        }  
                        return const CircularProgressIndicator();
                      }
                    ),
                  )
                ]
              );
            }else{
              return const Center(child: CircularProgressIndicator());
            }
          }
        ),
      ),
    );
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

  int get getNumeId => 0;
  String get valorString => valor.toString();
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