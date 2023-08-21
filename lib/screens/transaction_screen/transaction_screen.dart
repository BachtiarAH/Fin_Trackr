import 'package:fin_trackr/constant/constant.dart';
import 'package:fin_trackr/db/functions/category_functions.dart';
import 'package:fin_trackr/db/functions/currency_function.dart';
import 'package:fin_trackr/db/functions/transaction_function.dart';
import 'package:fin_trackr/db/models/category/category_model_db.dart';
import 'package:fin_trackr/db/models/transactions/transaction_model_db.dart';
import 'package:fin_trackr/screens/accounts_screen/balance_calculation.dart';
import 'package:fin_trackr/screens/calculator/calculator_screen.dart';
import 'package:fin_trackr/screens/transaction_screen/all_transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  NumberFormat formatter = NumberFormat('#,##0.00');
  DateTimeRange selectedDate = DateTimeRange(
    start: DateTime(DateTime.now().year, DateTime.now().month),
    end: DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ),
  );
  @override
  void initState() {
    TransactionDB.instance.refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = 13;
    if (screenWidth > 350) {
      fontSize = 16;
    }
    TransactionDB.instance.getTransactionsForCurrentMonth();
    // TransactionDB.instance.refresh();
    CategoryDB.instance.getAllCategory();

    balanceAmount();
    getCurrency();

    double incomeData = 0;
    double expenseData = 0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.ftPrimaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.ftScafoldColor,
        elevation: 0,
        titleSpacing: 0.0,
        title: Row(
          children: [
            Row(
              children: [
                IconButton(
                  alignment: Alignment.centerRight,
                  icon: const Icon(Icons.arrow_back_ios,
                      color: AppColor.ftTextSecondayColor, size: 16),
                  onPressed: () {
                    setState(
                      () {
                        selectedDate = DateTimeRange(
                          start: DateTime(
                              DateTime.now().year, DateTime.now().month - 1, 1),
                          end: DateTime(
                              DateTime.now().year, DateTime.now().month, 0),
                        );
                      },
                    );
                    TransactionDB.instance
                        .filterForHome(selectedDate.start, selectedDate.end);
                    TransactionDB.instance.getTransactionsForCurrentMonth();
                  },
                ),
                SizedBox(
                  // width: 100,
                  child: TextButton(
                    onPressed: () async {
                      var daterange = DateTimeRange(
                        start:
                            DateTime(DateTime.now().year, DateTime.now().month),
                        end: DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                        ),
                      );
                      DateTimeRange? picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(DateTime.now().year - 1),
                          lastDate: DateTime.now(),
                          initialDateRange: daterange);
                      if (picked != null) {
                        TransactionDB.instance
                            .filterForHome(picked.start, picked.end);
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                      // TransactionDB.instance.refresh();
                      TransactionDB.instance.getTransactionsForCurrentMonth();
                    },
                    child: Text(
                      "${DateFormat('dd MMM').format(selectedDate.start)} - ${DateFormat('dd MMM').format(selectedDate.end)}",
                      style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: AppColor.ftTextSecondayColor),
                    ),
                  ),
                ),
                IconButton(
                  alignment: Alignment.centerLeft,
                  icon: const Icon(Icons.arrow_forward_ios,
                      color: AppColor.ftTextSecondayColor, size: 16),
                  onPressed: () {
                    setState(
                      () {
                        selectedDate = DateTimeRange(
                          start: DateTime(
                              DateTime.now().year, DateTime.now().month, 1),
                          end: DateTime(
                              DateTime.now().year, DateTime.now().month + 1, 0),
                        );
                      },
                    );
                    TransactionDB.instance.refresh();
                  },
                ),
              ],
            ),
            const Spacer(
              flex: 1,
            ),
            Row(
              children: [
                IconButton(
                  alignment: Alignment.centerRight,
                  icon: const Icon(Ionicons.swap_horizontal,
                      color: AppColor.ftTextSecondayColor, size: 18),
                  onPressed: () {
                    // Handle forward button press
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ViewAllScreen(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Ionicons.calculator,
                      color: AppColor.ftTextSecondayColor, size: 18),
                  onPressed: () {
                    // Handle forward button press
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CalculatorScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          //------------------------------------Income, Expense and Balance Preview --------------------------
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.04,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.ftTransactionColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: AppColor.ftShadowColor,
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.09,
                          width: MediaQuery.of(context).size.width * 0.41,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColor.ftIncomeColor,
                            boxShadow: const [
                              BoxShadow(
                                color: AppColor.ftShadowColor,
                                spreadRadius: 0,
                                blurRadius: 5,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          // --------------------------Income-------------------------
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Income',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColor.ftTextSecondayColor,
                                    fontSize:
                                        MediaQuery.of(context).size.width >= 300
                                            ? 15
                                            : MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.035,
                                  ),
                                ),
                              ),
                              ValueListenableBuilder(
                                valueListenable: incomenotifier,
                                builder: (context, value, child) {
                                  return FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5, top: 2),
                                      child: Text(
                                        formatter.format(incomeData),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: AppColor.ftTextSecondayColor,
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width >=
                                                  300
                                              ? 18
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.06,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),

                        //------------------------------Expense-------------------------

                        Container(
                          height: MediaQuery.of(context).size.height * 0.09,
                          width: MediaQuery.of(context).size.width * 0.41,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColor.ftExpenseColor,
                            boxShadow: const [
                              BoxShadow(
                                color: AppColor.ftShadowColor,
                                spreadRadius: 0,
                                blurRadius: 5,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Expense',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColor.ftTextSecondayColor,
                                    fontSize:
                                        MediaQuery.of(context).size.width >= 300
                                            ? 15
                                            : MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.035,
                                  ),
                                ),
                              ),
                              ValueListenableBuilder(
                                valueListenable: expensenotifier,
                                builder: (context, value, child) {
                                  return FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5, top: 2),
                                      child: Text(
                                        formatter.format(expenseData),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: AppColor.ftTextSecondayColor,
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width >=
                                                  300
                                              ? 18
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.06,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        // -------------------------------- Balance Start ----------------------------------------------
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LayoutBuilder(
                              builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                return FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Balance',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: AppColor.ftTextSecondayColor,
                                          fontSize: 20,
                                        ),
                                      ),
                                      ValueListenableBuilder(
                                        valueListenable: totalnotifier,
                                        builder: (context, value, child) {
                                          return Text(
                                            '${currencySymboleUpdate.value} ${formatter.format(incomeData - expenseData)}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  AppColor.ftTextSecondayColor,
                                              fontSize: 35,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    //------------------------------------Income, Expense and Balance Preview End --------------------------
                  ],
                ),
              ),
            ),
          ),
          // ----------------------------------- Transaction History ----------------------------------------
          ValueListenableBuilder(
            valueListenable:
                TransactionDB.instance.transactionMonthListNotifier,
            builder: (context, newList, child) {
              Map<String, List<TransactionModel>> mapList = sortByDate(newList);
              if (mapList.isEmpty) {
                incomeData = 0;
                expenseData = 0;
              }
              List<String> keys = mapList.keys.toList();
              return keys.isNotEmpty
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 9),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: keys.length,
                          itemBuilder: (context, index) {
                            List<TransactionModel> calculationList =
                                mapList[keys[index]]!;
                            double incomeDataForDay = calculationList.fold(0,
                                (previousValue, transaction) {
                              if (transaction.categoryType ==
                                  CategoryType.income) {
                                return previousValue + transaction.amount;
                              }
                              return previousValue;
                            });
                            double expenseDataForDay = calculationList.fold(0,
                                (previousValue, transaction) {
                              if (transaction.categoryType ==
                                  CategoryType.expense) {
                                previousValue += transaction.amount;
                              }
                              return previousValue;
                            });

                            incomeData = mapList.values.fold(0,
                                (previousValue, element) {
                              for (var transaction in element) {
                                if (transaction.categoryType ==
                                    CategoryType.income) {
                                  previousValue += transaction.amount;
                                }
                              }
                              return previousValue;
                            });

                            expenseData = mapList.values.fold(0,
                                (previousValue, element) {
                              for (var transaction in element) {
                                if (transaction.categoryType ==
                                    CategoryType.expense) {
                                  previousValue += transaction.amount;
                                }
                              }
                              return previousValue;
                            });

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
                                            left: 10, right: 10, top: 10),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 65,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: AppColor
                                                        .ftTextLinkColor2,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      DateFormat('dd ')
                                                              .format(DateTime
                                                                  .parse(keys[
                                                                      index]))
                                                              .toString() +
                                                          DateFormat('EEE')
                                                              .format(DateTime
                                                                  .parse(keys[
                                                                      index]))
                                                              .toString(),
                                                      style: const TextStyle(
                                                          color: AppColor
                                                              .ftTextSecondayColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Text(
                                                    DateFormat('MM.yyyy')
                                                        .format(DateTime.parse(
                                                            keys[index]))
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: AppColor
                                                            .ftTextTertiaryColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                const Spacer(),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '+ ${currencySymboleUpdate.value} ${formatter.format(incomeDataForDay)}',
                                                      style: const TextStyle(
                                                          color: AppColor
                                                              .ftTextIncomeColor,
                                                          fontSize: 13),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      '- ${currencySymboleUpdate.value} ${formatter.format(expenseDataForDay)}',
                                                      style: const TextStyle(
                                                          color: AppColor
                                                              .ftTextExpenseColor,
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const Divider(
                                              color: AppColor
                                                  .ftSecondaryDividerColor,
                                              thickness: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: TransactionsCategory(
                                            newList: mapList[keys[index]]!),
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
                        children: [
                          // const SizedBox(
                          //   height: 60,
                          // ),
                          SizedBox(
                            width: 150,
                            child: Lottie.asset('assets/noSearch.json'),
                          ),
                          const Text(
                            "No data available..!",
                            style: TextStyle(
                                fontSize: 15,
                                color: AppColor.ftTextTertiaryColor),
                          ),
                        ],
                      ),
                    );
            },
          ),
          // ----------------------------------- Transaction History End----------------------------------------
        ],
      ),
    );
  }

  Map<String, List<TransactionModel>> sortByDate(
      List<TransactionModel> models) {
    Map<String, List<TransactionModel>> mapList = {};
    for (TransactionModel model in models) {
      if (!mapList.containsKey(model.date)) {
        mapList[model.date] = [];
      }
      mapList[model.date]!.add(model);
    }
    return mapList;
  }
}
