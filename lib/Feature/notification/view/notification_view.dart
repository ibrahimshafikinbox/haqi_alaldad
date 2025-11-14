// // notifications_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:store_mangment/Feature/notification/repo/notifications_repository.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import '../cubit/notification_cubit.dart';
// import '../cubit/notification_state.dart';
// import '../models/notification_model.dart';

// class NotificationsPage extends StatelessWidget {
//   const NotificationsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final currentUserId = FirebaseAuth.instance.currentUser?.uid;

//     if (currentUserId == null) {
//       return Scaffold(body: Center(child: Text('Please login first')));
//     }

//     return BlocProvider(
//       create: (context) =>
//           NotificationCubit(NotificationsRepository())
//             ..loadUserNotifications(currentUserId),
//       child: Scaffold(
//         backgroundColor: Colors.grey[50],
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back_ios_new, color: Colors.black87),
//             onPressed: () => Navigator.pop(context),
//           ),
//           title: const Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Notifications',
//                 style: TextStyle(
//                   color: Colors.black87,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 'Important updates and notifications',
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 12,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             BlocBuilder<NotificationCubit, NotificationState>(
//               builder: (context, state) {
//                 if (state is NotificationLoaded && state.unreadCount > 0) {
//                   return TextButton.icon(
//                     onPressed: () {
//                       context.read<NotificationCubit>().markAllAsRead(
//                         state.notifications,
//                       );
//                     },
//                     icon: Icon(Icons.done_all, size: 18),
//                     label: Text('Mark all'),
//                     style: TextButton.styleFrom(foregroundColor: Colors.blue),
//                   );
//                 }
//                 return SizedBox.shrink();
//               },
//             ),
//           ],
//         ),
//         body: BlocBuilder<NotificationCubit, NotificationState>(
//           builder: (context, state) {
//             if (state is NotificationLoading) {
//               return Center(
//                 child: CircularProgressIndicator(color: Colors.blue),
//               );
//             }

//             if (state is NotificationError) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.error_outline, size: 64, color: Colors.red),
//                     SizedBox(height: 16),
//                     Text(
//                       'An error occurred',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(state.error, style: TextStyle(color: Colors.grey)),
//                   ],
//                 ),
//               );
//             }

//             if (state is NotificationLoaded) {
//               if (state.notifications.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         padding: EdgeInsets.all(32),
//                         decoration: BoxDecoration(
//                           color: Colors.blue.withOpacity(0.1),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           Icons.notifications_off_outlined,
//                           size: 80,
//                           color: Colors.blue,
//                         ),
//                       ),
//                       SizedBox(height: 24),
//                       Text(
//                         'No notifications',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         'We will notify you when there are new updates',
//                         style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                       ),
//                     ],
//                   ),
//                 );
//               }

//               return RefreshIndicator(
//                 onRefresh: () async {
//                   context.read<NotificationCubit>().loadUserNotifications(
//                     currentUserId,
//                   );
//                 },
//                 color: Colors.blue,
//                 child: ListView.builder(
//                   padding: EdgeInsets.all(16),
//                   itemCount: state.notifications.length,
//                   itemBuilder: (context, index) {
//                     final notification = state.notifications[index];
//                     return _NotificationCard(
//                       notification: notification,
//                       onTap: () {
//                         if (!notification.read) {
//                           context.read<NotificationCubit>().markAsRead(
//                             notification.id!,
//                           );
//                         }
//                         // You can add navigation to details here
//                       },
//                     );
//                   },
//                 ),
//               );
//             }

//             return SizedBox.shrink();
//           },
//         ),
//       ),
//     );
//   }
// }

// class _NotificationCard extends StatelessWidget {
//   final AppNotification notification;
//   final VoidCallback onTap;

//   const _NotificationCard({required this.notification, required this.onTap});

//   Color _getStatusColor() {
//     switch (notification.status) {
//       case 'approved':
//         return Colors.green;
//       case 'declined':
//         return Colors.red;
//       case 'pending':
//         return Colors.orange;
//       default:
//         return Colors.blue;
//     }
//   }

//   IconData _getStatusIcon() {
//     switch (notification.status) {
//       case 'approved':
//         return Icons.check_circle;
//       case 'declined':
//         return Icons.cancel;
//       case 'pending':
//         return Icons.access_time;
//       default:
//         return Icons.info;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final statusColor = _getStatusColor();

//     return Container(
//       margin: EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: notification.read ? Colors.white : Colors.blue.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: notification.read
//               ? Colors.grey[200]!
//               : Colors.blue.withOpacity(0.3),
//           width: notification.read ? 1 : 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 8,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(16),
//           child: Padding(
//             padding: EdgeInsets.all(16),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Status icon
//                 Container(
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: statusColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(_getStatusIcon(), color: statusColor, size: 24),
//                 ),

//                 SizedBox(width: 16),

//                 // Content
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               notification.title,
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                           ),
//                           if (!notification.read)
//                             Container(
//                               width: 10,
//                               height: 10,
//                               decoration: BoxDecoration(
//                                 color: Colors.blue,
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                         ],
//                       ),

