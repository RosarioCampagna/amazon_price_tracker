import 'dart:io';
import 'package:amazon_price_tracker/components/add_alert.dart';
import 'package:amazon_price_tracker/pages/prozis_product_list.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
        appBar: AppBar(
          title: const Text('Lista di prodotti'),
          centerTitle: true,
          actions: [
            if (!Platform.isAndroid)
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () => setState(() {}),
              )
          ],
        ),

        //listener per l'aggiunta di nuovi prodotti
        body: RefreshIndicator(onRefresh: () async => setState(() {}), child: const ProzisProductList()));
  }
}
