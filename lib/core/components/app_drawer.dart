// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:exchange_customer/core/components/app_snackbar.dart';
// import 'package:exchange_customer/core/constants/colors.dart';
// import 'package:exchange_customer/core/constants/images.dart';

// class AppDrawer extends StatefulWidget {
//   const AppDrawer({super.key});

//   @override
//   State<AppDrawer> createState() => _AppDrawerState();
// }

// class _AppDrawerState extends State<AppDrawer> with TickerProviderStateMixin {
//   late AnimationController _headerController;
//   late AnimationController _itemsController;
//   late Animation<double> _headerFadeAnimation;
//   late Animation<Offset> _headerSlideAnimation;
//   late List<Animation<Offset>> _itemSlideAnimations;
//   late List<Animation<double>> _itemFadeAnimations;

//   // final List<_DrawerMenuItem> _menuItems = [
//   //   _DrawerMenuItem(
//   //     icon: Icons.person_outline_rounded,
//   //     title: 'profile',
//   //     route: AccountInfoScreen.id,
//   //   ),
//   //   _DrawerMenuItem(
//   //     icon: Icons.favorite_border_rounded,
//   //     title: 'favorite_accounts',
//   //     route: FavoriteAccountsScreen.id,
//   //   ),
//   //   _DrawerMenuItem(
//   //     icon: Icons.credit_card_rounded,
//   //     title: 'generate_card',
//   //     route: null,
//   //     comingSoon: true,
//   //   ),

//   //   _DrawerMenuItem(
//   //     icon: Icons.headset_mic_outlined,
//   //     title: 'contact_us',
//   //     route: ContactUsScreen.id,
//   //   ),
//   // ];

//   @override
//   void initState() {
//     super.initState();
//     _initAnimations();
//   }

//   void _initAnimations() {
//     // Header animation
//     _headerController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
//     _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _headerController,
//         curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
//       ),
//     );
//     _headerSlideAnimation =
//         Tween<Offset>(begin: const Offset(-0.3, 0), end: Offset.zero).animate(
//           CurvedAnimation(
//             parent: _headerController,
//             curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
//           ),
//         );

//     // Items animation
//     _itemsController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );

//     _itemSlideAnimations = List.generate(_menuItems.length, (index) {
//       final startInterval = index * 0.1;
//       final endInterval = startInterval + 0.4;
//       return Tween<Offset>(
//         begin: const Offset(-0.5, 0),
//         end: Offset.zero,
//       ).animate(
//         CurvedAnimation(
//           parent: _itemsController,
//           curve: Interval(
//             startInterval.clamp(0.0, 1.0),
//             endInterval.clamp(0.0, 1.0),
//             curve: Curves.easeOutCubic,
//           ),
//         ),
//       );
//     });

//     _itemFadeAnimations = List.generate(_menuItems.length, (index) {
//       final startInterval = index * 0.1;
//       final endInterval = startInterval + 0.4;
//       return Tween<double>(begin: 0.0, end: 1.0).animate(
//         CurvedAnimation(
//           parent: _itemsController,
//           curve: Interval(
//             startInterval.clamp(0.0, 1.0),
//             endInterval.clamp(0.0, 1.0),
//             curve: Curves.easeOut,
//           ),
//         ),
//       );
//     });

//     // Start animations
//     _headerController.forward();
//     Future.delayed(const Duration(milliseconds: 200), () {
//       _itemsController.forward();
//     });
//   }

