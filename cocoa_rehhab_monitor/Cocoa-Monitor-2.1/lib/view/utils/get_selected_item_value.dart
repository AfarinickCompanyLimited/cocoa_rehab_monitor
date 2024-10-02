// =================================================================================
// =================================================================================
// This function is used to retrieve an element from a list of elements
getSelectedItemValue({List? list, String? key, String? value, bool? isJson}){
  if(isJson!){
    return list![list.indexWhere((element) => element[key] == value)];
  }else{
    return list![list.indexWhere((element) => element.toJson()[key] == value)];
  }
}
// =================================================================================
// =================================================================================