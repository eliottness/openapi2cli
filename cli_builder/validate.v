module cli_builder

import openapi

pub fn validate(mut open_api openapi.OpenApi, server string) ? {
	if server.len == 0 && open_api.servers.len == 0 {
		eprintln("No servers specified at global level")
		eprintln("Please note this tool does not support multiple servers")
		return error("No servers defined")
	}

	mut operation_ids := []string{}
	for path, path_item in open_api.paths {
		for method, operation in path_item.operations {
			if operation.operation_id == "" {
				return error("OperationId is required for path: " + path + " method: " + method)
			}
			if operation_ids.contains(operation.operation_id) {
				return error("Duplicate OperationId: " + operation.operation_id)
			}
			operation_ids << operation.operation_id
		}
	}

	if server.len > 0 {
		open_api.servers << openapi.Server{
				url: server,
		}
	}
}