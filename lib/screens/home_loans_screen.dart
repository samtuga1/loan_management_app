import 'package:flutter/material.dart';
import 'package:loaner/widgets/loan_card.dart';
import 'package:provider/provider.dart';
import '../providers/loan.dart' as loans_provider;

class HomeLoansScreen extends StatelessWidget {
  static const routeName = '/home_screen';
  const HomeLoansScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 0.4),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 3, bottom: 3),
                        child: Icon(Icons.arrow_back_ios),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 22,
                  ),
                  const Text(
                    'Home Loans',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () =>
                    Provider.of<loans_provider.Loans>(context, listen: false)
                        .fetchHomeLoans(),
                child: FutureBuilder(
                  future:
                      Provider.of<loans_provider.Loans>(context, listen: false)
                          .fetchHomeLoans(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      return Consumer<loans_provider.Loans>(
                        builder: (context, loanData, _) => ListView.builder(
                          itemBuilder: (ctx, i) {
                            return LoanCard(
                              loanType: loanData.homeLoans[i].loanType,
                              maxAmount:
                                  loanData.homeLoans[i].maxAmount!.toDouble(),
                              interest:
                                  loanData.homeLoans[i].interest!.toDouble(),
                            );
                          },
                          itemCount: loanData.homeLoans.length,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
