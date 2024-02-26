

import '../entities/product.entity.dart';

abstract class ProductsDatasource {

  Future<List<Product>> getProductsByPage({ int limit = 0, int offset = 0});
  Future<Product> getProductById({ required String id });
  Future<List<Product>> searchProductByTerm({ required String term });
  Future<Product> createUpdateProduct({ required Map<String, dynamic> productLike });

}