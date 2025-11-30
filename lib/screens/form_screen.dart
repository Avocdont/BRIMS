import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int? selectedValue;
  DateTime? _value;
  String? selectedValues;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            width: 800,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Last Name').semiBold().small(),
                const SizedBox(height: 4),
                const shadcn.TextField(
                  placeholder: Text('Enter your last name'),
                ),
                const SizedBox(height: 10),
                const Text('First Name').semiBold().small(),
                const SizedBox(height: 4),
                const shadcn.TextField(
                  placeholder: Text('Enter your first name'),
                ),
                const SizedBox(height: 10),
                const Text('Middle Name').semiBold().small(),
                const SizedBox(height: 4),
                const shadcn.TextField(
                  placeholder: Text('Enter your middle name'),
                ),
                const SizedBox(height: 10),
                const Text('Suffix').semiBold().small(),
                const SizedBox(height: 4),
                const shadcn.TextField(placeholder: Text('Enter your suffix')),
                const SizedBox(height: 10),
                const Text('Sex').semiBold().small(),
                shadcn.RadioGroup<int>(
                  value: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      // Save the selected value emitted by the tapped RadioItem.
                      selectedValue = value;
                    });
                  },
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Each RadioItem represents a single choice with an associated integer value.
                      shadcn.RadioItem(value: 1, trailing: Text('Male')),
                      shadcn.RadioItem(value: 2, trailing: Text('Female')),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Birth Date').semiBold().small(),
                const SizedBox(height: 10),
                shadcn.DatePicker(
                  value: _value,
                  mode: shadcn.PromptMode.dialog,
                  // Title shown at the top of the dialog variant.
                  dialogTitle: const Text('Select Birth date'),
                  stateBuilder: (date) {
                    if (date.isAfter(DateTime.now())) {
                      return shadcn.DateState.disabled;
                    }
                    return shadcn.DateState.enabled;
                  },
                  onChanged: (value) {
                    setState(() {
                      _value = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                const Text('Civil Status').semiBold().small(),
                const SizedBox(height: 10),
                shadcn.Select<String>(
                  // How to render each selected item as text in the field.
                  itemBuilder: (context, item) {
                    return Text(item);
                  },
                  // Limit the popup size so it doesn't grow too large in the docs view.
                  popupConstraints: const BoxConstraints(
                    maxHeight: 300,
                    maxWidth: 200,
                  ),
                  onChanged: (value) {
                    setState(() {
                      // Save the currently selected value (or null to clear).
                      selectedValues = value;
                    });
                  },
                  // The current selection bound to this field.
                  value: selectedValues,
                  placeholder: const Text('Select a status'),
                  popup: const shadcn.SelectPopup(
                    items: shadcn.SelectItemList(
                      children: [
                        // A simple static list of options.
                        shadcn.SelectItemButton(
                          value: 'Single',
                          child: Text('Single'),
                        ),
                        shadcn.SelectItemButton(
                          value: 'Married',
                          child: Text('Married'),
                        ),
                        shadcn.SelectItemButton(
                          value: 'Annulled',
                          child: Text('Annulled'),
                        ),
                        shadcn.SelectItemButton(
                          value: 'Widowed',
                          child: Text('Widowed'),
                        ),
                        shadcn.SelectItemButton(
                          value: 'Separated',
                          child: Text('Separated'),
                        ),
                        shadcn.SelectItemButton(
                          value: 'Live In',
                          child: Text('Live In'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
