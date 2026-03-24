
import '../../config/routes/app_url.dart';
import '../../model/agent_model/agent_model.dart';
import '../../network/dio_network/dio_client.dart';

class AgentRepository {
  final DioClient dioClient;

  AgentRepository(this.dioClient);

  Future<AgentPagination> getAgents({
    int page = 1,
    int perPage = 10,
    String? search,
  }) async {
    final query = {
      "page": page.toString(),
      "per_page": perPage.toString(),
      if (search != null) "search": search,
    };

    final response = await dioClient.get(
      AppUrl.getAgents,
      query: query,
    );

    if (response["status"] == 200) {
      return AgentPagination.fromJson(response["result"][0]);
    } else {
      throw Exception(response["message"]);
    }
  }
}