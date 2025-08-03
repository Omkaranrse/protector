import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:protector/services/notification_service.dart';
import 'package:protector/widgets/loading_indicator.dart';

class PickupLocationScreen extends StatefulWidget {
  const PickupLocationScreen({super.key});

  @override
  State<PickupLocationScreen> createState() => _PickupLocationScreenState();
}

class _PickupLocationScreenState extends State<PickupLocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  // Sample location list - in a real app, this would come from an API
  List<Map<String, String>> locations = [
    {'title': 'Taj Mahal Palace', 'subtitle': 'Apollo Bandar, Colaba, Mumbai'},
    {'title': 'The Oberoi', 'subtitle': 'Nariman Point, Mumbai'},
    {'title': 'Trident Hotel', 'subtitle': 'Nariman Point, Mumbai'},
    {'title': 'ITC Grand Central', 'subtitle': 'Parel, Mumbai'},
    {'title': 'The Leela Palace', 'subtitle': 'Diplomatic Enclave, New Delhi'},
    {'title': 'The Imperial', 'subtitle': 'Janpath, New Delhi'},
    {'title': 'Taj Lake Palace', 'subtitle': 'Pichola, Udaipur'},
    {'title': 'The Oberoi Udaivilas', 'subtitle': 'Udaipur, Rajasthan'},
    {'title': 'Umaid Bhawan Palace', 'subtitle': 'Jodhpur, Rajasthan'},
  ];

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.95),
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Pickup Location', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 12),
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildCurrentLocationTile(),
              const Divider(color: Colors.white24),
              Expanded(child: _buildLocationList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[900],
        prefixIcon: const Icon(Icons.search, color: Colors.white),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.clear, color: Colors.white),
          onPressed: () {
            _searchController.clear();
            setState(() {});
          },
        )
            : null,
        hintText: 'Search',
        hintStyle: const TextStyle(color: Colors.white54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
      ),
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  Widget _buildCurrentLocationTile() {
    return ListTile(
      leading: const Icon(Icons.my_location, color: Colors.white),
      title: const Text('Use Current Location', style: TextStyle(color: Colors.white)),
      onTap: () async {
        final notificationService = Provider.of<NotificationService>(context, listen: false);
        
        setState(() {
          _isLoading = true;
        });
        
        try {
          // Simulate getting current location
          await Future.delayed(const Duration(seconds: 2));
          
          if (!mounted) return;
          
          // Return a simulated current location
          Navigator.pop(context, 'Current Location (Mumbai, Maharashtra)');
        } catch (e) {
          if (!mounted) return;
          
          notificationService.showNotification(
            'Failed to get current location: ${e.toString()}',
            NotificationType.error,
          );
        } finally {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      },
    );
  }

  Widget _buildLocationList() {
    String query = _searchController.text.trim().toLowerCase();

    List<Map<String, String>> filteredLocations = locations.where((loc) {
      return loc['title']!.toLowerCase().contains(query) ||
          loc['subtitle']!.toLowerCase().contains(query);
    }).toList();

    if (query.isNotEmpty && filteredLocations.isEmpty) {
      return const Center(
        child: Text(
          'No results found',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    if (filteredLocations.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      itemCount: filteredLocations.length,
      itemBuilder: (context, index) {
        var location = filteredLocations[index];
        return ListTile(
          leading: const Icon(Icons.location_on, color: Colors.white),
          title: Text(location['title']!, style: const TextStyle(color: Colors.white)),
          subtitle: Text(location['subtitle']!, style: const TextStyle(color: Colors.white70)),
          onTap: () {
            Navigator.pop(context, location['title']);
          },
        );
      },
    );
  }
}
