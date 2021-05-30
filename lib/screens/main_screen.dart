import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:packet_tracer/utils/utils.dart';

class WidgetPosition {
  final Widget child;
  final Offset position;

  const WidgetPosition({this.child, this.position});
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<WidgetPosition> positions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: Stack(
                children: [
                  for (var i in positions) ...[
                    Positioned(
                      left: i.position.dx,
                      top: i.position.dy,
                      child: LongPressDraggable(
                        onDragEnd: (detail) {
                          positions.remove(i);
                          positions.add(
                            WidgetPosition(
                              position: detail.offset,
                              child: _DragItem(color: AppColors.green25D366),
                            ),
                          );
                          setState(() {});
                        },
                        childWhenDragging: SizedBox(),
                        feedback: Material(
                          child: _DragItem(color: Colors.grey),
                        ),
                        child: i.child,
                      ),
                    ),
                    Center(
                      child: Text("ХУЙ", style: TextStyle(fontSize: 56),),
                    )
                  ]
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            color: Colors.red,
            child: ListView.separated(
              itemCount: 30,
              padding: EdgeInsets.symmetric(horizontal: 30),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) {
                return Center(
                  child: LongPressDraggable(
                    onDragEnd: (detail) {
                      print(detail.offset);
                      positions.add(
                        WidgetPosition(
                          position: detail.offset,
                          child: _DragItem(color: Color(0xff25D366)),
                        ),
                      );
                      setState(() {});
                    },
                    feedback: Material(
                      child: _DragItem(color: Colors.grey),
                    ),
                    child: _DragItem(color: Colors.green),
                  ),
                );
              },
              separatorBuilder: (_, __) => SizedBox(width: 20),
            ),
          )
        ],
      ),
    );
  }
}

class _DragItem extends StatelessWidget {
  final Color color;

  const _DragItem({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        DottedBorder(
          color: Colors.black,
          child: SizedBox(height: 60, width: 60),
        ),
        Container(
          width: 63,
          height: 63,
          color: color,
          child: Center(
            child: Text('Комп'),
          ),
        )
      ],
    );
  }
}
