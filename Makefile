TARGET=github-runner
.PHONY: $(TARGET).zip

# all: update-image-id $(TARGET).zip

build: $(TARGET).zip

clean:
	rm -rf $(TARGET).zip

check: $(TARGET).zip
	murano-pkg-check $<

upload: check
	murano package-import -c "Application Servers" --package-version 1.0 --exists-action u $(TARGET).zip

# public:
# 	@echo "Searching for $(TARGET) package ID..."
# 	@package_id=$$(murano package-list --fqn $(TARGET) | grep $(TARGET) | awk '{print $$2}'); \
# 	echo "Found ID: $$package_id"; \
# 	murano package-update --is-public true $$package_id

update-image-id:
	@echo "Searching for latest image of NeCTAR Ubuntu 20.04 LTS (Focal) amd64..."
	@image_id=$$(openstack image list --limit 100 --long -f value -c ID -c Project --property "name=NeCTAR Ubuntu 20.04 LTS (Focal) amd64" --sort created_at | tail -n1 | cut -d" " -f1); \
	if [ -z "$$image_id" ]; then \
		echo "Image ID not found"; exit 1; \
	fi; \
    echo "Found ID: $$image_id"; \
    sed -i''".bak" "s/image:.*/image: $$image_id/g" $(TARGET)/UI/ui.yaml; \
    rm $(TARGET)/UI/ui.yaml.bak

$(TARGET).zip:
	rm -f $@; cd $(TARGET); zip ../$@ -r *; cd ..
