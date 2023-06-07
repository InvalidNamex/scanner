// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../constants.dart';
//
// class SearchWidget extends StatefulWidget {
//   const SearchWidget({super.key});
//
//   @override
//   _SearchWidgetState createState() => _SearchWidgetState();
// }
//
// class _SearchWidgetState extends State<SearchWidget> {
//   @override
//   Widget build(BuildContext context) {
//     searchController.getItems();
//     return Scaffold(
//       appBar: AppBar(
//         leading: searchController.isSearching.value
//             ? const BackButton(
//                 color: Colors.blue,
//               )
//             : Container(),
//         title: searchController.isSearching.value
//             ? _buildSearchField()
//             : _buildAppBarTitle(),
//         actions: _buildAppBarActions(),
//       ),
//       body: ListView.separated(
//           itemBuilder: (context, index) => listTile(index),
//           separatorBuilder: (context, index) => const SizedBox(
//                 height: 10,
//               ),
//           itemCount: searchController.searchedProductsList.length),
//     );
//   }
//
//   Widget _buildSearchField() {
//     return TextField(
//       autofocus: true,
//       controller: searchController.searchTextController,
//       cursorColor: Colors.blue,
//       decoration: InputDecoration(
//         hintText: 'بحث',
//         border: InputBorder.none,
//       ),
//       onChanged: (searchedProduct) {
//         addSearchedForItemsToSearchedList(searchedProduct);
//       },
//     );
//   }
//
//   addSearchedForItemsToSearchedList(String searchedProduct) {
//     setState(() {
//       searchController.searchedProductsList = searchController.productsList
//           .where((character) =>
//               character.fileTitle!.toLowerCase().contains(searchedProduct))
//           .toList();
//     });
//   }
//
//   List<Widget> _buildAppBarActions() {
//     if (searchController.isSearching.value) {
//       return [
//         IconButton(
//             onPressed: () {
//               _clearSearch();
//               Navigator.pop(context);
//             },
//             icon: const Icon(
//               Icons.clear,
//               color: Colors.blue,
//             ))
//       ];
//     } else {
//       return [
//         IconButton(
//             onPressed: _startSearch,
//             icon: const Icon(
//               Icons.search,
//               color: Colors.blue,
//             ))
//       ];
//     }
//   }
//
//   Widget _buildAppBarTitle() {
//     return GestureDetector(
//       onTap: _startSearch,
//       child: const Text('Search your favourite products'),
//     );
//   }
//
//   _startSearch() {
//     ModalRoute.of(context)
//         ?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
//     setState(() {
//       searchController.isSearching(true);
//     });
//   }
//
//   _stopSearching() {
//     setState(() {
//       _clearSearch();
//       searchController.isSearching(false);
//     });
//   }
//
//   _clearSearch() {
//     setState(() {
//       searchController.searchTextController.clear();
//     });
//   }
//
//   Widget listTile(index) {
//     return Container(
//       decoration: BoxDecoration(
//           border: Border.all(color: Colors.blue),
//           borderRadius: BorderRadius.circular(20)),
//       child: ListTile(
//           leading: Text(
//               '${searchController.searchedProductsList[index].counterCode}'),
//           title: Text(
//               '${searchController.searchedProductsList[index].fileTitle}')),
//     );
//   }
// }
