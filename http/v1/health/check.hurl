# Healthcheck
GET http://localhost:4000/v1/healthcheck

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.status" == "available"
jsonpath "$.system_info.environment" == "development"
jsonpath "$.system_info.version" == "1.0.0"
