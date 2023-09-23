import 'package:flutter/material.dart';

class ColorModel {
  final String name;
  final Color color;

  ColorModel({required this.name, required this.color});

  static List<ColorModel> getColorsList() {
    return [
      ColorModel(name: 'Black', color: Colors.black),
      ColorModel(name: 'Violet', color: Colors.deepPurple),
      ColorModel(name: 'Indigo', color: Colors.indigo),
      ColorModel(name: 'Blue', color: Colors.blue),
      ColorModel(name: 'Green', color: Colors.green),
      ColorModel(name: 'Yellow', color: Colors.yellow),
      ColorModel(name: 'Orange', color: Colors.orange),
      ColorModel(name: 'Red', color: Colors.red),
      ColorModel(name: 'White', color: Colors.white),
    ];
  }
}