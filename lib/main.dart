import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Simple Interest Calculator App',
    home: SIForm(),
    theme: ThemeData(
        primaryColor: Colors.indigo,
        accentColor: Colors.indigoAccent,
        brightness: Brightness.dark),
  ));
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
  }
}

class _SIFormState extends State<SIForm> {
  var _currencies = ['Dollars', 'Euros', 'Pounds'];
  final _minimumPadding = 5.0;

  //Variabili per la logica
  var _currentItemSelected =
      ''; //deve essere uguale ad uno dei tipi del menù a tendina

  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();

  var displayResult = '';

  //Variabili per la validazione del Form
  var _formKey =
      GlobalKey<FormState>(); // -> agisce come chiave per il nostro form

  @override
  void initState() {
    //funzione predefinita da usare per l'inizializzazione dello stato di un widget -> chiamata quando il widget viene creato
    super.initState();
    _currentItemSelected = _currencies[0];
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      //   resizeToAvoidBottomPadding: false, //per evitare overflow dello schermo nella parte inferiore
      appBar: AppBar(
        title: Text('Simple Interest Calculator'),
      ),
      body: Form(
//        margin: EdgeInsets.all(_minimumPadding * 2), ---> non contenuto in Form -> prima c'era un container
          //child: Column(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(_minimumPadding * 2),
            child: ListView(
              //--->    se si restringe lo schermo (ad es. tastiera o schermo troppo piccolo) mi permette di scorrere la facciata dell'app
              children: <Widget>[
                getImageAsset(),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    //child: TextField(
                    child: TextFormField(
                      //Per la validazione dell'input
                      keyboardType: TextInputType.number,
                      style: textStyle,
                      controller: principalController,
                      validator: (String value) {
                        //codice per la validazione dell'input
                        if (value.isEmpty) {
                          return 'Please enter principal amount';
                        }
                      },
                      //collego il campo di input alla variabile controller per farne I/O
                      decoration: InputDecoration(
                          labelText: 'Principal',
                          hintText: 'Enter Principal e.g. 12000',
                          labelStyle: textStyle,
                          errorStyle: TextStyle(
                            color: Colors.yellowAccent,
                            fontSize: 15.0
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                    )),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: textStyle,
                    controller: roiController,
                    validator:  (String value) {
                      //codice per la validazione dell'input
                      if (value.isEmpty) {
                        return 'Please enter rate of interest';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Rate of Interest',
                        hintText: 'In percent',
                        labelStyle: textStyle,
                        errorStyle: TextStyle(
                            color: Colors.yellowAccent,
                            fontSize: 15.0
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            //Expanded utilizzato perchè altrimenti non ci sta tutto nello schermo e l'app crasha
                            child: TextFormField(
                          keyboardType: TextInputType.number,
                          style: textStyle,
                          controller: termController,
                          validator: (String value){
                            if(value.isEmpty){
                              return 'Please enter the time';
                            }
                          },
                          decoration: InputDecoration(
                              labelText: 'Term',
                              hintText: 'Time in years',
                              labelStyle: textStyle,
                              errorStyle: TextStyle(
                                color: Colors.yellowAccent
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                        )),
                        Container(
                          width: _minimumPadding * 5,
                        ),
                        Expanded(
                            child: DropdownButton<String>(
                          items: _currencies.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          value: _currentItemSelected,
                          onChanged: (String newValueSelected) {
                            //eseguo codice quando l'utente effettua la selezione dal menù a tendina
                            _onDropDownItemSelected(newValueSelected);
                          },
                        ))
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        bottom: _minimumPadding, top: _minimumPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: RaisedButton(
                          child: Text(
                            'Calculate',
                            textScaleFactor: 1.5,
                          ),
                          color: Theme.of(context).accentColor,
                          textColor: Theme.of(context).primaryColorDark,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              //per collegarmi al form (chiave unica per questo form) -> se i campi sono validati (vedi campi) -> esegue codice
                              //eseguo la logica per effettuare il calcolo alla pressione del tasto
                              setState(() {
                                this.displayResult = _calculateTotalReturns();
                              });
                            }
                          },
                        )),
                        Expanded(
                            child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Reset',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              _reset();
                            });
                          },
                        ))
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.all(_minimumPadding * 2),
                  child: Text(
                    displayResult,
                    style: textStyle,
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/interest.png');
    Image image = Image(
      image: assetImage,
      width: 125.0,
      height: 125.0,
    );

    return Container(
      child: image,
      margin: EdgeInsets.all(_minimumPadding * 10.0),
    );
  }

  void _onDropDownItemSelected(String newValueSelected) {
    //setta il valore scelto nel men a tendina
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  String _calculateTotalReturns() {
    double principal = double.parse(
        principalController.text); //leggo il testo convertendolo in double
    double roi = double.parse(
        roiController.text); //leggo il testo convertendolo in double
    double term = double.parse(
        termController.text); //leggo il testo convertendolo in double

    double totalAmountPayable = principal + (principal * roi * term) / 100;

    String result =
        'After $term years, your investment will be worth $totalAmountPayable $_currentItemSelected';

    return result;
  }

  void _reset() {
    //resetto i campi di tutti i controller

    principalController.text = '';
    roiController.text = '';
    termController.text = '';
    displayResult = '';
    _currentItemSelected = _currencies[0];
  }
}
