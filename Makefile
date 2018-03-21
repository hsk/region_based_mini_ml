#!/Usr/bin/make -f

.PHONY: all clean

all:
	$(MAKE) -C src all

clean:
	$(MAKE) -C src clean

run:
	src/region_ml

