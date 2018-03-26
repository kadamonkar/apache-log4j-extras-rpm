.PHONY: help

BUILD_NUMBER?=0
BRANCH_TYPE?=$(shell git symbolic-ref --short HEAD 2>/dev/null | cut -d / -f 1)
VERSION?=$(shell git symbolic-ref --short HEAD 2>/dev/null | cut -d / -f 2)
JAVA_LIB_DIR?=/usr/share/java
RPMBUILD_TOP_DIR?=$(PWD)/rpmbuild

OUTPUT_DIR?=$(PWD)/output/$(BRANCH_TYPE)/$(VERSION) 

help: 
	@echo "make rpm"

rpm: clean package-apache-log4j-extras


clean: 
	mvn clean
	rm -rf $(RPMBUILD_TOP_DIR) $(OUTPUT_DIR)


package-apache-log4j-extras:
	mvn clean package -DskipTests
	mkdir -p $(RPMBUILD_TOP_DIR)/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
	mv ./target/apache-log4j-extras-$(VERSION)-bin.tar.gz $(RPMBUILD_TOP_DIR)/SOURCES/
	cp  apache-log4j-extras.spec $(RPMBUILD_TOP_DIR)/SPECS/
	rpmbuild --define "_topdir $(RPMBUILD_TOP_DIR)" \
                 --define "_VERSION $(VERSION)" \
                 --define "_BUILD_NUMBER $(BUILD_NUMBER)" \
		 --define "_javalibdir $(JAVA_LIB_DIR)" \
                 -ba $(RPMBUILD_TOP_DIR)/SPECS/apache-log4j-extras.spec
	mkdir -p $(OUTPUT_DIR)
	mv $(RPMBUILD_TOP_DIR)/RPMS/x86_64/apache-log4j-extras*.rpm $(OUTPUT_DIR)
