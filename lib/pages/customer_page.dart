// ignore_for_file: use_super_parameters, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_rest/database/service/customerService.dart';
import 'package:urban_rest/model/customer.dart';
import 'package:urban_rest/pages/customer_details_page.dart';
import 'package:urban_rest/providers/backGroundColorProvider.dart';
import 'package:urban_rest/widgets/common_widgets.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({Key? key}) : super(key: key);

  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final CustomerService _customerService = CustomerService();

  List<Customer> customersList = [];
  List<Customer> _filteredCustomers = [];

  final TextEditingController _searchController = TextEditingController();

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
    final backgroundColorProvider = Provider.of<Backgroundcolorprovider>(
      context,
    );
    final selectedBackGroundColor =
        backgroundColorProvider.activeBackgroundColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        backgroundColor: CommonWidgets.getTopColors(
          selectedBackGroundColor?.colorsList ?? '0xFF2193b0',
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: CommonWidgets.getColors(
              selectedBackGroundColor?.colorsList ?? '0xFF2193b0,0xFF6dd5ed',
            ),
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
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _filterCustomers('');
                    },
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Expanded(
              child:
                  _filteredCustomers.isEmpty
                      ? const Center(
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
                              showDialog(
                                context: context,
                                builder:
                                    (context) => CustomerDetailsPage(
                                      customer: customer,
                                      flagValue: 'view',
                                    ),
                              );
                            },
                            leading: const Icon(Icons.person, size: 60),
                            title: Text(customer.name),
                            subtitle: Text('Phone: ${customer.phone}'),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.edit_square,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder:
                                      (context) => CustomerDetailsPage(
                                        customer: customer,
                                        flagValue: 'edit',
                                      ),
                                );
                                showCustomers();
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
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => const CustomerDetailsPage(flagValue: 'save'),
          );
          showCustomers();
        },
        child: const Icon(Icons.person_add_alt_1, size: 30),
      ),
    );
  }
}
