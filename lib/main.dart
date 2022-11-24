import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//add your key
const String request =
    "https://api.hgbrasil.com/finance?format=json&key=YOUR_KEY";
void main() {
  runApp(
    MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber),
          ),
          hintStyle: TextStyle(color: Colors.amber),
        ),
      ),
    ),
  );
}

Future<Map> getData() async {
  Uri url = Uri.parse(request);
  http.Response response = await http.get(url);

  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

   late double dolar;
   late double euro; 
   final  realController = TextEditingController();
   final euroController = TextEditingController();
   final dolarController = TextEditingController();

   void _clearAll(){
    realController.text = '';
    euroController.text = '';
    dolarController.text = '';
   }
   void _realChange(String text){
      if(text.isNotEmpty){
        double real  = double.parse(realController.text);
        dolarController.text = (real/dolar).toStringAsFixed(2);
         euroController.text = (real/euro).toStringAsFixed(2);
      }else{
        _clearAll();
      }

   }
   void _dolarChange(String text){
    
    if(text.isNotEmpty){
      double  dolar = double.parse(dolarController.text);
      realController.text = (dolar *this.dolar).toStringAsFixed(2);
      euroController.text =(dolar*this.dolar/ euro).toStringAsFixed(2);

    }else{
      _clearAll();
    }

   }
   void _euroChange(String text){
    if(text.isNotEmpty){
      double euro  = double.parse(euroController.text);
    realController.text = (euro *this.euro).toStringAsFixed(2);
    dolarController.text =(euro *this.euro/dolar).toStringAsFixed(2);
    }else{
      _clearAll();
    }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('\$ Conversor \$'),
        backgroundColor: Color.fromRGBO(255, 193, 7, 1),
        centerTitle: true,
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  'Carregando aos dados!',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Erro!',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar =  snapshot.data!['results']['currencies']['USD']['buy'];
                euro =  snapshot.data!['results']['currencies']['EUR']['buy'];

                return SingleChildScrollView(


                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.monetization_on,
                        size: 150,
                        color: Colors.amber,
                      ),
                      buildTextField(label: 'Reais', prefixo: 'R\$', controller: realController, change: _realChange),       
                      Divider(),
                      buildTextField(label: 'Dólares', prefixo: 'US\$', controller: dolarController, change: _dolarChange),
                      Divider(),
                      buildTextField(label: 'Euro', prefixo: '\$', controller: euroController, change: _euroChange),
                    ],
                  ),
                );
              }
          }
        },
        future: getData(),
      ),
    );
  }
}

Widget buildTextField({required String label, required String prefixo, required TextEditingController controller, required Function(String x) change}) {
  return TextField(
    controller:  controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefix: Text(prefixo),
    
    ),
    keyboardType: TextInputType.number,
    onChanged: change,
    style: TextStyle(color: Colors.amber, fontSize: 25),

  );
}
