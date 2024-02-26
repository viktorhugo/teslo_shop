import 'package:teslo_shop/features/products/domain/domain.dart';

//* UNICO OBJETICO ES UTILIZAR EL DATASOURCE
class ProductsRepositoryImpl extends ProductsRepository {
  
  final ProductsDatasource dataSource;

  ProductsRepositoryImpl({
    required this.dataSource
  });

  @override
  Future<Product> createUpdateProduct({required Map<String, dynamic> productLike}) {
    return dataSource.createUpdateProduct(productLike: productLike);
  }

  @override
  Future<Product> getProductById({required String id}) {
    return dataSource.getProductById(id: id);
  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 0, int offset = 0}) {
    return dataSource.getProductsByPage( limit: limit,offset: offset );
  }

  @override
  Future<List<Product>> searchProductByTerm({required String term}) {
    return dataSource.searchProductByTerm(term: term);
  }

}