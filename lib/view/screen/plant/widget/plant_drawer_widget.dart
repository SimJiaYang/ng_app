import 'package:flutter/material.dart';
import 'package:nurserygardenapp/util/color_resources.dart';

class PlantDrawerWidget extends StatefulWidget {
  const PlantDrawerWidget({
    super.key,
    required this.size,
    required this.closeEndDrawer,
    required this.paramCallback,
    required this.sort,
  });

  final Size size;
  final VoidCallback closeEndDrawer;
  final Function(dynamic) paramCallback;
  final String sort;

  @override
  State<PlantDrawerWidget> createState() => _PlantDrawerWidgetState();
}

class _PlantDrawerWidgetState extends State<PlantDrawerWidget> {
  String _sortOrder = "";
  String category = "";

  void _handleSubmission() {
    var params = {'sortOrder': _sortOrder, 'category': category};
    widget.paramCallback(params);
    widget.closeEndDrawer();
  }

  void _handleReset() {
    var params = {'sortOrder': "", 'category': ""};
    widget.paramCallback(params);
    widget.closeEndDrawer();
  }

  void setSortBy(String sortBy) {
    this._sortOrder = sortBy;
  }

  void setCategory(String category) {
    this.category = category;
  }

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  _loadState() {
    setState(() {
      _sortOrder = widget.sort;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width * 0.70,
      child: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(0), bottomRight: Radius.circular(0)),
          ),
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                'Plant Search Filter',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.7), fontSize: 16),
              ),
            ),
            body: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: ColorResources.COLOR_GREY.withOpacity(0.3),
                      width: 0.5,
                    ))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sort Order',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            DrawerItem(
                                isSelected: _sortOrder == 'asc',
                                keyword: "asc",
                                onTap: (asc) {
                                  setSortBy(asc);
                                },
                                title: 'Asc'),
                            SizedBox(
                              width: 10,
                            ),
                            DrawerItem(
                                isSelected: _sortOrder == 'desc',
                                keyword: "desc",
                                onTap: (desc) {
                                  setSortBy(desc);
                                },
                                title: 'Desc'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              _handleSubmission();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                // border: Border.all(width: 1),
                              ),
                              child: Center(child: Text('Apply')),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              _handleReset();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                // border: Border.all(width: 1),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Center(child: Text('RESET')),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class DrawerItem extends StatefulWidget {
  const DrawerItem({
    super.key,
    required this.onTap,
    required this.title,
    required this.keyword,
    this.isSelected = false,
  });

  final Function(String args) onTap;
  final String title;
  final String keyword;
  final bool isSelected;

  @override
  State<DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isSelected = widget.isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          // setState(() {
          //   isSelected = !isSelected;
          // });
          widget.onTap(widget.keyword);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.grey.withOpacity(0.2),
            border: isSelected
                ? Border.all(width: 1, color: ColorResources.COLOR_PRIMARY)
                : Border.all(width: 1, color: ColorResources.COLOR_WHITE),
          ),
          child: Center(child: Text(widget.title)),
        ),
      ),
    );
  }
}
