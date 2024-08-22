// bybit_all_spot_model.dart

import 'bybit_all_spot_result_model.dart';
import 'bybit_all_spot_retextinfo_model.dart';

class BybitAllSpotModel {
  int? retCode;
  String? retMsg;
  BybitAllSpotResultModel? result;
  BybitAllSpotRetExtInfoModel? retExtInfo;
  int? time;

  BybitAllSpotModel(
      {this.retCode, this.retMsg, this.result, this.retExtInfo, this.time});

  BybitAllSpotModel.fromJson(Map<String, dynamic> json) {
    retCode = json['retCode'];
    retMsg = json['retMsg'];
    result = json['result'] != null
        ? BybitAllSpotResultModel.fromJson(json['result'])
        : null;
    retExtInfo = json['retExtInfo'] != null
        ? BybitAllSpotRetExtInfoModel.fromJson(json['retExtInfo'])
        : null;
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['retCode'] = retCode;
    data['retMsg'] = retMsg;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    if (retExtInfo != null) {
      data['retExtInfo'] = retExtInfo!.toJson();
    }
    data['time'] = time;
    return data;
  }
}
