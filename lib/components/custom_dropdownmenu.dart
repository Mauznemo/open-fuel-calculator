import 'package:flutter/material.dart';

class CustomDropdownMenu<T> extends StatefulWidget {
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
  State<CustomDropdownMenu<T>> createState() => _CustomDropdownMenuState<T>();
}

class _CustomDropdownMenuState<T> extends State<CustomDropdownMenu<T>> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLabelFloating = _isFocused || (widget.controller.text.isNotEmpty);

    return DropdownMenu<T>(
      initialSelection: widget.initialSelection,
      controller: widget.controller,
      focusNode: _focusNode,
      enableFilter: widget.enableFilter,
      requestFocusOnTap: true,
      width: MediaQuery.of(context).size.width - 32,
      alignmentOffset: Offset(0, 5),
      hintText: widget.hintText,
      label: widget.label != null
          ? Container(
              padding: EdgeInsets.only(bottom: isLabelFloating ? 25 : 0),
              child: widget.label,
            )
          : null,
      onSelected: widget.onSelected,
      dropdownMenuEntries: widget.dropdownMenuEntries,
      menuStyle: MenuStyle(
        fixedSize: WidgetStateProperty.all(
            Size(MediaQuery.of(context).size.width - 32, double.infinity)),
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
