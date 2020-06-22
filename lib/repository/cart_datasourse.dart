import 'package:esamudaayapp/modules/home/models/merchant_response.dart';
import 'package:esamudaayapp/modules/store_details/models/catalog_search_models.dart';
import 'package:esamudaayapp/repository/database_manage.dart';

final String cartTable = "Cart";
final String merchantTable = "Merchants";

class CartDataSource {
  static Future<void> insert({Product product}) async {
    var dbClient = await DatabaseManager().db;
    try {
      var id = await dbClient.insert(cartTable, product.toJson());
      print(id);
    } catch (error) {
      print(error);
    }
  }

  static Future<void> insertToMerchants({MerchantLocal merchants}) async {
    var dbClient = await DatabaseManager().db;
    try {
      var id = await dbClient.insert(merchantTable, merchants.toJson());
      print(id);
    } catch (error) {
      print(error);
    }
  }

  static Future<List<MerchantLocal>> getListOfMerchants() async {
    var dbClient = await DatabaseManager().db;
    List<Map> list = await dbClient.query(merchantTable);
    var products = list.map((item) => MerchantLocal.fromJson(item)).toList();
    return products;
  }

  static Future<List<Product>> getListOfCartWith({String id}) async {
    var dbClient = await DatabaseManager().db;
    List<Map> list = await dbClient.query(cartTable);
    var products = list.map((item) => Product.fromJson(item)).toList();
    return products;
  }

  static Future<bool> isAvailableInCart({String id}) async {
    var dbClient = await DatabaseManager().db;
    List<Map> list =
        await dbClient.query(cartTable, where: 'id = ?', whereArgs: [id]);
    return list.isNotEmpty;
  }

  static Future<int> deleteAll() async {
    var dbClient = await DatabaseManager().db;
    return await dbClient.delete(cartTable);
  }

  static Future<int> deleteAllMerchants() async {
    var dbClient = await DatabaseManager().db;
    return await dbClient.delete(merchantTable);
  }

  static Future<int> deleteCartItemWith(String id) async {
    var dbClient = await DatabaseManager().db;
    return await dbClient.delete(cartTable, where: "id = ?", whereArgs: [id]);
  }

  static Future<int> delete(String id) async {
    var dbClient = await DatabaseManager().db;
    return await dbClient.delete(cartTable, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> update(Product product) async {
    var dbClient = await DatabaseManager().db;

    return await dbClient.update(cartTable, product.toJson(),
        where: 'id = ?', whereArgs: [product.id]);
  }
}
