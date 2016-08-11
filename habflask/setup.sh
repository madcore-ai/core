#!/bin/bash
pushd /opt/controlbox/habflask
	sudo hab origin key generate flaskkey
	sudo hab pkg build flask -k flaskkey
popd
