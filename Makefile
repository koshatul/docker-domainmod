DOCKER_REPO := registry.ctrlzr.com/koshatul/domainmod
DOCKER_REQ := domainmod/_includes/config.inc.php

-include artifacts/make/docker/Makefile

artifacts/make/%/Makefile:
	curl -sf https://jmalloc.github.io/makefiles/fetch | bash /dev/stdin $*

artifacts/storage/data/mysql:
	@mkdir -p "$(@)"

.PHONY: compose
compose: docker artifacts/storage/data/mysql
	STORAGE_DIR="$(shell pwd)/artifacts/storage" docker-compose up

.PHONY: run
run: docker
	docker run --rm -ti -p 8088:80 $(DOCKER_REPO):$(DOCKER_TAG)

domainmod/_includes/config.inc.php: config/config.inc.php
	cp "$(<)" "$(@)"
