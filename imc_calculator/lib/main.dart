// Desenvolva um aplicativo para calcular o IMC (Índice de massa corporal), dada uma altura (cm), e um peso (kg).
// A aplicação deve possuir uma única tela, com os seguintes elementos visuais:
// Dois inputs (Peso em kg, altura em cm)
// Um botão “Calcular”, que seta as labels de resultado na tela.
// Um botão “Resetar”, que limpa os inputs e as labels de resultado.
// Um label para exibir a faixa de IMC resultante, como descrito no slide a seguir.
// Um label para exibir o índice de IMC resultante.
// Code in Flutter: https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/material/text_form_field_demo.dart

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'IMC'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightFocusNode = FocusNode();
  final _heightFocusNode = FocusNode();
  String _imcResult = '';
  String _imcRange = '';

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _weightFocusNode.dispose();
    _heightFocusNode.dispose();
    super.dispose();
  }

  void _calculateIMC() {
    double weight = double.parse(_weightController.text);
    double height = double.parse(_heightController.text) / 100;
    double imc = weight / (height * height);
    setState(() {
      _imcResult = imc.toStringAsFixed(2);
      if (imc < 18.5) {
        _imcRange = 'Abaixo do peso';
      } else if (imc >= 18.5 && imc < 25) {
        _imcRange = 'Peso normal';
      } else if (imc >= 25 && imc < 30) {
        _imcRange = 'Sobrepeso';
      } else if (imc >= 30 && imc < 35) {
        _imcRange = 'Obesidade grau 1';
      } else if (imc >= 35 && imc < 40) {
        _imcRange = 'Obesidade grau 2';
      } else {
        _imcRange = 'Obesidade grau 3';
      }
    });
  }

  void _reset() {
    setState(() {
      _imcResult = '';
      _imcRange = '';
      _weightController.text = '';
      _heightController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _weightController,
                focusNode: _weightFocusNode,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Peso (kg)',
                  hintText: 'Digite seu peso',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, digite seu peso';
                  }
                  return null;
                },
                onFieldSubmitted: (term) {
                  _weightFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(_heightFocusNode);
                },
              ),
              TextFormField(
                controller: _heightController,
                focusNode: _heightFocusNode,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Altura (cm)',
                  hintText: 'Digite sua altura',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, digite sua altura';
                  }
                  return null;
                },
                onFieldSubmitted: (term) {
                  _heightFocusNode.unfocus();
                  if (_formKey.currentState!.validate()) {
                    _calculateIMC();
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _calculateIMC();
                        }
                      },
                      child: const Text('Calcular'),
                    ),
                    ElevatedButton(
                      onPressed: _reset,
                      child: const Text('Resetar'),
                    ),
                  ],
                ),
              ),
              Text(
                'IMC: $_imcResult',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Text(
                'Faixa: $_imcRange',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
