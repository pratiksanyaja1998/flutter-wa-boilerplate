
import 'package:flutter/material.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';
import 'package:whitelabelapp/config.dart';

class AccommodationFilterModel extends StatefulWidget {
  const AccommodationFilterModel({
    Key? key,
    required this.apply,
    required this.cancelText,
    required this.cancel,
    required this.selectStartDate,
    required this.selectEndDate,
    required this.selectPriceRange,
    required this.startDate,
    required this.endDate,
    required this.lowToHigh,
    required this.selectLowToHigh,
    required this.highToLow,
    required this.selectHighToLow,
    required this.minPrice,
    required this.maxPrice,
  }) : super(key: key);

  final void Function()? apply;
  final String cancelText;
  final void Function()? cancel;
  final void Function()? selectStartDate;
  final void Function()? selectEndDate;
  final void Function(RangeValues)? selectPriceRange;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool lowToHigh;
  final void Function()? selectLowToHigh;
  final bool highToLow;
  final void Function()? selectHighToLow;
  final double minPrice;
  final double maxPrice;

  @override
  State<AccommodationFilterModel> createState() => _AccommodationFilterModelState();
}

class _AccommodationFilterModelState extends State<AccommodationFilterModel> {

  @override
  void didUpdateWidget(covariant AccommodationFilterModel oldWidget) {
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    setState(() {

    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: kPrimaryColor,
      ),
      child: Column(
        children: [
          const SizedBox(height: 20,),
          const Text(
            "Filter Date",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10,),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 6,
                          )
                        ],
                      ),
                      child: GestureDetector(
                        onTap: widget.selectStartDate,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.startDate != null ? widget.startDate.toString().split(" ")[0] : "Start date",
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today_rounded,
                              color: kThemeColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 6,
                          )
                        ],
                      ),
                      child: GestureDetector(
                        onTap: widget.selectEndDate,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.endDate != null ? widget.endDate.toString().split(" ")[0] : "Start date",
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const Icon(Icons.calendar_today_rounded, color: kThemeColor,),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30,),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Sort by price",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    RangeSlider(
                      values: RangeValues(widget.minPrice, widget.maxPrice),
                      min: 0,
                      max: 200,
                      labels: RangeLabels(widget.minPrice.toString(), widget.maxPrice.toString()),
                      activeColor: kThemeColor,
                      onChanged: widget.selectPriceRange,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          Text("Min: ${widget.minPrice}"),
                          const Expanded(child: Center(),),
                          Text("Max: ${widget.maxPrice}"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 6,
                          )
                        ],
                      ),
                      child: Material(
                        elevation: 0,
                        color: Colors.transparent,
                        child: ListTile(
                          leading: Checkbox(
                            value: widget.highToLow,
                            onChanged: null,
                            fillColor: MaterialStateProperty.all(kThemeColor),
                          ),
                          onTap: widget.selectHighToLow,
                          title: const Text(
                            "high to low",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          dense: true,
                          tileColor: kPrimaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Material(
                        elevation: 0,
                        color: Colors.transparent,
                        child: ListTile(
                          leading: Checkbox(
                            value: widget.lowToHigh,
                            onChanged: null,
                            fillColor: MaterialStateProperty.all(kThemeColor),
                          ),
                          onTap: widget.selectLowToHigh,
                          title: const Text(
                            "low to high",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          dense: true,
                          tileColor: kPrimaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0 , vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: Widgets().textButton(
                    onPressed: widget.cancel,
                    text: widget.cancelText,
                    style: const TextStyle(
                      fontSize: 20,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: Colors.blueGrey,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: Widgets().textButton(
                    onPressed: widget.apply,
                    text: "Apply",
                    fontSize: 20,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
