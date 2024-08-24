// bybit_all_spot_result_model.dart

import 'bybit_all_spot_list_model.dart';

class BybitAllSpotResultModel {
  String? category;
  List<BybitAllSpotListModel>? list;

  BybitAllSpotResultModel({this.category, this.list});

  BybitAllSpotResultModel.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    if (json['list'] != null) {
      list = <BybitAllSpotListModel>[];
      json['list'].forEach((v) {
        list!.add(BybitAllSpotListModel.fromJson(v));
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
