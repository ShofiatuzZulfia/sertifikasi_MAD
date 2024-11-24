import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moments/app/modules/home/controllers/home_controller.dart';
import 'package:moments/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        controller.username.value.isNotEmpty
                            ? 'Hello, ${controller.username.value}'
                            : 'Loading...',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        controller.logout();
                      },
                      icon: Icon(
                        Icons.logout,
                        color: Colors.teal[200],
                        size: 30,
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        }),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Object?>>(
              stream: controller.streamData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData && snapshot.data!.size > 0) {
                    var data = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        var item = data[index];
                        return GestureDetector(
                          onTap: () {
                            if (controller.username.value == item['user']) {
                              // Jika ya, lanjutkan dengan update data
                              Get.toNamed(
                                Routes.UPDATE,
                                arguments: item.id,
                              );
                            } else {
                              // Jika tidak, tampilkan dialog
                              Get.defaultDialog(
                                title: "Akses Ditolak",
                                middleText:
                                    "Anda tidak bisa mengubah postingan ini karena bukan milik Anda.",
                                textConfirm: "OK",
                                onConfirm: () => Get.back(),
                              );
                            }
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            // color: Colors
                            // .primaries[index % Colors.primaries.length]
                            // .withOpacity(0.3),
                            color: [
                              Colors.red[100],
                              Colors.green[100],
                              Colors.blue[100],
                            ][index % 3],

                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['emoji'] ?? '🙂',
                                    style: const TextStyle(fontSize: 45),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '@${item['user'] ?? ''}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item['title'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item['moments'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        controller.deleteData(item.id),
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('Data Belum Ditambahkan'),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ClipOval(
        child: Material(
          color: Colors.teal[200],
          child: InkWell(
            splashColor: Colors.white,
            child: const SizedBox(
              width: 55,
              height: 55,
              child: Icon(Icons.add, color: Colors.white),
            ),
            onTap: () {
              Get.toNamed(Routes.CREATE);
            },
          ),
        ),
      ),
    );
  }
}
