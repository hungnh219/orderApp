import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:order_app/domain/entities/food.dart';

class UpdateFoodScreen extends StatefulWidget {
  UpdateFoodScreen({super.key, required this.food});

  static const path = 'update_food_screen';

  final FoodModel food;

  @override
  State<UpdateFoodScreen> createState() => _UpdateFoodScreenState();
}

class _UpdateFoodScreenState extends State<UpdateFoodScreen> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  bool _isUpdated = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.food.name);
    _priceController = TextEditingController(text: widget.food.price.toString());

    _nameController.addListener(_checkForUpdates);
    _priceController.addListener(_checkForUpdates);
  }

  void _checkForUpdates() {
    setState(() {
      _isUpdated = _nameController.text != widget.food.name ||
          _priceController.text != widget.food.price.toString();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food.name),
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.memory(
                base64Decode(widget.food.image),
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Tên món',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Giá',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isUpdated ? () {
                  print('Name: ${_nameController.text}, Price: ${_priceController.text}');
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isUpdated ? Colors.blue : Colors.grey,
                ),
                child: const Text('Cập nhật'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
