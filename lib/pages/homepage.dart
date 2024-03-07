import 'package:amazon_price_tracker/components/add_alert.dart';
import 'package:amazon_price_tracker/pages/amazon_product_list.dart';
import 'package:amazon_price_tracker/pages/prozis_product_list.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Widget> pages = const [AmazonProductList(), ProzisProductList()];
  final PageController _controller = PageController(initialPage: 0);
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,

        //tasto per aggiungere nuovi prodotti
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return const AddAlertNorm();
                });
          },
          child: const Icon(Icons.add_rounded),
        ),

        //listener per l'aggiunta di nuovi prodotti
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    //pagina per impostare la page view sulla pagina di amazon
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              _controller.animateToPage(0,
                                  duration: const Duration(seconds: 1), curve: Curves.fastEaseInToSlowEaseOut);
                            },
                            child: Text(
                              'Amazon',
                              style: currentPage == 0
                                  ? TextStyle(
                                      color: Theme.of(context).colorScheme.primary.withGreen(160),
                                      fontWeight: FontWeight.w600)
                                  : null,
                            ))),

                    //tasto per impostare la page view sulla pagina di prozis
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              _controller.animateToPage(1,
                                  duration: const Duration(seconds: 1), curve: Curves.fastEaseInToSlowEaseOut);
                            },
                            child: Text(
                              'Prozis',
                              style: currentPage == 1
                                  ? TextStyle(
                                      color: Theme.of(context).colorScheme.primary.withGreen(160),
                                      fontWeight: FontWeight.w600)
                                  : null,
                            )))
                  ],
                ),
              ),

              //page view che contiene tutte le pagine utili all'applicazione
              Expanded(
                child: PageView.builder(
                    //quando cambia la pagina imposta l'indice alla nuova pagina
                    onPageChanged: (value) => setState(() {
                          currentPage = value;
                        }),
                    controller: _controller,
                    itemCount: pages.length,
                    itemBuilder: (context, index) {
                      return pages.elementAt(index);
                    }),
              )
            ],
          ),
        ));
  }
}
