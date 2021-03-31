name := $(shell jq -r .name < info.json)
ver := $(shell jq -r .version < info.json)

convert = rsvg-convert -w 64 < $< > $@
optipng = optipng -strip all -o7 -zm1-9 $@

.PHONY: clean zip install

clean:
	rm -rf $(name) *.png *.zip

thumbnail.png: war.svg pace.css
	$(convert) -s pace.css
	$(optipng)

war.png: war.svg
	$(convert)
	$(optipng)

TogglePeacefulMode_$(ver).zip: *.json thumbnail.png war.png *.lua mig*/*
	mkdir $(name)
	cp --reflink=auto --parents -t $(name) $^
	find $(name) -exec touch -amd @0 {} +
	zip -r9 $@ $(name)/*
	rm -rf $(name)

zip: TogglePeacefulMode_$(ver).zip

install: zip
	cp TogglePeacefulMode_$(ver).zip ~/.factorio/mods
