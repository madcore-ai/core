#!/bin/bash
pushd /opt/madcore/habflask
	sudo hab origin key generate flaskkey
	sudo hab pkg build flask -k flaskkey
popd
