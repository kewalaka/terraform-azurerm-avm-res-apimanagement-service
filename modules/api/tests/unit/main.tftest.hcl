mock_provider "azapi" {}
mock_provider "modtm" {}
mock_provider "random" {}

variables {
  display_name     = "Example API"
  enable_telemetry = false
  name             = "example"
  parent_id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.ApiManagement/service/apim-test"
  path             = "example"
  protocols        = ["https"]
}

run "replaces_api_for_revision_changes" {
  command = plan

  assert {
    condition = azapi_resource.this.replace_triggers_refs == tolist([
      "properties.apiRevision",
    ])
    error_message = "API revision changes must replace the API."
  }
}

run "serializes_api_type_as_api_type" {
  command = plan

  assert {
    condition = (
      azapi_resource.this.body.properties.apiType == "http" &&
      !contains(keys(azapi_resource.this.body.properties), "type")
    )
    error_message = "API type must be serialized as the ARM apiType property without the legacy type property."
  }
}
