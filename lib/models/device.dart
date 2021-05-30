class Device {
  final int id;
  final String name;
  final DeviceType deviceType;
  final String imageUrl;

  const Device({this.id, this.name, this.deviceType, this.imageUrl});

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      name: json['name'],
      deviceType: DeviceType.fromJson(json['device_type']),
      imageUrl: json['image'],
    );
  }
}

class DeviceType {
  final int id;
  final String name;

  const DeviceType({this.id, this.name});
  
  factory DeviceType.fromJson(Map<String, dynamic> json) {
    return DeviceType(
      id: json['id'],
      name: json['name'],
    );
  }
}