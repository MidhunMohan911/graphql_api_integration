import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_sample/Presentation/Screens/home_page.dart';

HttpLink link =
    HttpLink('https://rickandmortyapi.com/graphql'); // url for graphql
ValueNotifier<GraphQLClient> qlClient = ValueNotifier(GraphQLClient(
    // create client using linl
    link: link,
    cache: GraphQLCache(
      store:
          HiveStore(), // this is to store cache data,for using hive store you have to initialize hive on main page
    )));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();

  // hive is already in graphql flutter plugin no need to add hive
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: qlClient,
      child: MaterialApp(
        title: 'Graphql Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: const HomePage(),
      ),
    );
  }
}
