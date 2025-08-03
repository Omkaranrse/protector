import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:protector/models/booking_model.dart';
import 'package:protector/pages/admin/admin_booking_details_screen.dart';
import 'package:protector/providers/auth_provider.dart';
import 'package:protector/providers/booking_provider.dart';
import 'package:protector/services/notification_service.dart';
import 'package:protector/utils/page_transitions.dart';
import 'package:protector/widgets/loading_indicator.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  BookingStatus? _statusFilter;

  @override
  void initState() {
    super.initState();
    _loadAllBookings();
  }

  Future<void> _loadAllBookings() async {
    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

      if (authProvider.token == null || authProvider.user == null || !authProvider.user!.isAdmin) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'You need admin privileges to access this page';
        });
        return;
      }

      await bookingProvider.getAllBookings(authProvider.token!);

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load bookings';
      });
    }
  }

  void _viewBookingDetails(Booking booking) {
    Navigator.of(context).push(
      PageTransitions.slideRightTransition(
        AdminBookingDetailsScreen(booking: booking),
      ),
    ).then((_) => _loadAllBookings()); // Refresh on return
  }

  void _logout() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final notificationService = Provider.of<NotificationService>(context, listen: false);
    
    authProvider.logout();
    notificationService.showNotification('You have been logged out successfully', NotificationType.success);
    
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  List<Booking> _getFilteredBookings(List<Booking> bookings) {
    return bookings.where((booking) {
      // Apply status filter if selected
      if (_statusFilter != null && booking.status != _statusFilter) {
        return false;
      }
      
      // Apply search query if not empty
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return booking.id.toLowerCase().contains(query) ||
               booking.pickupLocation.toLowerCase().contains(query) ||
               booking.formattedDate.toLowerCase().contains(query) ||
               booking.formattedTime.toLowerCase().contains(query) ||
               booking.status.name.toLowerCase().contains(query);
      }
      
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        loadingMessage: 'Loading bookings...',
        child: _errorMessage != null
            ? _buildErrorView()
            : _buildDashboardContent(),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadAllBookings,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    return Column(
      children: [
        _buildFilterBar(),
        Expanded(
          child: _buildBookingsList(),
        ),
        _buildBookingStats(),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search bookings...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', null),
                const SizedBox(width: 8),
                _buildFilterChip('Pending', BookingStatus.pending),
                const SizedBox(width: 8),
                _buildFilterChip('Confirmed', BookingStatus.confirmed),
                const SizedBox(width: 8),
                _buildFilterChip('Completed', BookingStatus.completed),
                const SizedBox(width: 8),
                _buildFilterChip('Cancelled', BookingStatus.cancelled),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, BookingStatus? status) {
    final isSelected = _statusFilter == status;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _statusFilter = selected ? status : null;
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildBookingsList() {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, _) {
        final filteredBookings = _getFilteredBookings(bookingProvider.allBookings);

        if (filteredBookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  _statusFilter != null || _searchQuery.isNotEmpty
                      ? 'No bookings match your filters'
                      : 'No bookings available',
                  style: const TextStyle(fontSize: 16),
                ),
                if (_statusFilter != null || _searchQuery.isNotEmpty) ...[  
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _statusFilter = null;
                        _searchQuery = '';
                      });
                    },
                    child: const Text('Clear Filters'),
                  ),
                ],
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _loadAllBookings,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: filteredBookings.length,
            itemBuilder: (context, index) {
              final booking = filteredBookings[index];
              return _buildBookingCard(booking);
            },
          ),
        );
      },
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: () => _viewBookingDetails(booking),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Booking #${booking.id.substring(0, 8)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusChip(booking.status),
                ],
              ),
              const Divider(),
              _buildInfoRow(Icons.location_on, booking.pickupLocation),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.calendar_today,
                '${booking.formattedDate} at ${booking.formattedTime}',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.people,
                '${booking.protectees} protectees, ${booking.protectors} protectors',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.directions_car,
                '${booking.cars} ${booking.cars == 1 ? 'car' : 'cars'}',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.attach_money,
                booking.formattedPrice,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (booking.status == BookingStatus.pending) ...[  
                    OutlinedButton(
                      onPressed: () => _viewBookingDetails(booking),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _viewBookingDetails(booking),
                      child: const Text('Confirm'),
                    ),
                  ] else ...[  
                    ElevatedButton(
                      onPressed: () => _viewBookingDetails(booking),
                      child: const Text('View Details'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BookingStatus status) {
    Color chipColor;
    Color textColor = Colors.white;
    
    switch (status) {
      case BookingStatus.pending:
        chipColor = Colors.orange;
        break;
      case BookingStatus.confirmed:
        chipColor = Colors.green;
        break;
      case BookingStatus.completed:
        chipColor = Colors.blue;
        break;
      case BookingStatus.cancelled:
        chipColor = Colors.red;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        _getStatusText(status),
        style: TextStyle(color: textColor, fontSize: 12),
      ),
    );
  }

  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[800]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildBookingStats() {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, _) {
        final allBookings = bookingProvider.allBookings;
        final pendingCount = allBookings.where((b) => b.status == BookingStatus.pending).length;
        final confirmedCount = allBookings.where((b) => b.status == BookingStatus.confirmed).length;
        final completedCount = allBookings.where((b) => b.status == BookingStatus.completed).length;
        final cancelledCount = allBookings.where((b) => b.status == BookingStatus.cancelled).length;
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Pending', pendingCount, Colors.orange),
              _buildStatItem('Confirmed', confirmedCount, Colors.green),
              _buildStatItem('Completed', completedCount, Colors.blue),
              _buildStatItem('Cancelled', cancelledCount, Colors.red),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}