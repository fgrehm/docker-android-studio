.PHONY: build
build:
	docker build -t fschl/android-studio:151 .
	docker tag -f fgrehm/android-studio:151 fgrehm/android-studio:latest

.PHONY: hack
hack: build
	./android-studio
