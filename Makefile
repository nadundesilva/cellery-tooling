#  Copyright (c) 2019 WSO2 Inc. (http:www.wso2.org) All Rights Reserved.
#
#  WSO2 Inc. licenses this file to you under the Apache License,
#  Version 2.0 (the "License"); you may not use this file except
#  in compliance with the License.
#  You may obtain a copy of the License at
#
#  http:www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing,
#  software distributed under the License is distributed on an
#  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#  KIND, either express or implied.  See the License for the
#  specific language governing permissions and limitations
#  under the License.

PROJECT_ROOT := $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
PROJECT_PKG := github.com/cellery-io/mesh-observability
VERSION := 0.5.0-SNAPSHOT


all: clean init build package



.PHONY: clean
clean: clean.blangserver-plugins clean.extensions

.PHONY: clean.blangserver-plugins
clean.blangserver-plugins:
	cd components/blangserver-plugins; \
	mvn clean

.PHONY: clean.extensions
clean.extensions: clean.extensions.vscode

.PHONY: clean.extensions.vscode
clean.extensions.vscode:
	cd components/extensions/vscode; \
	npm run clean


.PHONY: init
init: clean init.blangserver-plugins init.extensions

.PHONY: init.blangserver-plugins
init.blangserver-plugins: clean.blangserver-plugins
	@:

.PHONY: init.extensions
init.extensions: clean.extensions init.extensions.vscode

.PHONY: init.extensions.vscode
init.extensions.vscode: clean.extensions.vscode
	cd components/extensions/vscode; \
	npm ci


.PHONY: build
build: init build.blangserver-plugins build.extensions

.PHONY: build.blangserver-plugins
build.blangserver-plugins: init.blangserver-plugins
	cd components/blangserver-plugins; \
	mvn install

.PHONY: build.extensions
build.extensions: init.extensions build.blangserver-plugins build.extensions.vscode

.PHONY: build.extensions.vscode
build.extensions.vscode: init.extensions.vscode
	cd components/extensions/vscode; \
	npm run compile:prod


.PHONY: package
package: build package.extensions

.PHONY: package.extensions
package.extensions: build.extensions package.extensions.vscode

.PHONY: package.extensions.vscode
package.extensions.vscode: build.extensions.vscode
	cd components/extensions/vscode; \
	npm run package
