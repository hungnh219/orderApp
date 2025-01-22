import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:order_app/commons/styles/themes.dart';
import 'package:order_app/domain/entities/order.dart';
import 'package:order_app/mixin/methods/convert_timestamp.dart';

class OrderDetailScreen extends StatefulWidget {
  OrderDetailScreen({super.key, required this.orderItems});

  static const path = 'order_detail_screen';
  
  OrderModel orderItems;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> with Methods {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 48,
            color: AppTheme.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () {
                  context.pop();
                }, icon: Icon(Icons.arrow_back, color: Colors.white,)),
                Center(
                  child: Text('ĐƠN ĐẶT ${widget.orderItems.number}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),
                IconButton(onPressed: () {
                }, icon: Icon(Icons.notifications, color: Colors.transparent,)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Thời gian đặt: ${calculateTimeFromNow(widget.orderItems.createdAt.toDate())}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.orderItems.orderItems.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Image.memory(
                              base64Decode(widget.orderItems.orderItems[index].entries.first.key.image),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.orderItems.orderItems[index].entries.first.key.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text('Số lượng: ${widget.orderItems.orderItems[index].entries.first.value}'),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider()
                  ],
                );
              }

            ) 
            
          )

        ],
      ),
    );
  }
}