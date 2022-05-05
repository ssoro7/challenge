# all tests, builds and runs both services
.PHONY: all
all: test build run

# clean-tests both projects
.PHONY: test
test: 
	@echo "Testing Product Review Service..."
	@mvn clean test -f ./product_review/pom.xml
	@echo "Testing Product API..."
	@mvn clean test -f ./product_service/pom.xml

# builds docker images for both projects
.PHONY: build
build:
	@echo "Building..."
	@docker-compose build 

# runs both applications in detached mode
.PHONY: run
run:
	@echo "Running..."
	@docker-compose up -d

# stops both applications
stop:
	@echo "Stopping..."
	@docker-compose down