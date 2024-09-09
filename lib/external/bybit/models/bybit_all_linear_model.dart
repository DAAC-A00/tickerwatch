// bybit_all_linear_model.dart

import 'bybit_all_linear_result_model.dart';
import 'bybit_all_linear_retextinfo_model.dart';

class BybitAllLinearModel {
  int? retCode;
  String? retMsg;
  BybitAllLinearResultModel? result;
  BybitAllLinearRetExtInfoModel? retExtInfo;
  int? time;

  BybitAllLinearModel(
      {this.retCode, this.retMsg, this.result, this.retExtInfo, this.time});

  BybitAllLinearModel.fromJson(Map<String, dynamic> json) {
    retCode = json['retCode'];
    retMsg = json['retMsg'];
    result = json['result'] != null
        ? BybitAllLinearResultModel.fromJson(json['result'])
        : null;
    retExtInfo = json['retExtInfo'] != null
        ? BybitAllLinearRetExtInfoModel.fromJson(json['retExtInfo'])
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
