# Rate Limit: First 4 requests should succeed (within burst limit)
GET http://localhost:{{port}}/v1/healthcheck

HTTP 200


GET http://localhost:{{port}}/v1/healthcheck

HTTP 200


GET http://localhost:{{port}}/v1/healthcheck

HTTP 200


GET http://localhost:{{port}}/v1/healthcheck

HTTP 200


# 5th request should be rate limited (burst is 4)
GET http://localhost:{{port}}/v1/healthcheck

HTTP 429
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "rate limit exceeded"
