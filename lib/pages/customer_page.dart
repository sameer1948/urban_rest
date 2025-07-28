// ignore_for_file: use_super_parameters, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:urban_rest/constants/databaseConstants.dart';
import 'package:urban_rest/database/service/commonService.dart';
import 'package:urban_rest/database/service/customerService.dart';
import 'package:urban_rest/model/customer.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({Key? key}) : super(key: key);

  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final CustomerService _customerService = CustomerService();
  final Commonservice _commonservices = Commonservice();
  List<Customer> customersList = [];
  List<Customer> _filteredCustomers = [];

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController =
      TextEditingController();
  final TextEditingController _customerAdressController =
      TextEditingController();
  final TextEditingController _customerSecurityIdController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    showCustomers();
  }

  void showCustomers() async {
    var allCustomers = await _customerService.getAllCustomers();
    setState(() {
      customersList = allCustomers;
      _filteredCustomers = allCustomers;
    });
  }

  void _filterCustomers(String query) {
    final filtered =
        customersList.where((customer) {
          final nameMatch = customer.name.toLowerCase().contains(
            query.toLowerCase(),
          );
          final phoneMatch = customer.phone.contains(query);
          final addressMatch = customer.address.toLowerCase().contains(
            query.toLowerCase(),
          );
          final securityMatch = customer.securityId.toLowerCase().contains(
            query.toLowerCase(),
          );
          return nameMatch || phoneMatch || addressMatch || securityMatch;
        }).toList();

    setState(() {
      _filteredCustomers = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],

              //colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
              //colors: [Color(0xFFf12711), Color(0xFFf5af19)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],

            //colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
            //colors: [Color(0xFFf12711), Color(0xFFf5af19)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterCustomers,
                decoration: InputDecoration(
                  hintText: 'Search by name, phone, address, or ID',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _filterCustomers('');
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Expanded(
              child:
                  _filteredCustomers.isEmpty
                      ? Center(
                        child: Text(
                          'Customers Not Found',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                      : ListView.builder(
                        itemCount: _filteredCustomers.length,
                        itemBuilder: (context, index) {
                          final customer = _filteredCustomers[index];
                          return ListTile(
                            onTap: () {
                              // Logic to view customer details
                              showDialog(
                                context: context,
                                builder: (builder) {
                                  return AlertDialog(
                                    title: Text(customer.name),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Phone: ${customer.phone}'),
                                        Text('Address: ${customer.address}'),
                                        Text(
                                          'Security ID: ${customer.securityId}',
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Close'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            title: Text(customer.name),
                            subtitle: Text(
                              'Phone: ${customer.phone}\nAddress: ${customer.address}',
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                // Logic to delete the customer
                                showDialog(
                                  context: context,
                                  builder: (builder) {
                                    return AlertDialog(
                                      title: Text('Delete Customer'),
                                      content: Text(
                                        'Are you sure you want to delete ${customer.name}?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            // Delete the customer
                                            await _customerService
                                                .deleteCustomer(customer.id);
                                            showCustomers(); // Refresh the list
                                            Navigator.pop(context);
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'customer_add',
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(16.0),
                width: double.infinity,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 100),
                          Icon(
                            Icons.person_add_alt_1,
                            size: 25,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Add Customer',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blue,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Colors.amberAccent, thickness: 1),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _customerNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Customer Name',
                          labelText: 'Customer Name',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _customerPhoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a phone number';
                          } else if (!RegExp(
                            r'^\d{10}$',
                          ).hasMatch(value.trim())) {
                            return 'Enter valid 10-digit phone number';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Phone Name',
                          labelText: 'Customer Phone',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _customerAdressController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Enter Customer Address',
                          labelText: 'Customer Address',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _customerSecurityIdController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter security ID';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Customer Security ID',
                          labelText: 'Customer Security ID',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              // Action to save the customer
                              String name = _customerNameController.text;
                              String phone = _customerPhoneController.text;
                              String address = _customerAdressController.text;
                              String securityId =
                                  _customerSecurityIdController.text;
                              int length = 0;

                              if (_formKey.currentState!.validate()) {
                                // Get the current count of customers
                                length = await _commonservices.getRowCount(
                                  DatabaseConstants.TABLE_CUSTOMER,
                                );
                                // Save the customer logic here
                                await _customerService.insertCustomer(
                                  Customer(
                                    id: length + 1,
                                    name: name,
                                    phone: phone,
                                    address: address,
                                    securityId: securityId,
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 10),
                                        Text('Customer added successfully'),
                                      ],
                                    ),
                                    duration: Duration(seconds: 3),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );

                                // Clear the text fields
                                _customerNameController.clear();
                                _customerPhoneController.clear();
                                _customerAdressController.clear();
                                _customerSecurityIdController.clear();
                                // Refresh the customer list
                                showCustomers();
                                // Close the bottom sheet
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please fill all fields'),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                            child: Text('Save'),
                          ),
                          SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              // Action to cancel
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.person_add_alt_1, size: 30),
      ),
    );
  }
}
