abstract class ApiService<T> {
  Future<Map<String, dynamic>> preProcess(Map<String, dynamic> requestData);

  Future<Map<String, dynamic>> onApiContact(Map<String, dynamic> requestData);

  Future<T> postProcess(Map<String, dynamic> responseData);

  Future<T> execute(Map<String, dynamic> requestData) async {
    final processedRequestData = await preProcess(requestData);
    final responseData = await onApiContact(processedRequestData);
    final user = await postProcess(responseData);
    return user;
  }
}
