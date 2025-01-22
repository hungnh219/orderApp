import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:order_app/commons/styles/themes.dart';
import 'package:order_app/domain/repository/food/food_repository.dart';
import 'package:order_app/screens/main/order_detail.dart';
import 'package:order_app/services/service_locator.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  static const path = 'notification_screen';

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
                const Center(
                  child: Text('ĐƠN HÀNG', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),
                IconButton(onPressed: () {
                }, icon: Icon(Icons.notifications, color: Colors.transparent,)),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: serviceLocator.get<FoodRepository>().listenOrders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data == []) {
                  return const Center(child: Text('No data'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('Đơn số ${snapshot.data![index].number}'),
                                  ),
                                ),

                                if (snapshot.data![index].status == 'pending')
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                    onPressed: () {
                                    },
                                    child: const Text('Chờ', style: TextStyle(color: Colors.white),),
                                  )
                                else
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                    onPressed: () {
                                    },
                                    child: const Text('Xong', style: TextStyle(color: Colors.white),),
                                  ),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () {
                                    context.pushNamed(OrderDetailScreen.path, extra: snapshot.data![index]);
                                   },
                                  child: const Text('Xem', style: TextStyle(color: Colors.white),),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    if (snapshot.data![index].status == 'pending') {
                                      await serviceLocator.get<FoodRepository>().updateOrderStatus(snapshot.data![index].orderId, 'done');
                                    }

                                  },
                                  icon: Icon(Icons.done_all, color: (snapshot.data![index].status == 'pending' ? Colors.green : Colors.transparent),)),
                              ],
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  );
                }
              }
            ) 
          )
        ],
      ),
    );
  }
}