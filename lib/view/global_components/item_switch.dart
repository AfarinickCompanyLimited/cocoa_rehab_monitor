// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';

typedef OnSelectCallback = Function(dynamic val);

class ItemSwitch extends StatefulWidget {
  final List<Map<dynamic, dynamic>>? items;
  final Color? backgroundColor;
  final Color? inActiveColor;
  final Color? activeColor;
  final dynamic initialValue;
  final double? textSize;
  final OnSelectCallback? onSelect;
  const ItemSwitch(
      {Key? key,
      @required this.items,
      @required this.onSelect,
      @required this.inActiveColor,
      @required this.activeColor,
      this.initialValue,
      this.backgroundColor,
      this.textSize = 13})
      : super(key: key);

  @override
  State<ItemSwitch> createState() => _ItemSwitchState();
}

class _ItemSwitchState extends State<ItemSwitch> {
  var selectedVal;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedVal = widget.initialValue ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 55,
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: widget.backgroundColor ?? appColorInputBackgroundWhite,
            borderRadius: BorderRadius.circular(AppBorderRadius.xl)),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.items!.map<Widget>((entry) {
              var itemKey = entry.keys.first;
              var itemValue = entry.values.first;
              var item = Expanded(
                  child: Container(
                // margin: EdgeInsets.only(left: items!.first == entry ? 0 : 8),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: TextButton(
                  style: TextButton.styleFrom(
                    //foregroundColor: Colors.white,
                    backgroundColor: itemValue == selectedVal
                        ? widget.activeColor
                        : widget.inActiveColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(AppBorderRadius.xl))),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedVal = itemValue;
                    });
                    widget.onSelect!(itemValue);
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      itemKey,
                      style: TextStyle(
                          color: Colors.black87, fontSize: widget.textSize),
                    ),
                  ),
                ),
              ));
              return item;
            }).toList()));
  }
}
