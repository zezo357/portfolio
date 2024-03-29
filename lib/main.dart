// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meta_seo/meta_seo.dart';
import 'package:portfolio/github/utils.dart';
import 'package:simple_icons/simple_icons.dart';

import 'package:portfolio/constants/constants.dart';
import 'package:portfolio/constants/view/course_card.dart';
import 'package:portfolio/constants/view/education_card.dart';
import 'package:portfolio/constants/view/experience_card.dart';
import 'package:portfolio/constants/view/profile_section.dart';
import 'package:portfolio/constants/view/skills_card.dart';
import 'package:portfolio/github/view/pull_requests/pull_requests_on_public_repos.dart';
import 'package:portfolio/github/view/repos/repositories_list.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  // It is required to add the following to run the meta_seo package correctly
  // before the running of the Flutter app
  if (kIsWeb) {
    MetaSEO().config();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme(bool isOn) {
    setState(() {
      _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // Define MetaSEO object
      MetaSEO meta = MetaSEO();
      // add meta seo data for web app as you want
      meta.author(author: Constants.profileName);
      meta.description(
          description:
              "Portfolio of ${Constants.profileName} using Flutter, showcasing my skills and projects");
      meta.keywords(keywords: 'Flutter, Dart, SEO, Meta, Web, Portfolio');
    }
    return MaterialApp(
        title: 'Portfolio',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.dark, seedColor: Colors.blue),
          useMaterial3: true,
        ),
        themeMode: _themeMode,
        home: Home(
          toggleTheme: _toggleTheme,
        ));
  }
}

class Home extends StatelessWidget {
  final void Function(bool) toggleTheme;
  const Home({
    super.key,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
        actions: [
          IconButton(
            icon: Icon(SimpleIcons.gmail,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : SimpleIconColors.gmail),
            onPressed: () async {
              final emailUri = Uri.parse('mailto:${Constants.email}');
              if (await canLaunchUrl(emailUri)) {
                await launchUrl(emailUri);
              } else {
                print('Could not launch $emailUri');
              }
            },
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            icon: Icon(SimpleIcons.linkedin,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : SimpleIconColors.linkedin),
            onPressed: () async {
              Uri url = Uri.parse(Constants.linkedInUrl!);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                print('Could not launch ${Constants.linkedInUrl}');
              }
            },
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            icon: Icon(SimpleIcons.github,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : SimpleIconColors.github),
            onPressed: () async {
              final githubUrl =
                  Uri.parse('https://github.com/${Constants.githubUsername}');
              if (await canLaunchUrl(githubUrl)) {
                await launchUrl(githubUrl);
              } else {
                print('Could not launch $githubUrl');
              }
            },
          ),
          const SizedBox(
            width: 10,
          ),
          Switch(
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: toggleTheme,
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: isPortrait(context) ? 10 : 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ProfileSection(),
              StaggeredGrid.count(
                crossAxisCount: isPortrait(context) ? 1 : 2,
                // childAspectRatio: (MediaQuery.of(context).size.width / 2) / 300,
                children: [
                  CourseCard(courses: Constants.courses),
                  SkillsCard(skills: Constants.skills),
                  ExperienceCard(experiences: Constants.experience),
                  EducationCard(educations: Constants.education),
                ],
              ),
              const PullRequestsOnPublicRepos(
                cardWidth: StylingConstants.cardsWidth,
              ), // Uncomment if these are to be included
              const RepositoriesList(
                cardWidth: StylingConstants.cardsWidth,
              ), // Adjust layout or wrap with a fixed height Container if necessary
            ],
          ),
        ),
      ),
    );
  }
}
