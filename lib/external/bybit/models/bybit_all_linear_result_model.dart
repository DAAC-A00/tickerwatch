// bybit_all_linear_result_model.dart

import 'bybit_all_linear_list_model.dart';

class BybitAllLinearResultModel {
  String? category;
  List<BybitAllLinearListModel>? list;

  BybitAllLinearResultModel({this.category, this.list});

  BybitAllLinearResultModel.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    if (json['list'] != null) {
      list = <BybitAllLinearListModel>[];
      json['list'].forEach((v) {
        list!.add(BybitAllLinearListModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
