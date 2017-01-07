DOCKER:=philipbui/android-ci
NAME:=android-ci

help: ## Display this help screen
	grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'	

build: ## Build Docker Container
	docker build -t ${DOCKER} .

run: ## Run Application
	docker run -ti --name ${NAME} ${DOCKER}

stop: ## Stop Application (if in Daemon)
	docker stop ${NAME}
	docker rm ${NAME}
