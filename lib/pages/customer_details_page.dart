// ignore_for_file: use_super_parameters, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_rest/constants/databaseConstants.dart';
import 'package:urban_rest/database/service/commonService.dart';
import 'package:urban_rest/database/service/customerService.dart';
import 'package:urban_rest/model/customer.dart';
import 'package:urban_rest/providers/backGroundColorProvider.dart';
import 'package:urban_rest/widgets/common_widgets.dart';

class CustomerDetailsPage extends StatefulWidget {
  final Customer? customer;
  final String? flagValue;

  const CustomerDetailsPage({Key? key, this.customer, this.flagValue})
    : super(key: key);

  @override
  _CustomerDetailsPageState createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  final CustomerService _customerService = CustomerService();
  final Commonservice _commonservices = Commonservice();

  // Controls
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _customerAddressController = TextEditingController();
  final _customerSecurityIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _customerNameController.text = widget.customer!.name;
      _customerPhoneController.text = widget.customer!.phone;
      _customerAddressController.text = widget.customer!.address;
      _customerSecurityIdController.text = widget.customer!.securityId;
    }
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _customerAddressController.dispose();
    _customerSecurityIdController.dispose();
    super.dispose();
  }

  Future<void> _saveOrUpdateCustomer() async {
    if (_formKey.currentState!.validate()) {
      final name = _customerNameController.text;
      final phone = _customerPhoneController.text;
      final address = _customerAddressController.text;
      final securityId = _customerSecurityIdController.text;

      if (widget.customer == null) {
        int length = await _commonservices.getRowCount(
          DatabaseConstants.TABLE_CUSTOMER,
        );
        await _customerService.insertCustomer(
          Customer(
            id: length + 1,
            name: name,
            phone: phone,
            address: address,
            securityId: securityId,
          ),
        );
        _showSnackBar('Customer added successfully', Colors.green);
      } else {
        await _customerService.updateCustomer(
          Customer(
            id: widget.customer!.id,
            name: name,
            phone: phone,
            address: address,
            securityId: securityId,
          ),
        );
        _showSnackBar('Customer updated successfully', Colors.blue);
      }

      Navigator.pop(context);
    } else {
      _showSnackBar('Please fill all fields', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info, color: Colors.white),
            const SizedBox(width: 10),
            Text(message),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColorProvider = Provider.of<Backgroundcolorprovider>(context);
    final selectedBackGroundColor = bgColorProvider.activeBackgroundColor;
    final isEdit = widget.customer != null;

    return Dialog(
      backgroundColor: CommonWidgets.getBottomColors(
        selectedBackGroundColor?.colorsList ?? '0xFF2193b0',
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  getTitle(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Form
                Flexible(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _customerNameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator:
                                (value) => value!.isEmpty ? 'Required' : null,
                          ),

                          const SizedBox(height: 12),

                          TextFormField(
                            controller: _customerPhoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.phone),
                            ),
                            validator:
                                (value) => value!.isEmpty ? 'Required' : null,
                            keyboardType: TextInputType.phone,
                          ),

                          const SizedBox(height: 12),

                          TextFormField(
                            controller: _customerAddressController,
                            decoration: const InputDecoration(
                              labelText: 'Address',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.home),
                            ),
                            validator:
                                (value) => value!.isEmpty ? 'Required' : null,
                          ),

                          const SizedBox(height: 12),

                          TextFormField(
                            controller: _customerSecurityIdController,
                            decoration: const InputDecoration(
                              labelText: 'Security ID',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.vpn_key),
                            ),
                            validator:
                                (value) => value!.isEmpty ? 'Required' : null,
                          ),

                          const SizedBox(height: 20),

                          // Action Buttons
                          if (widget.flagValue != 'view') ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _saveOrUpdateCustomer,
                                  icon: Icon(isEdit ? Icons.edit : Icons.save),
                                  label: Text(
                                    isEdit ? 'Update' : 'Save',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    backgroundColor:
                                        isEdit
                                            ? Colors.blueAccent
                                            : Colors.green,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 5,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                ElevatedButton.icon(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.cancel),
                                  label: const Text(
                                    'Cancel',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    backgroundColor: Colors.red[600],
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 3,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Close Icon (top-right corner)
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Close',
            ),
          ),
        ],
      ),
    );
  }

  String getTitle() {
    if (widget.flagValue == 'edit') {
      return 'Edit Customer';
    } else if (widget.flagValue == 'save') {
      return 'Add Customer';
    }
    return 'Customer Details';
  }
}
