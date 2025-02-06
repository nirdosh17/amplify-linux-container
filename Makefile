# setup these variables
AWS_PROFILE=default
AWS_REGION=us-east-1

PROJECT_NAME=my-amplify-app
PROJECT_DIR=/Users/nirdosh/${PROJECT_NAME}

PLATFORM=linux/amd64
IMAGE_NAME=amplify-dev-container

build:
	docker build --platform ${PLATFORM} -t ${IMAGE_NAME} .

ssh:
	docker run --platform ${PLATFORM} -it \
		-v ${PROJECT_DIR}:/app/${PROJECT_NAME} \
		-v ~/.aws:/root/.aws:ro \
		-e AWS_PROFILE=${AWS_PROFILE} \
		-e AWS_REGION=${AWS_REGION} \
		${IMAGE_NAME}

cleanup:
	docker rmi ${IMAGE_NAME} --force
	docker system prune -f
