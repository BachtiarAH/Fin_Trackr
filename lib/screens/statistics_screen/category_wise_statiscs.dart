import 'package:fin_trackr/constant/constant.dart';
import 'package:fin_trackr/db/functions/currency_function.dart';
import 'package:fin_trackr/db/functions/transaction_function.dart';
import 'package:fin_trackr/models/statistics/statistics_model.db.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';

class CategoryWiseStatistics extends StatefulWidget {
  const CategoryWiseStatistics({super.key});

  @override
  State<CategoryWiseStatistics> createState() => _CategoryWiseStatisticsState();
}

class _CategoryWiseStatisticsState extends State<CategoryWiseStatistics> {
  ValueNotifier<bool> searchBarNotifier = ValueNotifier<bool>(false);
  var clearcontroller = TextEditingController();
  NumberFormat formatter = NumberFormat('#,##0.00');

  @override
  void initState() {
    // TransactionDB.instance.refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.ftScafoldColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.ftScafoldColor,
        title: const Text(
          'Category Wise Report',
          style: TextStyle(fontSize: 17),
        ),
        actions: [
          IconButton(
              alignment: Alignment.centerRight,
              onPressed: () {
                showPopupMenu1();
              },
              icon: const Icon(Icons.sort_rounded)),
          IconButton(
              alignment: Alignment.centerLeft,
              onPressed: () {
                showPopupMenu2();
              },
              icon: const Icon(Ionicons.calendar_outline, size: 22)),
        ],
      ),
      body: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.ftTransactionColor,
                    boxShadow: const [
                      BoxShadow(
                        color: AppColor.ftShadowColor,
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: searchBarNotifier,
                    builder: (context, boolValue, child) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              TextField(
                                controller: clearcontroller,
                                onChanged: (value) {
                                  TransactionDB.instance.search(value);

                                  if (value.isEmpty) {
                                    searchBarNotifier.value = false;
                                    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                                    searchBarNotifier.notifyListeners();
                                  } else {
                                    searchBarNotifier.value = true;
                                    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                                    searchBarNotifier.notifyListeners();
                                  }
                                },
                                cursorColor: AppColor.ftTextSecondayColor,
                                style: const TextStyle(
                                    color: AppColor.ftTextSecondayColor),
                                decoration: InputDecoration(
                                  suffixIcon: searchBarNotifier.value == false
                                      ? const Icon(Ionicons.search_outline)
                                      : null,
                                  suffixIconColor:
                                      AppColor.ftTabBarSelectorColor,
                                  hintText: 'Search by category name',
                                  hintStyle: const TextStyle(
                                      color: AppColor.ftTextTertiaryColor),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor.ftSecondaryDividerColor,
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: searchBarNotifier.value,
                                child: IconButton(
                                  onPressed: () {
                                    clearcontroller.clear();
                                    setState(() {
                                      searchBarNotifier.value = false;
                                    });
                                  },
                                  icon: const Icon(
                                    Ionicons.close_circle_outline,
                                    color: AppColor.ftTabBarSelectorColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          ValueListenableBuilder(
            valueListenable: TransactionDB.instance.transactionListNotifier,
            builder: (context, newList, child) {
              List<ChartDatas> newData = chartLogic(newList);
              return newData.isNotEmpty
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 9),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: newData.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.04,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColor.ftTransactionColor,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: AppColor.ftShadowColor,
                                        spreadRadius: 0,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 10,
                                            bottom: 10),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: AppColor
                                                        .ftTextLinkColor2,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(5),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      newData[index]
                                                          .categoryType
                                                          .toString()
                                                          .toUpperCase()
                                                          .substring(0, 3),
                                                      style: const TextStyle(
                                                        color: AppColor
                                                            .ftTextSecondayColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Text(
                                                    newData[index]
                                                        .category
                                                        .toString(),
                                                    style: const TextStyle(
                                                      color: AppColor
                                                          .ftTextTertiaryColor,
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${currencySymboleUpdate.value} ${formatter.format(newData[index].amount)}',
                                                    style: const TextStyle(
                                                      color: AppColor
                                                          .ftTextSecondayColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 120,
                          ),
                          Container(
                            alignment: Alignment.center,
                          ),
                          SizedBox(
                            width: 180,
                            child: Lottie.asset(
                              'assets/nodata.json',
                            ),
                          ),
                          const Text(
                            "No transactions yet !",
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColor.ftTextTertiaryColor,
                            ),
                          ),
                        ],
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }

  void showPopupMenu1() async {
    await showMenu(
      color: AppColor.ftAppBarColor,
      context: context,
      position: const RelativeRect.fromLTRB(100, 80, 10, 10),
      items: [
        PopupMenuItem(
            onTap: () {
              TransactionDB.instance.filter('All');
              TransactionDB.instance.refresh();
            },
            child: const Text(
              'All',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.ftTextSecondayColor),
            )),
        PopupMenuItem(
            onTap: () {
              TransactionDB.instance.filter('Income');
            },
            child: const Text(
              'Income',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.ftTextSecondayColor),
            )),
        PopupMenuItem(
            onTap: () {
              TransactionDB.instance.filter('Expense');
            },
            child: const Text(
              'Expense',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.ftTextSecondayColor),
            )),
      ],
      elevation: 8.0,
    );
  }

  void showPopupMenu2() async {
    await showMenu(
      color: AppColor.ftAppBarColor,
      context: context,
      position: const RelativeRect.fromLTRB(100, 80, 10, 10),
      items: [
        PopupMenuItem(
            onTap: () {
              TransactionDB.instance.filterDataByDate('all');
            },
            child: const Text(
              'All',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.ftTextSecondayColor),
            )),
        PopupMenuItem(
            onTap: () {
              TransactionDB.instance.filterDataByDate('today');
            },
            child: const Text(
              'Today',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.ftTextSecondayColor),
            )),
        PopupMenuItem(
            onTap: () {
              TransactionDB.instance.filterDataByDate('yesterday');
            },
            child: const Text(
              'Yesterday',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.ftTextSecondayColor),
            )),
        PopupMenuItem(
            onTap: () {
              TransactionDB.instance.filterDataByDate('last week');
            },
            child: const Text(
              'Last Week',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.ftTextSecondayColor),
            )),
        PopupMenuItem(
          onTap: () async {
            var daterange = DateTimeRange(
              start: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day - 30),
              end: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day),
            );
            DateTimeRange? picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(DateTime.now().year - 1),
                lastDate: DateTime.now(),
                initialDateRange: daterange);
            if (picked != null) {
              TransactionDB.instance.filterByDate(picked.start, picked.end);
            }
          },
          child: const Text(
            'Custom Date',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColor.ftTextSecondayColor),
          ),
        ),
      ],
      elevation: 8.0,
    );
  }
}
