import 'package:flutter/material.dart';
import 'package:portfolio/constants/constants.dart';
import 'package:portfolio/github/data/github_data.dart';

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  String? _userImageUrl;
  final ValueNotifier<String?> _errorMessage = ValueNotifier(null);
  final GitHubAPI _gitHubAPI =
      GitHubAPI(Constants.githubUsername, token: Constants.githubToken);

  @override
  void initState() {
    super.initState();
    _fetchUserImage();
  }

  Future<void> _fetchUserImage() async {
    _isLoading.value = true;
    try {
      final imageUrl = await _gitHubAPI.fetchUserAvatarUrl();
      _userImageUrl = imageUrl;
    } catch (e) {
      _errorMessage.value = 'Failed to load user image: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: StylingConstants.profileSectionHeight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool isWide = constraints.maxWidth > 600;
            List<Widget> children = [
              const Spacer(),
              // Image and details go here
              Expanded(child: _buildImageSection()),
              const Spacer(),
              Expanded(flex: 4, child: _buildDetailsSection()),
              const Spacer(),
            ];

            return isWide
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children)
                : Column(children: children);
          },
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    // Build the image section here, using ValueListenableBuilder for _userImageUrl
    return ValueListenableBuilder<bool>(
      valueListenable: _isLoading,
      builder: (context, isLoading, _) {
        if (_errorMessage.value != null) {
          return Text(_errorMessage.value!);
        }
        return _userImageUrl != null
            ? ClipOval(
                child: Image.network(_userImageUrl!, fit: BoxFit.scaleDown))
            : const CircleAvatar(
                radius: 60,
                child: Icon(Icons.person,
                    size: 120)); // Placeholder for loading/error
      },
    );
  }

  Widget _buildDetailsSection() {
    // Build the details section here
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(Constants.profileName,
            style: Theme.of(context).textTheme.titleLarge),
        ...Constants.profile.map((detail) => Text(detail)),
      ],
    );
  }

  @override
  void dispose() {
    _isLoading.dispose();
    _errorMessage.dispose();
    super.dispose();
  }
}
