import 'package:flutter/material.dart';
import 'package:valitrack/model/store.dart';

class InfoStore extends StatelessWidget {
  final Store store;
  const InfoStore({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Barra de arraste
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          const SizedBox(height: 24),

          // Ícone da loja
          CircleAvatar(
            radius: 32,
            backgroundColor: const Color(0xFFF5F5F5),
            child: Icon(
              Icons.store_rounded,
              size: 32,
              color: Theme.of(context).primaryColor,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            store.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  icon: Icons.inventory_2_outlined,
                  color: Colors.blue,
                  title: "Produtos",
                  value: '${store.quantityRegisteredProducts}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoCard(
                  icon: Icons.warning_amber_rounded,
                  color: Colors.orange,
                  title: "Próx. Venc.",
                  value: '${store.quantityProductsToExpire}',
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _InfoCard(
            icon: Icons.dangerous_outlined,
            color: Colors.red,
            title: "Vencidos",
            value: '${store.quantityExpiredProducts}',
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: .2),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
