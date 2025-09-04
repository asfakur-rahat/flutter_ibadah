import 'package:flutter/material.dart';
import 'package:flutter_ibadah/src/presentation/widgets/med_easy_searchbar.dart';
import '../../../flutter_ibadah.dart';

class DistrictSelectionBottomSheet extends StatefulWidget {
  final Function(String)? onSelect;
  final IbadahTheme ibadahTheme;
  final String searchHintText;

  const DistrictSelectionBottomSheet({
    super.key,
    this.onSelect,
    required this.ibadahTheme,
    required this.searchHintText,
  });

  @override
  State<DistrictSelectionBottomSheet> createState() =>
      _DistrictSelectionBottomSheetState();
}

class _DistrictSelectionBottomSheetState
    extends State<DistrictSelectionBottomSheet> {
  final ValueNotifier<List<String>> districtList = ValueNotifier(districts);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MedEasySearchbar(
            ibadahTheme: widget.ibadahTheme,
            hintText: widget.searchHintText,
            horizontalPadding: 16,
            topPadding: 8,
            onSearchQueryChanged: (query){
              districtList.value = List.from(
                districts.where((e) => e.toLowerCase().contains(query.toLowerCase()))
              );
            },
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * .25,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ValueListenableBuilder(
                valueListenable: districtList,
                builder: (_, list, __) {
                  return ListView.separated(
                    itemCount: list.length,
                    itemBuilder: (_, int index) {
                      return ListTile(
                        title: Text(list[index]),
                        titleAlignment: ListTileTitleAlignment.center,
                        onTap: (){
                          if(widget.onSelect != null){
                            widget.onSelect!(list[index]);
                          }
                        },
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

const List<String> districts = [
  "Bagerhat",
  "Bandarban",
  "Barguna",
  "Barisal",
  "Bhola",
  "Bogura",
  "Brahmanbaria",
  "Chandpur",
  "Chapai Nawabganj",
  "Chattogram",
  "Chuadanga",
  "Cox's Bazar",
  "Cumilla",
  "Dhaka",
  "Dinajpur",
  "Faridpur",
  "Feni",
  "Gaibandha",
  "Gazipur",
  "Gopalganj",
  "Habiganj",
  "Jamalpur",
  "Jashore",
  "Jhalokathi",
  "Jhenaidah",
  "Joypurhat",
  "Khagrachari",
  "Khulna",
  "Kishoreganj",
  "Kurigram",
  "Kushtia",
  "Lakshmipur",
  "Lalmonirhat",
  "Madaripur",
  "Magura",
  "Manikganj",
  "Meherpur",
  "Moulvibazar",
  "Munshiganj",
  "Mymensingh",
  "Naogaon",
  "Narail",
  "Narayanganj",
  "Narsingdi",
  "Natore",
  "Netrokona",
  "Nilphamari",
  "Noakhali",
  "Pabna",
  "Panchagarh",
  "Patuakhali",
  "Pirojpur",
  "Rajbari",
  "Rajshahi",
  "Rangamati",
  "Rangpur",
  "Satkhira",
  "Shariatpur",
  "Sherpur",
  "Sirajganj",
  "Sunamganj",
  "Sylhet",
  "Tangail",
  "Thakurgaon",
];