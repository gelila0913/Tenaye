import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final String error;

  ApiException({
    required this.statusCode,
    required this.message,
    required this.error,
  });

  @override
  String toString() => 'ApiException: [$statusCode] $error - $message';
}

class ApiClient {
  final http.Client _client;
  final Duration _timeout;

  ApiClient({http.Client? client, Duration? timeout})
      : _client = client ?? http.Client(),
        _timeout = timeout ?? const Duration(seconds: 15);

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Sends a GET request to the specified url path
  Future<dynamic> get(String url) async {
    try {
      final uri = Uri.parse(url);
      final response = await _client
          .get(uri, headers: _headers)
          .timeout(_timeout);

      return _processResponse(response);
    } on SocketException {
      throw ApiException(
        statusCode: 0,
        error: 'NetworkError',
        message: 'No internet connection or backend server is offline.',
      );
    } on http.ClientException catch (e) {
      throw ApiException(
        statusCode: 0,
        error: 'ClientException',
        message: e.message,
      );
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw ApiException(
          statusCode: 408,
          error: 'TimeoutError',
          message: 'Request timed out. Please try again.',
        );
      }
      rethrow;
    }
  }

  /// Sends a POST request to the specified url path with a JSON body
  Future<dynamic> post(String url, Map<String, dynamic> body) async {
    try {
      final uri = Uri.parse(url);
      final response = await _client
          .post(
            uri,
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      return _processResponse(response);
    } on SocketException {
      throw ApiException(
        statusCode: 0,
        error: 'NetworkError',
        message: 'No internet connection or backend server is offline.',
      );
    } on http.ClientException catch (e) {
      throw ApiException(
        statusCode: 0,
        error: 'ClientException',
        message: e.message,
      );
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw ApiException(
          statusCode: 408,
          error: 'TimeoutError',
          message: 'Request timed out. Please try again.',
        );
      }
      rethrow;
    }
  }

  /// Sends a POST Multipart request for uploading files (e.g. weight log progress photo)
  Future<dynamic> postMultipart(
    String url,
    Map<String, String> fields, {
    required String fileKey,
    required File file,
  }) async {
    try {
      final uri = Uri.parse(url);
      final request = http.MultipartRequest('POST', uri);

      // Add text fields
      request.fields.addAll(fields);

      // Add file
      final stream = http.ByteStream(file.openRead());
      final length = await file.length();
      final multipartFile = http.MultipartFile(
        fileKey,
        stream,
        length,
        filename: file.path.split('/').last,
      );
      request.files.add(multipartFile);

      // Send request
      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);

      return _processResponse(response);
    } on SocketException {
      throw ApiException(
        statusCode: 0,
        error: 'NetworkError',
        message: 'No internet connection or backend server is offline.',
      );
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw ApiException(
          statusCode: 408,
          error: 'TimeoutError',
          message: 'Request timed out. Please try again.',
        );
      }
      rethrow;
    }
  }

  /// Sends a PUT request to the specified url path with a JSON body
  Future<dynamic> put(String url, Map<String, dynamic> body) async {
    try {
      final uri = Uri.parse(url);
      final response = await _client
          .put(
            uri,
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      return _processResponse(response);
    } on SocketException {
      throw ApiException(
        statusCode: 0,
        error: 'NetworkError',
        message: 'No internet connection or backend server is offline.',
      );
    } on http.ClientException catch (e) {
      throw ApiException(
        statusCode: 0,
        error: 'ClientException',
        message: e.message,
      );
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw ApiException(
          statusCode: 408,
          error: 'TimeoutError',
          message: 'Request timed out. Please try again.',
        );
      }
      rethrow;
    }
  }

  /// Sends a DELETE request to the specified url path
  Future<dynamic> delete(String url) async {
    try {
      final uri = Uri.parse(url);
      final response = await _client
          .delete(uri, headers: _headers)
          .timeout(_timeout);

      return _processResponse(response);
    } on SocketException {
      throw ApiException(
        statusCode: 0,
        error: 'NetworkError',
        message: 'No internet connection or backend server is offline.',
      );
    } on http.ClientException catch (e) {
      throw ApiException(
        statusCode: 0,
        error: 'ClientException',
        message: e.message,
      );
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw ApiException(
          statusCode: 408,
          error: 'TimeoutError',
          message: 'Request timed out. Please try again.',
        );
      }
      rethrow;
    }
  }

  /// Helper to process the HTTP response
  dynamic _processResponse(http.Response response) {
    final int statusCode = response.statusCode;
    final String body = response.body;

    dynamic decodedJson;
    try {
      decodedJson = jsonDecode(body);
    } catch (_) {
      // Return raw body or raise exception if not valid JSON
      if (statusCode >= 200 && statusCode < 300) {
        return body;
      }
      throw ApiException(
        statusCode: statusCode,
        error: 'InvalidJsonResponse',
        message: 'The server returned an invalid or empty response.',
      );
    }

    if (statusCode >= 200 && statusCode < 300) {
      return decodedJson;
    } else {
      // Extract error details from our backend error response standard
      final String message = decodedJson['message'] ?? 'An error occurred';
      final String error = decodedJson['error'] ?? 'HttpError';
      throw ApiException(
        statusCode: statusCode,
        message: message,
        error: error,
      );
    }
  }
}
