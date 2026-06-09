enum ProductStatus {
  active('ACTIVE'),
  removed('REMOVED');

  final String value;

  const ProductStatus(this.value);
}