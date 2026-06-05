int dueDateCalculator(DateTime dueDate) {
  final currentDate = DateTime.now();

  // Calcula a diferença total de meses
  // Ex: (2026 * 12 + 1) - (2025 * 12 + 12) = 1 mês de diferença
  return (dueDate.year - currentDate.year) * 12 +
      (dueDate.month - currentDate.month);
}
