
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

  Future<String> _uploadFile(String path) async {
    try {
      final fileName = path.split('/').last;
      final FormData data = FormData.fromMap({
        'file': MultipartFile.fromFileSync(path, filename: fileName)
      }); 
      final response = await dio.post('/files/product', data: data);
      return response.data['image'];
    } catch (e) {
      throw Exception();
    }
  }

  Future<List<String>> _uploadPhotos (List<String> photos) async {
    final photosToUpload = photos.where((element) => element.contains('/')).toList();
    final photosToIgnore = photos.where((element) => !element.contains('/')).toList();

    final List<Future<String>> uploadJob = photosToUpload.map(
      (e) => _uploadFile(e)
    ).toList();
    final newImages =  await Future.wait(uploadJob);

    return [...photosToIgnore, ...newImages];
  }

  @override
  Future<Product> createUpdateProduct({required Map<String, dynamic> productLike}) async {
    try {
      final String? productId =  productLike['id'];
      final String method = (productId == null)  ? 'POST': 'PATCH';
      final String url = (productId == null)  ? '/products': '/products/$productId';
      productLike.remove('id');
      productLike['images'] = await _uploadPhotos(productLike['images']);

      final response = await dio.request(
        url,
        data: productLike,
        options: Options(
          method: method
        )
      );
      final Product product = ProductMapper.jsonToEntity(response.data as Map<String, dynamic>);
      return product;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Product> getProductById({ required String id}) async {
    try {
      final response = await dio.get<Map<String, dynamic>>('/products/$id');
      // print(response);
      final Product product = ProductMapper.jsonToEntity(response.data as Map<String, dynamic>);
      return product;
    } on DioException catch(e) {
      print(e);
      if (e.response!.statusCode == 404) throw ProductNotFound();
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError(message: 'Connection Timeout');
      }
      logger.e(e.response!.data['message']);
      throw Exception();
    } catch (e) {
      logger.e(e);
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