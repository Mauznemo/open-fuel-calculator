import 'package:flutter/material.dart';

class CustomDropdownMenu<T> extends StatelessWidget {
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final Text? label;
  final void Function(T?)? onSelected;
  final T? initialSelection;
  final bool enableFilter;

  const CustomDropdownMenu({
    Key? key,
    required this.dropdownMenuEntries,
    required this.controller,
    this.focusNode,
    this.hintText = '',
    this.label,
    this.onSelected,
    this.initialSelection,
    this.enableFilter = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
      initialSelection: initialSelection,
      controller: controller,
      focusNode: focusNode,
      enableFilter: enableFilter,
      requestFocusOnTap: true,
      width: MediaQuery.of(context).size.width - 32,
      hintText: hintText,
      label: label,
      onSelected: onSelected,
      dropdownMenuEntries: dropdownMenuEntries,
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(
            Theme.of(context).colorScheme.secondaryContainer),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        elevation: WidgetStateProperty.all(4),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Theme.of(context).colorScheme.secondaryContainer,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
