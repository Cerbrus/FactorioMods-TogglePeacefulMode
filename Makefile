name := $(shell jq -r .name < info.json)
ver := $(shell jq -r .version < info.json)

convert = rsvg-convert -w 64 < $< > $@
optipng = optipng -strip all -o7 -zm1-9 $@

.PHONY: clean here zip install

here: thumbnail.png war.png

clean:
	$(RM) -r $(name) *.png *.zip

thumbnail.png: war.svg pace.css
	$(convert) -s pace.css
	$(optipng)

war.png: war.svg
	$(convert)
	$(optipng)

$(name)_$(ver).zip: *.json *.lua thumbnail.png war.png migrations locale
	mkdir $(name)
	cp --reflink=auto --parents -r $^ $(name)
	find $(name) -exec touch -amd @0 {} +
	zip -r9 $@ $(name)
	$(RM) -r $(name)

dist: $(name)_$(ver).zip

install: zip
	cp $(name)_$(ver).zip ~/.factorio/mods
