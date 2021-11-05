import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';

class TinyTiger extends StatefulWidget {
  @override
  _TinyTigerState createState() => _TinyTigerState();
}

class _TinyTigerState extends State<TinyTiger> {
  ArCoreController arCoreController;
  String objectSelected = "Tiger.sfb";

  void whenArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onNodeTap = (name) => removeObject(name);
    arCoreController.onPlaneTap = handledOnPlaneTap;
  }

  void handledOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    addObject(hit);
  }

  void removeObject(String name) {
    showDialog(
        context: context,
        builder: (BuildContext c) => AlertDialog(
              content: Row(
                children: <Widget>[
                  Text('Remove ' + name),
                  IconButton(
                    onPressed: () {
                      arCoreController.removeNode(nodeName: name);
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            ));
  }

  void addObject(ArCoreHitTestResult plane) {
    if (objectSelected != null) {
      final objectNode = ArCoreReferenceNode(
        name: objectSelected,
        object3DFileName: objectSelected,
        position: plane.translation,
        rotation: plane.pose.rotation,
      );
      arCoreController.addArCoreNodeWithAnchor(objectNode);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext c) => AlertDialog(
                content: Text('Select an Image.'),
              ));
    }
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ArCoreView(
          onArCoreViewCreated: whenArCoreViewCreated,
          enableTapRecognizer: true,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: ListObjectSelection(
            onTap: (value) {
              objectSelected = value;
            },
          ),
        ),
      ],
    );
  }
}

// ui
class ListObjectSelection extends StatefulWidget {
  final Function onTap;

  ListObjectSelection({this.onTap});

  @override
  _ListObjectSelectionState createState() => _ListObjectSelectionState();
}

class _ListObjectSelectionState extends State<ListObjectSelection> {
  List<String> gifs = [
    "assets/ku.png",
  ];

  List<String> objectFileName = [
    "Tiger.sfb",
  ];

  String selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: ListView.builder(
        itemCount: gifs.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selected = gifs[index];
                widget.onTap(objectFileName[index]);
              });
            },
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Container(
                color:
                    selected == gifs[index] ? Colors.red : Colors.transparent,
                padding: selected == gifs[index] ? EdgeInsets.all(8.0) : null,
                child: Image.asset(gifs[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
