class Order {
  int quantity;
  int itemPrice;
}

class Inline {
  double orderCalculation(Order order) {
    float i = order.quantity * order.itemPrice;
    return i -
        Math.max(0, order.quantity - 500) * order.itemPrice * 0.05 +
        Math.min(i * 0.1, 100.0);
  }
}
