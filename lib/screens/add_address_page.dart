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

  // Define the Color Palette
  static const Color primaryColor = Color(0xFF007BFF); // A vibrant Blue
  static const Color accentColor = Color(0xFF28A745); // A complementary Green
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color textColor = Color(0xFF343A40);

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
        // Use ScaffoldMessenger.of(context).showSnackBar with updated color
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please fill in at least one address field"),
            backgroundColor:
                primaryColor, // Example: Use primary color for snackbar
          ),
        );
        return;
      }

      // Insert and go back
      await provider.addAddress(addressCompanion);

      if (mounted) {
        // Use ScaffoldMessenger.of(context).showSnackBar with updated color
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Address added successfully!"),
            backgroundColor:
                accentColor, // Example: Use accent color for success
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Apply background color
      appBar: AppBar(
        title: const Text("Add Address",
            style: TextStyle(
                color: backgroundColor)), // Contrast with primary color
        centerTitle: true,
        backgroundColor: primaryColor, // Apply primary color
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor, // Apply primary color
                        foregroundColor:
                            backgroundColor, // Text color for contrast
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Save Address",
                          style: TextStyle(fontSize: 18)),
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
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor)), // Apply text color
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          cursorColor: primaryColor, // Use primary color for cursor
          decoration: InputDecoration(
            hintText: hint,
            // Apply color palette to borders
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: textColor),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  color: primaryColor, width: 2.0), // Focus state border color
            ),
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          ),
          style: const TextStyle(color: textColor), // Apply text color to input
        ),
      ],
    );
  }
}
