
import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/errors/product_errors.dart';
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
  Future<Product> getProductById({ required String id}) async {
    try {
      final response = await dio.get<List>( '/products/$id');
      final Product product = ProductMapper.jsonToEntity(response.data as Map<String, dynamic>);
      return product;
    } on DioException catch(e) {
      if (e.response!.statusCode == 404) throw ProductNotFound();
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError(message: 'Connection Timeout');
      }
      logger.e(e.response!.data['message']);
      throw Exception();
    } catch (e) {
      throw Exception();
    }
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