//                       SizedBox(height: 6),

//                       Text(
//                         notification.body,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[700],
//                           height: 1.4,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),

//                       SizedBox(height: 8),

//                       Row(
//                         children: [
//                           Icon(
//                             Icons.access_time,
//                             size: 14,
//                             color: Colors.grey[500],
//                           ),
//                           SizedBox(width: 4),
//                           Text(
//                             timeago.format(
//                               notification.createdAt,
//                               locale: 'en', // Changed from 'ar' to 'en'
//                             ),
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey[500],
//                             ),
//                           ),

//                           if (notification.bookingId != null) ...[
//                             SizedBox(width: 12),
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: statusColor.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Text(
//                                 notification.status,
//                                 style: TextStyle(
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.bold,
//                                   color: statusColor,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store_mangment/Core/Localizations/app_localizatios.dart';
import 'package:store_mangment/Feature/notification/repo/notifications_repository.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';
import '../models/notification_model.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      return Scaffold(
        body: Center(child: Text(loc.translate('please_login_first'))),
      );
    }

    return BlocProvider(
      create: (context) =>
          NotificationCubit(NotificationsRepository())
            ..loadUserNotifications(currentUserId),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.translate('notifications'),
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                loc.translate('important_updates'),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          actions: [
            BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                if (state is NotificationLoaded && state.unreadCount > 0) {
                  return TextButton.icon(
                    onPressed: () {
                      context.read<NotificationCubit>().markAllAsRead(
                        state.notifications,
                      );
                    },
                    icon: const Icon(Icons.done_all, size: 18),
                    label: Text(loc.translate('mark_all')),
                    style: TextButton.styleFrom(foregroundColor: Colors.blue),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              );
            }

            if (state is NotificationError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      loc.translate('an_error_occurred'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.error,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            if (state is NotificationLoaded) {
              if (state.notifications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_off_outlined,
                          size: 80,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        loc.translate('no_notifications'),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          loc.translate('notify_new_updates'),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<NotificationCubit>().loadUserNotifications(
                    currentUserId,
                  );
                },
                color: Colors.blue,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = state.notifications[index];
                    return _NotificationCard(
                      notification: notification,
                      onTap: () {
                        if (!notification.read) {
                          context.read<NotificationCubit>().markAsRead(
                            notification.id!,
                          );
                        }
                      },
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const _NotificationCard({required this.notification, required this.onTap});

  Color _getStatusColor() {
    switch (notification.status) {
      case 'approved':
        return Colors.green;
      case 'declined':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon() {
    switch (notification.status) {
      case 'approved':
        return Icons.check_circle;
      case 'declined':
        return Icons.cancel;
      case 'pending':
        return Icons.access_time;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final statusColor = _getStatusColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification.read ? Colors.white : Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: notification.read
              ? Colors.grey[200]!
              : Colors.blue.withOpacity(0.3),
          width: notification.read ? 1 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_getStatusIcon(), color: statusColor, size: 24),
                ),

                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          if (!notification.read)
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Text(
                        notification.body,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            timeago.format(notification.createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),

                          if (notification.bookingId != null) ...[
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                loc.translate(notification.status),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
