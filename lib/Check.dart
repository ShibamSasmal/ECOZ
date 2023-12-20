class Cloth {
  final String id;
  final String name;
  final String image;
  final String price;
  final String description;
  Cloth(
      {required this.id,
      required this.name,
      required this.image,
      required this.price,
      required this.description});
}

class CartItem {
  final String cart_id;
  final String PId;
  final String id;
  final String date;
  int quantity;
  final String productname;
  final String productimage;
  final String productprice;
  final String productdescription;
  final String categoryId;
  final String Featured;
  CartItem(
      {required this.cart_id,
      required this.PId,
      required this.id,
      required this.date,
      required this.quantity,
      required this.productname,
      required this.productimage,
      required this.productprice,
      required this.productdescription,
      required this.categoryId,
      required this.Featured});
}

class Address {
  final String address_id;
  final String id;
  final String name;
  final String ph_no;
  final String pin_code;
  final String address;
  final String state;
  final String city;
  final String district;

  Address(
      {required this.address_id,
      required this.id,
      required this.name,
      required this.ph_no,
      required this.pin_code,
      required this.address,
      required this.state,
      required this.city,
      required this.district});
}

class Order {
  final String order_id;
  final String id;
  final String PId;
  final String address_id;
  final String pick_date;
  final String delivery_between;
  final String size;
  final String payment_option;
  final String quantity;
  final String cancel_date;
  final String confirm_date;
  final String order_status;
  final String productname;
  final String productimage;
  final String productprice;
  final String productdescription;
  final String categoryId;
  final String Featured;
  final String name;
  final String ph_no;
  final String pin_code;
  final String address;
  final String state;
  final String city;
  final String district;
  Order(
      {required this.order_id,
      required this.id,
      required this.PId,
      required this.address_id,
      required this.pick_date,
      required this.delivery_between,
      required this.size,
      required this.payment_option,
      required this.quantity,
      required this.cancel_date,
      required this.confirm_date,
      required this.order_status,
      required this.productname,
      required this.productimage,
      required this.productprice,
      required this.productdescription,
      required this.categoryId,
      required this.Featured,
      required this.name,
      required this.ph_no,
      required this.pin_code,
      required this.address,
      required this.state,
      required this.city,
      required this.district});
}
