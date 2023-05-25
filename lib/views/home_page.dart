import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();
  String valueTextField = "";
  String dropdownValue = "BRL";
  String dropdownValueTwo = "EUR";
  String accessToken = "1mQIeZAF3hjErSi1AnDICshV0zWQjfMd";

  String _conversionRate = "";

  Future<void> _loadConversionRate() async {
    final headers = {'apikey': '1mQIeZAF3hjErSi1AnDICshV0zWQjfMd'};

    final response = await http.get(
      Uri.parse(
          'https://api.apilayer.com/fixer/convert?to=$dropdownValueTwo&from=$dropdownValue&amount=${controller.text}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final rate = jsonResponse['result'];
      setState(() {
        if (rate.toStringAsFixed(2) != null) {
          _conversionRate = rate.toStringAsFixed(2);
        }
      });
    } else {
      throw Exception('Falha ao carregar a taxa de conversão');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Conversor de Moedas',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 200),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Digite um valor',
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 20.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (String text) {
                valueTextField = text;
              },
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton<String>(
                  value: dropdownValue,
                  dropdownColor: Theme.of(context).colorScheme.primary,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue ?? '';
                    });
                  },
                  items: <String>['BRL', 'EUR', 'USD', 'ARS']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      String temp = dropdownValue;
                      dropdownValue = dropdownValueTwo;
                      dropdownValueTwo = temp;
                    });
                  },
                  icon: Icon(
                    Icons.change_circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                DropdownButton<String>(
                  value: dropdownValueTwo,
                  dropdownColor: Theme.of(context).colorScheme.primary,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValueTwo = newValue ?? '';
                    });
                  },
                  items: <String>['BRL', 'EUR', 'USD', 'ARS']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                _loadConversionRate();
              },
              child: const Text('Vizualizar'),
            ),
            const SizedBox(height: 25),
            Text(
              _conversionRate,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
