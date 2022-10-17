import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> characters = [];
  // bool _loading = false;

  /*
  https://rickandmortyapi.com/graphql is the demo api

  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        title: const Text('GraphQL Sample'),
        centerTitle: true,
      ),
      body:
          //  _loading
          //     ? const CircularProgressIndicator()
          //     : characters.isEmpty
          //         ? Center(
          //             child: ElevatedButton(
          //               onPressed: () {
          //                 fetchData();
          //               },
          //               child: const Text('Fetch Data'),
          //             ),
          //           ) //button to load which users can see
          //         :
          Padding(
        padding: const EdgeInsets.all(8),
        child: Query(
          
          options: QueryOptions(
           
            document: gql("""query {
          characters() {
          results {
            name 
            image
          }
          }
        }""")),
          builder: (result, {fetchMore, refetch}) {
            if (result.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // fetchMore(FetchMoreOptions(updateQuery: updateQuery));

            characters = result.data!['characters']['results'];

            return RefreshIndicator(
              onRefresh: () async {
                await refetch!();
                return;
              },
              child: ListView.builder(
                itemCount: characters.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Image(
                        image: NetworkImage(
                          characters[index]['image'],
                        ),
                      ),
                      title: Text(
                        characters[index]['name'],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ), // listview.builder to show
      ),
    );
  }
}

//   Future fetchData() async {
//     setState(() {
//       _loading = true;
//     });

//     HttpLink link =
//         HttpLink('https://rickandmortyapi.com/graphql'); // url for graphql
//     GraphQLClient qlClient = GraphQLClient(
//         // create client using linl
//         link: link,
//         cache: GraphQLCache(
//           store:
//               HiveStore(), // this is to store cache data,for using hive store you have to initialize hive on main page
//         ));
//     // here you created qlClient
//     // now graphql has 2 type of request
//     // 1 - Query - to get data
//     // 2 - mutation - to add data to server
//     // here we are doing 1st one Query
//     // response you will get queryResult
//     QueryResult queryResult = await qlClient.query(
//       QueryOptions(
//         document: gql(
//           """query {
//           characters(page: 2, filter: { name: "rick" }) {
//           results {
//             name 
//             image
//           }
//           }
//         }""",
//         ), // this is query schema
//         // characters -> this is called operation ,
//         // page and filter are variables , these are parameters you pass to filter data
//         // image,name -> In graphql you only need to call the field you want eg: if you want image you pass image only
//       ),
//     );
// // queryResult.data // contains data
// // queryResult.exception // will give exception
// // queryResult.hasException // you can check if you have any exception
// // queryResult.context.entry<HttpLinkResponseContext>()?.statusCode; // to get status code of response
//     setState(() {
//       characters = queryResult.data!['characters'][
//           'results']; // queryResults.data asign it in characters list , now use this data to display
//       _loading = false;
//     });
//   }
// }
