.PHONY: build
build:
	docker build -t fschl/android-studio:151 .
	docker tag fschl/android-studio:151 fschl/android-studio:latest

.PHONY: hack
hack: build
	./android-studio
