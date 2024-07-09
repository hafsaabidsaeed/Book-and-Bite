import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondevaluation/GetVars/all_sellers.dart';
import 'package:secondevaluation/GetVars/initial.dart';
import 'package:secondevaluation/Loader/loader.dart';
import 'package:secondevaluation/Screens/PrintShop/Modal.dart';
import 'package:secondevaluation/Screens/Seller_Sc/Getx/FetchMenu.dart';

class CustomerView extends StatelessWidget {
  CustomerView({super.key});
  final GetVarsCtrl = Get.put(MenuControllerData());
  final GetVarsCtrlMain = Get.put(GetVars());
  final allSellers = Get.put(AllSellers());

  final Rx<DateTime?> _selectedDate = Rx<DateTime?>(null);
  final Rx<TimeOfDay?> _selectedTime = Rx<TimeOfDay?>(null);
  final RxBool _isColorPrinting = false.obs;
  final RxInt _quantity = 1.obs;

  // Date and time Picker
  Future<void> _pickDateAndTime(BuildContext context) async {
    final currentDate = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate,
      lastDate: currentDate.add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        _selectedDate.value = pickedDate;
        _selectedTime.value = pickedTime;
      }
    }
  }

  // Cost calculation
  double calculateTotalCost(int quantity, bool isColorPrinting) {
    double baseCostPerFile = 120.0;
    double colorPrintingCost = isColorPrinting ? 50.0 : 0.0;
    double totalCost = baseCostPerFile * quantity + colorPrintingCost;
    return totalCost;
  }

  void _showErrorSnackBar(String message) {
    Get.snackbar('Error', message, colorText: Colors.white, backgroundColor: Colors.red);
  }

  void _OrderSentSnackBar(String message) {
    Get.snackbar('Order Sent', message, colorText: Colors.white, backgroundColor: Colors.green);
    // Clear the screen or navigate to a new screen after showing snackbar
    _clearScreen();
  }

  void _clearScreen() {
    // Reset values or navigate to a new screen
    _selectedDate.value = null;
    _selectedTime.value = null;
    _isColorPrinting.value = false;
    _quantity.value = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 76, 197, 193),
        title: const Text(
          "COMSATS Printing Shop",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.replay),
            onPressed: () {},
          ),
        ],
      ),
      body: GetBuilder<GetVars>(
        builder: (GetVarsCtrlMain) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const Text(
                    "Choose a document to print",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: ListView.builder(
                      itemCount: allSellers.allPrinters.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(allSellers.allPrinters[index]["shopName"].toString()),
                          direction: DismissDirection.none,
                          background: Container(
                            color: Colors.green,
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Icon(Icons.done_all, color: Colors.white),
                                    SizedBox(width: 10),
                                    Text(
                                      "Order Completed !",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          onDismissed: (direction) {
                            // Implement delete functionality here
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ListTile(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AwesomeModal(
                                      context: context,
                                      uid: allSellers.allPrinters[index]["uID"],
                                    );
                                  },
                                );
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              leading: const Icon(Icons.add),
                              tileColor: const Color.fromARGB(255, 216, 255, 254),
                              title: Text(
                                "Select Document",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Options',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(
                            () => CheckboxListTile(
                          title: const Text('Color Printing'),
                          value: _isColorPrinting.value,
                          onChanged: (newValue) {
                            _isColorPrinting.value = newValue!;
                          },
                          activeColor: const Color.fromARGB(255, 76, 197, 193),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Quantity:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Obx(
                                  () => TextFormField(
                                initialValue: '${_quantity.value}',
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  _quantity.value = int.tryParse(value) ?? 1;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => _pickDateAndTime(context),
                      icon: Icon(
                        Icons.calendar_today,
                        color: const Color.fromARGB(255, 76, 197, 193),
                        size: 30,
                      ),
                      label: Text(
                        'Select Date and Time',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 76, 197, 193),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: const Color.fromARGB(255, 76, 197, 193),
                            width: 1,
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                        () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Date and Time:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _selectedDate.value != null && _selectedTime.value != null
                                  ? '${_selectedDate.value!.toString().split(' ')[0]} ${_selectedTime.value!.format(context)}'
                                  : 'Not selected',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.white,
          child: ElevatedButton(
            onPressed: () {
              if (_selectedDate.value == null || _selectedTime.value == null) {
                _showErrorSnackBar("Please select date and time.");
                return;
              } else {
                _OrderSentSnackBar("Order placed successfully");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 216, 255, 254),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              'Confirm Order',
              style: TextStyle(fontSize: 17, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
