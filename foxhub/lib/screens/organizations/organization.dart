import 'package:flutter/material.dart';
import 'package:foxhub/widgets/appbar/customize_appbar.dart';
import 'package:foxhub/widgets/navbar/customize_navbar.dart';
import 'package:foxhub/widgets/cards/org_card.dart';
import '../../data/orgs_data.dart';
import 'package:foxhub/screens/organizations/organization_detail.dart';

class OrganizationScreen extends StatelessWidget {
  const OrganizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomizeAppBar(title: ''),
      drawer: buildAppDrawer(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orgs.length,
          itemBuilder: (context, index) {
            final org = orgs[index];
            return OrgCard(
              org: org,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrganizationDetailScreen(org: org),
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: const CustomizeNavBar(currentIndex: 1),
    );
  }
}
