import 'package:json_annotation/json_annotation.dart';

part 'StatusModel.g.dart';

@JsonSerializable()
class StatusModel {
  
  List<Status> statuses;

  StatusModel(this.statuses);

  factory StatusModel.fromJson(Map<String, dynamic> json) =>
      _$StatusModelFromJson(json);
}

@JsonSerializable()
class Status {
 
 dynamic id;
 dynamic name;
 dynamic userType;


  Status(this.id, this.name,this.userType);

  factory Status.fromJson(Map<String, dynamic> json) =>
      _$StatusFromJson(json);
}
