import 'package:flutter/material.dart';
import 'package:travelmate/Db/category_and_district_list/category_list.dart';
import 'package:travelmate/Db/category_and_district_list/district_list.dart';
import 'package:travelmate/repositories/destination_repository.dart';

// ignore: must_be_immutable
class CatogaryListMaker extends StatelessWidget {
  CatogaryListMaker({super.key, required this.list, required this.count});

  List list;
  int count;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: List.generate(
            count, (index) => ListMakerSearch(index: index, list: list)),
      ),
    );
  }
}

// ignore: must_be_immutable
class ListMakerSearch extends StatefulWidget {
  ListMakerSearch(
      {super.key,
      required this.index,
      this.selected = false,
      required this.list});
  int index;
  bool selected;
  List list;
  @override
  State<ListMakerSearch> createState() => _ListMakerSearchState();
}

class _ListMakerSearchState extends State<ListMakerSearch> {
  @override
  Widget build(BuildContext context) {
    return widget.list == categories
        ? InkWell(
            onTap: () {
              setState(() {
                widget.selected = widget.selected ? false : true;
                if (widget.selected) {
                  selectedCategoriesFB!.add(categories[widget.index][0]);
                } else {
                  selectedCategoriesFB!.remove(categories[widget.index][0]);
                }
              });
              // getFiltered();
              DestinationRepository().getfiltered();
            },
            child: Container(
              decoration: widget.selected
                  ? const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      color: Color.fromRGBO(88, 80, 36, 0.432),
                    )
                  : BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: const Color.fromARGB(129, 255, 255, 255),
                    ),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(6),
              child: Text(categories[widget.index][0]),
            ),
          )
        : InkWell(
            onTap: () {
              setState(() {
                widget.selected = widget.selected ? false : true;
                if (widget.selected) {
                  selectedDistrictsFB!.add(districts[widget.index]);
                } else {
                  selectedDistrictsFB!.remove(districts[widget.index]);
                }
              });
              // getFiltered();
              DestinationRepository().getfiltered();
            },
            child: Container(
              decoration: widget.selected
                  ? const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      color: Color.fromRGBO(88, 80, 36, 0.432),
                    )
                  : BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: const Color.fromARGB(129, 255, 255, 255),
                    ),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(6),
              child: Text(districts[widget.index]),
            ),
          );
  }
}
