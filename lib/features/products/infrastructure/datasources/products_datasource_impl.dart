
import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/mappers/product_mapper.dart';

class ProductsDatasourceImpl implements ProductsDatasource {

  late final Dio dio;
  final String accessToken;

  ProductsDatasourceImpl({
    required this.accessToken
  }): dio = Dio ( //* INIT DIO
    BaseOptions(
      baseUrl: Environment.apiurl,
      headers: {
        'Authorization': 'Bearer $accessToken'
      }
    )
  );

  @override
  Future<Product> createUpdateProduct({required Map<String, dynamic> productLike}) {
    // TODO: implement createUpdateProduct
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductById({required String id}) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 0, int offset = 0}) async {
    final response = await dio.get<List>(
      '/products', 
      queryParameters: {
        'limit': limit,
        'offset': offset
      }
    );
    final List<Product> products = [];
    for (var product in response.data ?? []) {
      products.add( ProductMapper.jsonToEntity(product) );
    }
    return products;
  }

  @override
  Future<List<Product>> searchProductByTerm({required String term}) {
    // TODO: implement searchProductByTerm
    throw UnimplementedError();
  }


}