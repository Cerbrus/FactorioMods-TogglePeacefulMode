name := $(shell jq -r .name < info.json)
ver := $(shell jq -r .version < info.json)
optipng = optipng -strip all -o7 -zm1-9 $@

.PHONY: clean zip install

all: thumbnail.png war.png

clean:
	rm -rf $(name) *.png *.zip

thumbnail.png: war.svg pace.css
	rsvg-convert -s pace.css -w 64 < $< > $@
	$(optipng)

war.png: war.svg
	rsvg-convert -w 64 < $< > $@
	$(optipng)

TogglePeacefulMode_$(ver).zip: *.json thumbnail.png war.png *.lua mig*/*
	mkdir $(name)
	cp --reflink=auto --parents -t $(name) $^
	touch -amd @0 $(name)/**
	zip -r9 $@ $(name)/*
	rm -rf $(name)

zip: TogglePeacefulMode_$(ver).zip

install: zip
	cp TogglePeacefulMode_$(ver).zip ~/.factorio/mods