//   @override
//   void dispose() {
//     _headerController.dispose();
//     _itemsController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Drawer(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: isDark
//                 ? [
//                     AppColors.kPrimaryColorDarkMode,
//                     AppColors.kSecondColorDarkMode,
//                   ]
//                 : [
//                     AppColors.kWhiteColor,
//                     AppColors.kPrimaryColor.withOpacity(0.05),
//                   ],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               // Header Section
//               _buildHeader(isDark),
//               SizedBox(height: 16.h),
//               // Menu Items
//               Expanded(child: _buildMenuItems(isDark)),
//               // Footer with Logout
//               _buildFooter(isDark),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(bool isDark) {
//     return SlideTransition(
//       position: _headerSlideAnimation,
//       child: FadeTransition(
//         opacity: _headerFadeAnimation,
//         child: Container(
//           margin: EdgeInsets.all(16.r),
//           padding: EdgeInsets.all(16.r),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 AppColors.kPrimaryColor,
//                 AppColors.kPrimaryColor.withOpacity(0.8),
//               ],
//             ),
//             borderRadius: BorderRadius.circular(20.r),
//             boxShadow: [
//               BoxShadow(
//                 color: AppColors.kPrimaryColor.withOpacity(0.3),
//                 blurRadius: 15,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   // Profile Image
//                   Container(
//                     padding: EdgeInsets.all(3.r),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: AppColors.kWhiteColor,
//                         width: 2,
//                       ),
//                     ),
//                     child: ClipOval(
//                       child: CachedNetworkImage(
//                         imageUrl: UserSession.image ?? "",
//                         width: 60.w,
//                         height: 60.h,
//                         fit: BoxFit.cover,
//                         placeholder: (context, url) => Container(
//                           color: AppColors.kWhiteColor.withOpacity(0.3),
//                           child: Icon(
//                             Icons.person_rounded,
//                             size: 30.sp,
//                             color: AppColors.kWhiteColor,
//                           ),
//                         ),
//                         errorWidget: (context, url, error) => Container(
//                           color: AppColors.kWhiteColor.withOpacity(0.3),
//                           child: Icon(
//                             Icons.person_rounded,
//                             size: 30.sp,
//                             color: AppColorss.kWhiteColor,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 12.w),
//                   // User Info
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "${UserSession.firstName ?? ""} ${UserSession.lastName ?? ""}",
//                           style: TextStyle(
//                             fontSize: 16.sp,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: 'Cairo-Bold',
//                             color: AppColors.kWhiteColor,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         SizedBox(height: 8.h),
//                         AppText(
//                           UserSession.email ?? "",
//                           color: AppColors.kWhiteColor.withOpacity(0.8),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               // Edit Profile Button
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuItems(bool isDark) {
//     return ListView.builder(
//       padding: EdgeInsets.symmetric(horizontal: 12.w),
//       physics: const BouncingScrollPhysics(),
//       itemCount: _menuItems.length,
//       itemBuilder: (context, index) {
//         return SlideTransition(
//           position: _itemSlideAnimations[index],
//           child: FadeTransition(
//             opacity: _itemFadeAnimations[index],
//             child: _buildMenuItem(_menuItems[index], isDark),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildMenuItem(_DrawerMenuItem item, bool isDark) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4.h),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () {
//             Navigator.pop(context);
//             if (item.comingSoon) {
//               AppSnackbar.showInfo(context, "soon".tr);
//             } else if (item.route != null) {
//               Get.toNamed(item.route!);
//             }
//           },
//           borderRadius: BorderRadius.circular(14.r),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
//             decoration: BoxDecoration(
//               color: isDark
//                   ? AppColors.kThirtColorDarkMode.withOpacity(0.3)
//                   : AppColors.kPrimaryColor.withOpacity(0.05),
//               borderRadius: BorderRadius.circular(14.r),
//               border: Border.all(
//                 color: isDark
//                     ? AppColors.kThirtColorDarkMode.withOpacity(0.5)
//                     : AppColors.kPrimaryColor.withOpacity(0.1),
//               ),
//             ),
//             child: Row(
//               children: [
//                 // Icon Container
//                 Container(
//                   padding: EdgeInsets.all(10.r),
//                   decoration: BoxDecoration(
//                     color: AppColors.kPrimaryColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   child: Icon(
//                     item.icon,
//                     size: 22.sp,
//                     color: AppColors.kPrimaryColor,
//                   ),
//                 ),
//                 SizedBox(width: 14.w),
//                 // Title
//                 Expanded(
//                   child: Text(
//                     item.title.tr,
//                     style: TextStyle(
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.w600,
//                       fontFamily: 'Cairo-Bold',
//                       color: isDark
//                           ? AppColors.kWhiteColor
//                           : AppColors.kFontColor,
//                     ),
//                   ),
//                 ),
//                 // Arrow or Coming Soon Badge
//                 if (item.comingSoon)
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 8.w,
//                       vertical: 4.h,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.orange.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8.r),
//                     ),
//                     child: Text(
//                       "soon".tr,
//                       style: TextStyle(
//                         fontSize: 10.sp,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Cairo-Bold',
//                         color: Colors.orange,
//                       ),
//                     ),
//                   )
//                 else
//                   Icon(
//                     Icons.arrow_forward_ios_rounded,
//                     size: 16.sp,
//                     color: isDark
//                         ? AppColors.kWhiteColor.withOpacity(0.5)
//                         : AppColors.kGreyColor,
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFooter(bool isDark) {
//     return Container(
//       padding: EdgeInsets.all(16.r),
//       child: Column(
//         children: [
//           // Divider
//           Container(
//             height: 1,
//             margin: EdgeInsets.only(bottom: 16.h),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.transparent,
//                   isDark
//                       ? AppColors.kThirtColorDarkMode
//                       : AppColors.kPrimaryColor.withOpacity(0.2),
//                   Colors.transparent,
//                 ],
//               ),
//             ),
//           ),
//           // App Version
//           Text(
//             "v1.0.0",
//             style: TextStyle(
//               fontSize: 11.sp,
//               fontFamily: 'Cairo-Bold',
//               color: isDark
//                   ? AppColors.kWhiteColor.withOpacity(0.4)
//                   : AppColors.kGreyColor.withOpacity(0.6),
//             ),
//           ),
//           SizedBox(height: 12.h),

//           // Logout Button

//           // Logo
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(AppImages.klogo, height: 24.h, width: 24.w),
//               SizedBox(width: 8.w),
//               Text(
//                 "Wallet",
//                 style: TextStyle(
//                   fontSize: 12.sp,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Cairo-Bold',
//                   color: isDark
//                       ? AppColors.kWhiteColor.withOpacity(0.5)
//                       : AppColors.kGreyColor,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void _showLogoutDialog(BuildContext context, bool isDark) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: isDark
//             ? AppColors.kSecondColorDarkMode
//             : AppColors.kWhiteColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20.r),
//         ),
//         title: Row(
//           children: [
//             Container(
//               padding: EdgeInsets.all(10.r),
//               decoration: BoxDecoration(
//                 color: AppColors.kRedColor.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12.r),
//               ),
//               child: Icon(
//                 Icons.logout_rounded,
//                 color: AppColors.kRedColor,
//                 size: 24.sp,
//               ),
//             ),
//             SizedBox(width: 12.w),
//             Text(
//               "log_out".tr,
//               style: TextStyle(
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'Cairo-Bold',
//                 color: isDark ? AppColors.kWhiteColor : AppColors.kFontColor,
//               ),
//             ),
//           ],
//         ),
//         content: Text(
//           "do_you_want_to_log_out".tr,
//           style: TextStyle(
//             fontSize: 14.sp,
//             fontFamily: 'Cairo-Bold',
//             color: isDark
//                 ? AppColors.kWhiteColor.withOpacity(0.8)
//                 : AppColors.kFontColor.withOpacity(0.8),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               "cancel".tr,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 fontFamily: 'Cairo-Bold',
//                 color: isDark
//                     ? AppColors.kWhiteColor.withOpacity(0.7)
//                     : AppColors.kGreyColor,
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               Navigator.pop(context);
//               // await UserPreferencesService.();
//               Get.offAllNamed(SignInScreen.id);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.kRedColor,
//               foregroundColor: AppColors.kWhiteColor,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12.r),
//               ),
//               padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//             ),
//             child: Text(
//               "log_out".tr,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'Cairo-Bold',
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DrawerMenuItem {
//   final IconData icon;
//   final String title;
//   final String? route;
//   final bool comingSoon;

//   _DrawerMenuItem({
//     required this.icon,
//     required this.title,
//     this.route,
//     this.comingSoon = false,
//   });
// }
