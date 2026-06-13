class AppInternalData {
  final String appId;
  final String dataVersion;
  bool openByUpdate;

  AppInternalData({
    required this.appId,
    required this.dataVersion,
    required this.openByUpdate,
  });

  Map<String, dynamic> toJson() {
    return {
      'appId': appId,
      'dataVersion': dataVersion,
      'openByUpdate': openByUpdate,
    };
  }

  factory AppInternalData.fromJson(Map<String, dynamic> json) {
    return AppInternalData(
      openByUpdate: json['openByUpdate'] as bool,
      appId: json['appId'] as String,
      dataVersion: json['dataVersion'] as String,
    );
  }
}
