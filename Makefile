ALL_MK_FILES := src.mk inc.mk test_src.mk libbench2_src.mk threads_src.mk

.PHONY: all

all: $(ALL_MK_FILES)

src.mk:
	python mklinks.py ../ && \
	find . -name '*.c' -a ! -path './tests/*' -a ! -path './libbench2/*' -a ! -path './threads/*'\
	| xargs echo LOCAL_SRC_FILES ':=' > src.mk

test_src.mk: src.mk
	find . -name '*.c' -a  -path './tests/*' | grep -v 'trigtest.c' | xargs echo LOCAL_SRC_FILES ':=' > test_src.mk

threads_src.mk: src.mk
	find . -name '*.c' -a  -path './threads/*' | grep -v 'openmp.c' | xargs echo LOCAL_SRC_FILES ':=' > threads_src.mk

libbench2_src.mk: src.mk
	find . -name '*.c' -a  -path './libbench2/*' | xargs echo LOCAL_SRC_FILES ':=' > libbench2_src.mk

inc.mk: src.mk
	find . -name '*.h' -exec dirname {} \; | sort | uniq | sed "s/^\./$$\(LOCAL_PATH)/g" | grep -v 'tests' | \
	xargs echo 'LOCAL_C_INCLUDES :=' > inc.mk

clean:
	rm -fr api/ dft/ kernel/ rdft/ reodft/ tests/ libbench2/ threads/ config.h $(ALL_MK_FILES)

ndk_build:
	$(HOME)/android/current-ndk/ndk-build
