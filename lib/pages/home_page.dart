import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

HttpLink link = HttpLink("https://countries.trevorblades.com/graphql");

String countryDataGQL = """
query Query (\$country: ID!){
    country(code: \$country){
        name
        phone
        capital
        code
        currency
        emoji
        emojiU
        languages{
            code
            name
            native
            rtl
        }
        name
        native
    }
}
""";

class _HomePageState extends State<HomePage> {
  final TextEditingController countriesController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    countriesController.dispose();
  }

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: link,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );

  bool showDetails = false;

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Countries'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: countriesController,
                  onEditingComplete: () {
                    setState(() {
                      showDetails = true;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Enter your country (eg: BD)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              showDetails
                  ? Query(
                      options: QueryOptions(
                        fetchPolicy: FetchPolicy.noCache,
                        document: gql(countryDataGQL),
                        variables: {
                          'country':
                              '${countriesController.text.toUpperCase().toString()}'
                        },
                      ),
                      builder: ((result, {fetchMore, refetch}) {
                        if (result.hasException) {
                          print(result.exception.toString());
                          return Text('Error');
                        }
                        if (result.isLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.green,
                              strokeWidth: 4,
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('Name: '),
                                  Text(
                                    result.data?['country']?['name']
                                            .toString() ??
                                        "NULL",
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Phone: '),
                                  Text(
                                    result.data?['country']?['phone']
                                            .toString() ??
                                        "NULL",
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Capital: '),
                                  Text(
                                    result.data?['country']?['capital']
                                            .toString() ??
                                        "NULL",
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Code: '),
                                  Text(
                                    result.data?['country']?['code']
                                            .toString() ??
                                        "NULL",
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Currency: '),
                                  Text(
                                    result.data?['country']?['currency']
                                            .toString() ??
                                        "NULL",
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Emoji: '),
                                  Text(
                                    result.data?['country']?['emoji']
                                            .toString() ??
                                        "NULL",
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('EmojiU: '),
                                  Text(
                                    result.data?['country']?['emojiu']
                                            .toString() ??
                                        "NULL",
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Language Code: '),
                                  Text(
                                    result.data?['country']?['languages']?[0]
                                                ?['code']
                                            .toString() ??
                                        "NULL",
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Language Native: '),
                                  Text(
                                    result.data?['country']?['languages']?[0]
                                                ?['native']
                                            .toString() ??
                                        "NULL",
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Native: '),
                                  Text(
                                    result.data?['country']?['native']
                                            .toString() ??
                                        "NULL",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    )
                  : Container(
                      child: Text("Waiting for your input"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}



/*//
  Query(
          options: QueryOptions(
            fetchPolicy: FetchPolicy.noCache,
            document: gql(countryDataGQL),
            // pollInterval: const Duration(seconds: 10),
          ),
          builder: (QueryResult result,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
            if (result.hasException) {
              print(result.exception.toString());
              return Text('Error');
            }
            if (result.isLoading) {
              return const Text('Loading');
            }
            var details = result.data;
            print(details);
            return HomePage();
          },
        ),

        */