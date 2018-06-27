################################################################################
#                                                                              #
#                 Copyright (c) 2018, Cauldron Development LLC                 #
#                             All rights reserved.                             #
#                                                                              #
#     This file ("the software") is free software: you can redistribute it     #
#     and/or modify it under the terms of the GNU General Public License,      #
#      version 2 as published by the Free Software Foundation. You should      #
#      have received a copy of the GNU General Public License, version 2       #
#     along with the software. If not, see <http: #www.gnu.org/licenses/>.     #
#                                                                              #
#     The software is distributed in the hope that it will be useful, but      #
#          WITHOUT ANY WARRANTY; without even the implied warranty of          #
#      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU       #
#               Lesser General Public License for more details.                #
#                                                                              #
#       You should have received a copy of the GNU Lesser General Public       #
#                License along with the software.  If not, see                 #
#                       <http: #www.gnu.org/licenses/>.                        #
#                                                                              #
#                For information regarding this software email:                #
#              "Joseph Coffland" <joseph@cauldrondevelopment.com>              #
#                                                                              #
################################################################################

DIR := $(shell dirname $(lastword $(MAKEFILE_LIST)))

DEST := johndoe@example.org:

NODE_MODS  := $(DIR)/node_modules
PUG        := $(NODE_MODS)/.bin/pug
STYLUS     := $(NODE_MODS)/.bin/stylus
BROWSERIFY := $(NODE_MODS)/.bin/browserify
JSHINT     := $(NODE_MODS)/.bin/jshint

HTML      := index
HTML      := $(patsubst %,http/%.html,$(HTML))
CSS       := style
CSS       := $(patsubst %,http/css/%.css,$(CSS))
JS        := $(wildcard src/js/*.js)
JS_ASSETS := http/js/assets.js
TEMPLS    := $(wildcard src/pug/templates/*.pug)
STATIC    := $(wildcard src/images/*)
STATIC    := $(patsubst src/%,http/%,$(STATIC))


all: node_modules $(HTML) $(CSS) $(JS_ASSETS) $(STATIC) lint

publish: all
	rsync -rv http/ $(DEST)

http/index.html: build/templates.pug

http/%: src/%
	mkdir -p $(shell dirname $@)
	cp $< $@

http/%.html: src/pug/%.pug
	$(PUG) -P $< --out $(shell dirname $@) || \
	(rm -f $@; exit 1)

http/css/%.css: src/stylus/%.styl
	mkdir -p $(shell dirname $@)
	$(STYLUS) --inline -r $< -o $(shell dirname $@) || (rm -f $@; exit 1)

build/templates.pug: $(TEMPLS)
	mkdir -p build
	cat $(TEMPLS) >$@

$(JS_ASSETS): $(JS)
	@mkdir -p $(shell dirname $@)
	$(BROWSERIFY) src/js/main.js -s main -o $@ || \
	(rm -f $@; exit 1)

lint:
	$(JSHINT) --config jshint.json src/js/*.js

node_modules:
	npm install

watch:
	@clear
	$(MAKE)
	@while sleep 1; do \
	  inotifywait -qr -e modify -e create -e delete \
		--exclude .*~ --exclude \#.* $(WATCH); \
	  clear; \
	  $(MAKE); \
	done


tidy:
	rm -rf $(shell find . -name \*~ -o -name \#\*)

clean: tidy
	rm -rf http build
