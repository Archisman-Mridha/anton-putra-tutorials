test-lambda-fn:
	aws lambda invoke \
		--region=us-east-2 \
		--function-name=say-hello \
		--payload '{"bucket":"lambda-set-ringtail", "object":"data.json"}' \
			response.json