NAME=terraform-tfenv
VERSION=3.0.0
ITERATION=1
BUILD=build
DIST=dist
ARCHIVE=$(BUILD)/$(VERSION).tar.gz
ARCHIVE_DIR=$(BUILD)/$(NAME)
DEB=$(DIST)/$(NAME)_$(VERSION)-$(ITERATION)_all.deb
RPM=$(DIST)/$(NAME)_$(VERSION)-$(ITERATION).noarch.rpm


.PHONY: all
all: deb rpm


.PHONY: deb
deb: $(DEB)


.PHONY: rpm
rpm: $(RPM)


# dependencies explained:
# bash: clearly
# curl: used for downloading terraform
# unzip: used to unpack terraform
# perl: used to verify shasum of download
$(DEB): $(ARCHIVE_DIR) $(DIST)
	fpm -t deb -p $(DEB) \
		-s dir -n $(NAME) -v $(VERSION) --iteration $(ITERATION) -a all \
		-d bash -d curl -d unzip \
		--url https://github.com/tfutils/tfenv \
		--description "Terraform version manager inspired by rbenv" \
		--license MIT \
		--directories /usr/lib/tfenv \
		--after-install scripts/after-install.sh \
		--after-remove scripts/after-remove.sh \
		$(ARCHIVE_DIR)/bin/=/usr/lib/tfenv/bin \
		$(ARCHIVE_DIR)/lib/=/usr/lib/tfenv/lib \
		$(ARCHIVE_DIR)/libexec/=/usr/lib/tfenv/libexec \
		$(ARCHIVE_DIR)/share/=/usr/lib/tfenv/share \
		$(ARCHIVE_DIR)/versions/=/usr/lib/tfenv/versions \
		bin/=/usr/bin \


$(RPM): $(ARCHIVE_DIR) $(DIST)
	fpm -t rpm -p $(RPM) \
		-s dir -n $(NAME) -v $(VERSION) --iteration $(ITERATION) -a all \
		-d bash -d curl -d unzip \
		--url https://github.com/tfutils/tfenv \
		--description "Terraform version manager inspired by rbenv" \
		--license MIT \
		--directories /usr/lib/tfenv \
		--after-install scripts/after-install.sh \
		--after-remove scripts/after-remove.sh \
		$(ARCHIVE_DIR)/bin/=/usr/lib/tfenv/bin \
		$(ARCHIVE_DIR)/lib/=/usr/lib/tfenv/lib \
		$(ARCHIVE_DIR)/libexec/=/usr/lib/tfenv/libexec \
		$(ARCHIVE_DIR)/share/=/usr/lib/tfenv/share \
		$(ARCHIVE_DIR)/versions/=/var/lib/tfenv/versions \
		bin/=/usr/bin


$(ARCHIVE_DIR): $(ARCHIVE)
	mkdir $(ARCHIVE_DIR)
	tar -xvf $(ARCHIVE) -C $(ARCHIVE_DIR) --strip 1
	mkdir $(ARCHIVE_DIR)/versions
	sed -i 's:$${TFENV_ROOT}/version:/var/lib/tfenv/version:g' $(ARCHIVE_DIR)/**/*


$(ARCHIVE): $(BUILD)
	wget https://github.com/tfutils/tfenv/archive/refs/tags/v$(VERSION).tar.gz -O $(ARCHIVE)




$(BUILD):
	mkdir $(BUILD)


$(DIST):
	mkdir $(DIST)


.PHONY: clean
clean:
	rm -rf $(BUILD)
	rm -rf $(DIST)

.PHONY: docker_build
docker_build:
	docker build -t tfenv/builder:latest .
	docker run -it --rm -v ${PWD}:/work -w /work tfenv/builder:latest make
