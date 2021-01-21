PROJ=infra
VERSION=0.13.1
IMAGE_NAME=ghcr.io/kwkoo/tkn-ubi8:$(VERSION)
URL=https://mirror.openshift.com/pub/openshift-v4/clients/pipeline/0.13.1/tkn-linux-amd64-0.13.1.tar.gz

BASE=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.PHONY: build push clean cron

push: build
	@echo "Pushing image..."
	docker push $(IMAGE_NAME)

build: download/tkn
	@echo "Building image..."
	docker build -t $(IMAGE_NAME) $(BASE)

download/tkn:
	-rm -rf $(BASE)/download
	mkdir $(BASE)/download
	curl -o $(BASE)/download/tkn.tar.gz $(URL)
	cd $(BASE)/download && tar -zxf tkn.tar.gz

clean:
	-docker rmi -f $(IMAGE_NAME)
	-rm -rf $(BASE)/download

cron:
	-oc create sa pr-cleaner -n $(PROJ)
	-oc create clusterrole \
	  pr-cleaner \
	  --verb=get,delete,list \
	  --resource=pipeline,pipelinerun,task,taskrun
	-oc adm policy add-cluster-role-to-user \
	  pr-cleaner \
	  -z pr-cleaner \
	  -n $(PROJ)
	-oc apply -f $(BASE)/central_cronjob.yaml -n $(PROJ)