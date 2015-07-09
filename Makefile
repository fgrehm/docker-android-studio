.PHONY: build
build:
	docker build -t fgrehm/android-studio:141.1980579 .
	docker tag -f fgrehm/android-studio:141.1980579 fgrehm/android-studio:latest

.PHONY: hack
hack: build
	@for dir in .studio-home .gradle .idea .android/avd; do \
		mkdir -p .docker-dev/$$dir; done
	xhost +
	docker run -ti --rm \
						--net=host \
						--name android-studio \
						--privileged \
						-e DISPLAY \
						-e GRADLE_USER_HOME='/workspace/.docker-dev/.gradle/home' \
						-v /tmp/.X11-unix:/tmp/.X11-unix \
						-v `pwd`:/workspace \
						-v `pwd`/.docker-dev/.studio-home:/home/developer/.AndroidStudio1.2\
						-v `pwd`/.docker-dev/.android/avd:/home/developer/.android/avd \
						fgrehm/android-studio \
						bash
	xhost -
