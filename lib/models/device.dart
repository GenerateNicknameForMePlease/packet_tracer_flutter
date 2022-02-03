class Device {
  // уникальный идентификатор устройства
  final int id;
  // название устройства, которое будет отображаться на экране
  final String name;
  // тип устройства (конечное устройство, роутер и тд)
  final DeviceType deviceType;
  // ссылка на изображение
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
  // уникальный идентификатор типа устройства
  final int id;
  // название типа устройства
  final String name;

  const DeviceType({this.id, this.name});
  
  factory DeviceType.fromJson(Map<String, dynamic> json) {
    return DeviceType(
      id: json['id'],
      name: json['name'],
    );
  }
}