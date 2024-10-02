// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cocoa_monitor/view/global_components/text_input_decoration.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class SelectionBottomSheet extends StatelessWidget {
  final String? title;
  final String? invalidText;
  final list;
  final String? selectedItem;
  final Function? onChanged;
  final Function? validator;
  final bool? useCustomValidator;
  final Color? inputFill;
  const SelectionBottomSheet({Key? key,
    this.list,
    this.selectedItem,
    this.title,
    this.invalidText,
    this.onChanged,
    this.validator,
    this.useCustomValidator = false,
    this.inputFill = Colors.white
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownSearch(
      popupProps: PopupProps.modalBottomSheet(
        showSelectedItems: true,
        showSearchBox: list!.length > 8 ? true : false,
        // itemBuilder: (context, item, v){
        //   return Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        //     child: Text(item.toString()),
        //   );
        // },
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Center(
            child: Text(title!,
              style: const TextStyle(fontWeight: FontWeight.w500),),
          ),
        ),
        disabledItemFn: (String s) => false,
          modalBottomSheetProps: ModalBottomSheetProps(
              elevation: 6,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(AppBorderRadius.md), topRight: Radius.circular(AppBorderRadius.md))
            ),
          ),
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
              enabledBorder: inputBorder,
              focusedBorder: inputBorderFocused,
              errorBorder: inputBorder,
              focusedErrorBorder: inputBorderFocused,
              filled: true,
              fillColor: AppColor.xLightBackground,
            ),
          )
      ),
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
          enabledBorder: inputBorder,
          focusedBorder: inputBorderFocused,
          errorBorder: inputBorder,
          focusedErrorBorder: inputBorderFocused,
          filled: true,
          fillColor: inputFill,
        ),
      ),
      // mode: Mode.BOTTOM_SHEET,

      // useRootNavigator: true,
      dropdownBuilder: (ctx, val){
        return val == null ? Container() : Text(val.toString());
      },
      items: list,
      selectedItem: selectedItem,
      onChanged: (val) => onChanged!(val),
      validator: !useCustomValidator! ? (item) {
        if (item == null) {
          return invalidText;
        } else {
          return null;
        }
      } : (item) => validator!(item),
    );
  }
}



// var inputBorder =  OutlineInputBorder(
//     borderRadius: BorderRadius.circular(AppBorderRadius.xl),
//     borderSide: const BorderSide(width: 0, color: Colors.white)
// );
//
// var inputBorderFocused =  OutlineInputBorder(
//     borderRadius: BorderRadius.circular(AppBorderRadius.xl),
//     borderSide: BorderSide(width: 1, color: appColorPrimary)
// );