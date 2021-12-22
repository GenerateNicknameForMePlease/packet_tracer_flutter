import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:packet_tracer/models/device.dart';

class DragItem extends StatelessWidget {
  final Device device;
  final Color color;
  final int index;
  final bool showDelete;
  final bool isBig;
  final VoidCallback onDelete;
  final double opacity;

  const DragItem({
    Key key,
    this.color,
    this.device,
    this.index,
    this.showDelete = false,
    this.isBig = true,
    this.onDelete,
    this.opacity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity ?? 1,
      child: ColoredBox(
        color: color ?? Colors.white,
        child: SizedBox(
          width: 90,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(width: 90, height: 64),
                  Container(
                    width: 64,
                    height: 64,
                    child: CachedNetworkImage(
                      imageUrl: device.imageUrl,
                      width: 64,
                      height: 64,
                    ),
                  ),
                  if (showDelete)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: onDelete,
                        behavior: HitTestBehavior.opaque,
                        child: Icon(Icons.close),
                      ),
                    )
                ],
              ),
              const SizedBox(height: 10),
              Text(device.name, textAlign: TextAlign.center),
              if (index != null) ...[
                const SizedBox(height: 10),
                Text('$index'),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
