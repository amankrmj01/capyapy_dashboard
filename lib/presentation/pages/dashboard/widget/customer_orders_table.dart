// Widget for the customer orders table
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

class CustomerOrdersTable extends StatelessWidget {
  const CustomerOrdersTable({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      {
        'id': 'ORD-001',
        'customer': 'John Smith',
        'amount': '\$299.99',
        'status': 'Completed',
        'date': '2025-08-25',
      },
      {
        'id': 'ORD-002',
        'customer': 'Sarah Johnson',
        'amount': '\$459.50',
        'status': 'Pending',
        'date': '2025-08-24',
      },
      {
        'id': 'ORD-003',
        'customer': 'Mike Wilson',
        'amount': '\$189.00',
        'status': 'Processing',
        'date': '2025-08-24',
      },
      {
        'id': 'ORD-004',
        'customer': 'Emily Davis',
        'amount': '\$329.75',
        'status': 'Completed',
        'date': '2025-08-23',
      },
      {
        'id': 'ORD-005',
        'customer': 'David Brown',
        'amount': '\$159.99',
        'status': 'Cancelled',
        'date': '2025-08-23',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '📋 Recent Orders',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              const Spacer(),
              TextButton(onPressed: () {}, child: Text('View All')),
            ],
          ),
          const SizedBox(height: 16),
          Table(
            columnWidths: {
              0: FlexColumnWidth(1.5),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1.5),
              3: FlexColumnWidth(1.5),
              4: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: AppColors.background(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                children: [
                  _buildHeaderCell(context, 'Order ID'),
                  _buildHeaderCell(context, 'Customer'),
                  _buildHeaderCell(context, 'Amount'),
                  _buildHeaderCell(context, 'Status'),
                  _buildHeaderCell(context, 'Date'),
                ],
              ),
              ...orders
                  .map(
                    (order) => TableRow(
                      children: [
                        _buildDataCell(context, order['id']!),
                        _buildDataCell(context, order['customer']!),
                        _buildDataCell(context, order['amount']!),
                        _buildStatusCell(context, order['status']!),
                        _buildDataCell(context, order['date']!),
                      ],
                    ),
                  )
                  ,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary(context),
        ),
      ),
    );
  }

  Widget _buildDataCell(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: AppColors.textPrimary(context),
        ),
      ),
    );
  }

  Widget _buildStatusCell(BuildContext context, String status) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'completed':
        statusColor = Colors.green;
        break;
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'processing':
        statusColor = Colors.blue;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: statusColor.withValues(alpha: 0.3)),
        ),
        child: Text(
          status,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: statusColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
