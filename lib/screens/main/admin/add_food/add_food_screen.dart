import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order_app/commons/styles/colors.dart';
import 'package:order_app/domain/entities/food.dart';

class AddFoodScreen extends StatefulWidget {
  AddFoodScreen({super.key});

  static const path = 'add_food_screen';

  @override
  State<AddFoodScreen> createState() => AddFoodScreenState();
}

class AddFoodScreenState extends State<AddFoodScreen> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  bool _isUpdated = false;

  @override
  void initState() {
    super.initState();
    // Khởi tạo controller với giá trị ban đầu
    _nameController = TextEditingController(text: '');
    _priceController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      print('pickedFile: ${pickedFile.path}');
    }
  }

  Future _pickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      print('pickedFile: ${pickedFile.path}');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm món ăn'),
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image.memory(
              //   base64Decode(widget.food.image),
              //   height: 300,
              //   width: double.infinity,
              //   fit: BoxFit.cover,
              // ),
              InkWell(
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 400,
                        color: AppColors.orochimaru,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text('Tải ảnh lên'),
                              ElevatedButton(
                                child: const Text('Ảnh từ máy', style: TextStyle(color: Colors.white),),
                                onPressed: () {
                                  _pickImageFromGallery();
                                },
                              ),
                              ElevatedButton(
                                child: const Text('Camera', style: TextStyle(color: Colors.white),),
                                onPressed: () {
                                  _pickImageFromCamera();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.grey,
                  child: Center(
                    child: Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
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
                decoration: const InputDecoration(
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
                child: const Text('Thêm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
