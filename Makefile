.PHONY: build
build:
	docker build -t fgrehm/android-studio:141.1980579 .
	docker tag -f fgrehm/android-studio:141.1980579 fgrehm/android-studio:latest

.PHONY: hack
hack: build
	./android-studio
