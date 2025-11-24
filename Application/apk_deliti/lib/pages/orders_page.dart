import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../themes/app_theme.dart';

class OrdersPage extends StatefulWidget {
  final User currentUser;

  const OrdersPage({super.key, required this.currentUser});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<dynamic> _orders = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      print('🔄 Loading orders for user: ${widget.currentUser.id}');
      // You'll need to create this API method
      final result = await ApiService.getUserOrders(widget.currentUser.id);
      
      if (result['success'] == true) {
        setState(() {
          _orders = result['orders'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to load orders';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading orders: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _cancelOrder(int orderId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // You'll need to create this API method
              final result = await ApiService.cancelOrder(orderId);
              
              if (result['success'] == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order cancelled successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                _loadOrders(); // Reload orders
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to cancel order: ${result['message']}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.black,
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _errorMessage.isNotEmpty
              ? _buildErrorState()
              : _orders.isEmpty
                  ? _buildEmptyState()
                  : _buildOrdersList(),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading your orders...'),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadOrders,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'No Orders Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your orders will appear here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList() {
    return ListView.builder(
      itemCount: _orders.length,
      itemBuilder: (context, index) {
        final order = _orders[index];
        return _buildOrderCard(order);
      },
    );
  }

Widget _buildOrderCard(Map<String, dynamic> order) {
  final isCancelled = order['status'] == 'cancelled';
  
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    color: isCancelled ? Colors.grey[100] : null,
    child: InkWell(
      onTap: isCancelled ? null : () => _showOrderDetails(order),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order header with status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status badge first
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order['status']),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getShortStatus(order['status']),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                
              ],
            ),

            Text(
              'Order #${order['id']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isCancelled ? Colors.grey : null,
              ),
            ),
            const SizedBox(height: 8),
            // Order details
            Text(
              'Total: Rp ${double.parse(order['total_price'].toString()).toStringAsFixed(0)}',
              style: TextStyle(
                color: isCancelled ? Colors.grey : null,
                fontSize: 14,
              ),
            ),
            Text(
              'Date: ${_formatDate(order['created_at'])}',
              style: TextStyle(
                color: isCancelled ? Colors.grey : Colors.grey[600],
                fontSize: 12,
              ),
            ),
            
            // Interactive hint
            if (!isCancelled) ...[
              const SizedBox(height: 8),
              const Text(
                'Tap to view details →',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.blue,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}


// Add this helper method for shorter status text
  String _getShortStatus(String status) {
    switch (status) {
      case 'pending':
        return 'PENDING';
      case 'confirmed':
        return 'CONFIRMED';
      case 'preparing':
        return 'PREPARING';
      case 'ready':
        return 'READY';
      case 'completed':
        return 'DONE'; // ← SHORTER
      case 'cancelled':
        return 'CANCELLED';
      default:
        return status.toUpperCase();
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'preparing':
        return Colors.purple;
      case 'ready':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  Future<void> _showOrderDetails(Map<String, dynamic> order) async {
    print('📦 Loading details for order: ${order['id']}');
    
    try {
      final result = await ApiService.getOrderDetails(order['id']);
      
      print('📦 Order Details API Response: $result'); // ← ADD THIS
      
      if (result['success'] == true) {
        final orderItems = result['items'];
        print('📦 Found ${orderItems.length} items in order'); // ← ADD THIS
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Order #${order['id']} Details'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text('Status: ${order['status']}', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Total: Rp ${double.parse(order['total_price'].toString()).toStringAsFixed(0)}'),
                  Text('Date: ${_formatDate(order['created_at'])}'),
                  const SizedBox(height: 16),
                  const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...orderItems.map<Widget>((item) => 
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            // Food icon
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.fastfood, color: Colors.grey),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'] ?? 'Unknown Item',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('Quantity: ${item['quantity']}'),
                                ],
                              ),
                            ),
                            Text(
                              'Rp ${double.parse(item['price'].toString()).toStringAsFixed(0)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ).toList(),
                ],
              ),
            ),
            actions: [
              // Cancel button for pending orders
              if (order['status'] == 'pending')
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close details dialog
                    _cancelOrder(order['id']); // Cancel order
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text('Cancel Order'),
                ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      } else {
        print('❌ Failed to load order details: ${result['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load order details: ${result['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('❌ Error loading order details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading order details: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

}