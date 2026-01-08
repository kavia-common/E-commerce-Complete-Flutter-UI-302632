import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop/components/list_tile/divider_list_tile.dart';
import 'package:shop/components/network_image_with_loader.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/screen_export.dart';

import 'components/profile_card.dart';
import 'components/profile_menu_item_list_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  /// Holds the currently selected image for preview purposes only.
  /// No upload/persistence is implemented (per requirements).
  XFile? _selectedProfileImage;

  // PUBLIC_INTERFACE
  Future<void> pickProfileImage(ImageSource source) async {
    """Pick a profile image from the given [source] and store it in memory for preview.
    
    This function intentionally does not upload or persist the image anywhere.
    """
    // Note: image_picker may trigger platform permission prompts automatically.
    // We also add minimal platform permission stubs in Info.plist/AndroidManifest.
    try {
      final XFile? file = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );

      // After await: only update primitive/widget state; no context usage.
      if (file == null) {
        return;
      }

      setState(() {
        _selectedProfileImage = file;
      });
    } catch (_) {
      // Minimal error handling for permission denials or other picker errors.
      // Avoid showing SnackBars here to keep no-context-after-await discipline simple.
      // UI can remain unchanged if the picker fails.
    }
  }

  void _showPickImageSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('Choose from gallery'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    pickProfileImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: const Text('Take a photo'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    pickProfileImage(ImageSource.camera);
                  },
                ),
                if (_selectedProfileImage != null)
                  ListTile(
                    leading: const Icon(Icons.delete_outline),
                    title: const Text('Remove photo'),
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      setState(() {
                        _selectedProfileImage = null;
                      });
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatarPreview() {
    final Widget imageWidget;
    if (_selectedProfileImage != null) {
      imageWidget = Image.file(
        File(_selectedProfileImage!.path),
        fit: BoxFit.cover,
      );
    } else {
      imageWidget = const NetworkImageWithLoader('https://i.imgur.com/IXnwbLk.png');
    }

    return InkWell(
      onTap: _showPickImageSheet,
      borderRadius: BorderRadius.circular(48),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(48),
            child: SizedBox(
              width: 96,
              height: 96,
              child: imageWidget,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.edit,
                size: 16,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Keep the existing layout and menus, but replace the top ProfileCard with
    // an inline header that contains the tappable avatar/preview.
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              defaultPadding,
              defaultPadding * 2,
              defaultPadding,
              defaultPadding,
            ),
            child: Row(
              children: [
                _buildAvatarPreview(),
                const SizedBox(width: defaultPadding),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sepide',
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'theflutterway@gmail.com',
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: defaultPadding / 2),
                      SizedBox(
                        height: 36,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, userInfoScreenRoute);
                          },
                          child: const Text('Edit profile'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Keep existing promo/banner area
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding * 1.5,
            ),
            child: GestureDetector(
              onTap: () {},
              child: const AspectRatio(
                aspectRatio: 1.8,
                child: NetworkImageWithLoader('https://i.imgur.com/dz0BBom.png'),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Text(
              'Account',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          ProfileMenuListTile(
            text: 'Orders',
            svgSrc: 'assets/icons/Order.svg',
            press: () {
              Navigator.pushNamed(context, ordersScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: 'Returns',
            svgSrc: 'assets/icons/Return.svg',
            press: () {},
          ),
          ProfileMenuListTile(
            text: 'Wishlist',
            svgSrc: 'assets/icons/Wishlist.svg',
            press: () {},
          ),
          ProfileMenuListTile(
            text: 'Addresses',
            svgSrc: 'assets/icons/Address.svg',
            press: () {
              Navigator.pushNamed(context, addressesScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: 'Payment',
            svgSrc: 'assets/icons/card.svg',
            press: () {
              Navigator.pushNamed(context, emptyPaymentScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: 'Wallet',
            svgSrc: 'assets/icons/Wallet.svg',
            press: () {
              Navigator.pushNamed(context, walletScreenRoute);
            },
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding / 2,
            ),
            child: Text(
              'Personalization',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          DividerListTileWithTrilingText(
            svgSrc: 'assets/icons/Notification.svg',
            title: 'Notification',
            trilingText: 'Off',
            press: () {
              Navigator.pushNamed(context, enableNotificationScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: 'Preferences',
            svgSrc: 'assets/icons/Preferences.svg',
            press: () {
              Navigator.pushNamed(context, preferencesScreenRoute);
            },
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding / 2,
            ),
            child: Text(
              'Settings',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ProfileMenuListTile(
            text: 'Language',
            svgSrc: 'assets/icons/Language.svg',
            press: () {
              Navigator.pushNamed(context, selectLanguageScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: 'Location',
            svgSrc: 'assets/icons/Location.svg',
            press: () {},
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding / 2,
            ),
            child: Text(
              'Help & Support',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ProfileMenuListTile(
            text: 'Get Help',
            svgSrc: 'assets/icons/Help.svg',
            press: () {
              Navigator.pushNamed(context, getHelpScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: 'FAQ',
            svgSrc: 'assets/icons/FAQ.svg',
            press: () {},
            isShowDivider: false,
          ),
          const SizedBox(height: defaultPadding),

          // Log Out
          ListTile(
            onTap: () {},
            minLeadingWidth: 24,
            leading: SvgPicture.asset(
              'assets/icons/Logout.svg',
              height: 24,
              width: 24,
              colorFilter: const ColorFilter.mode(
                errorColor,
                BlendMode.srcIn,
              ),
            ),
            title: const Text(
              'Log Out',
              style: TextStyle(color: errorColor, fontSize: 14, height: 1),
            ),
          ),
        ],
      ),
    );
  }
}
