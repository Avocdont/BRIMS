import 'package:brims/database/app_db.dart';
import 'package:brims/provider/household%20providers/household_provider.dart';
import 'package:drift/drift.dart' as db;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for Address Attributes
  late TextEditingController _zoneController;
  late TextEditingController _streetController;
  late TextEditingController _blockController;
  late TextEditingController _lotController;

  @override
  void initState() {
    super.initState();
    _zoneController = TextEditingController();
    _streetController = TextEditingController();
    _blockController = TextEditingController();
    _lotController = TextEditingController();
  }

  @override
  void dispose() {
    _zoneController.dispose();
    _streetController.dispose();
    _blockController.dispose();
    _lotController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<HouseholdProvider>();

      // Create the companion object
      final addressCompanion = AddressesCompanion(
        zone: _zoneController.text.isNotEmpty
            ? db.Value(_zoneController.text)
            : const db.Value.absent(),
        street: _streetController.text.isNotEmpty
            ? db.Value(_streetController.text)
            : const db.Value.absent(),
        block: _blockController.text.isNotEmpty
            ? db.Value(_blockController.text)
            : const db.Value.absent(),
        lot: _lotController.text.isNotEmpty
            ? db.Value(_lotController.text)
            : const db.Value.absent(),
      );

      // Check if at least one field is filled (optional validation)
      if (!addressCompanion.zone.present &&
          !addressCompanion.street.present &&
          !addressCompanion.block.present &&
          !addressCompanion.lot.present) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Please fill in at least one address field")),
        );
        return;
      }

      // Insert and go back
      await provider.addAddress(addressCompanion);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Address added successfully!")),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Address"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
              maxWidth: 600), // Limit width for desktop look
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                      "Zone", "Enter zone (e.g., Zone 1)", _zoneController),
                  const SizedBox(height: 16),
                  _buildTextField(
                      "Street", "Enter street name", _streetController),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                            "Block", "Blk no.", _blockController),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child:
                            _buildTextField("Lot", "Lot no.", _lotController),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveAddress,
                      child: const Text("Save Address"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
        ),
      ],
    );
  }
}
