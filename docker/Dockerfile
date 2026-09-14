# syntax=docker/dockerfile:1
# StarLoco-Game image. The jar is built inside the image: no need to run ./gradlew jar beforehand.
# Build context: the StarLoco-Game directory (see .dockerignore).

FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /src
COPY gradlew settings.gradle.kts build.gradle.kts ./
COPY gradle ./gradle
COPY libs ./libs
RUN --mount=type=cache,target=/root/.gradle sh ./gradlew --no-daemon --quiet dependencies > /dev/null
COPY src ./src
RUN --mount=type=cache,target=/root/.gradle sh ./gradlew --no-daemon --quiet jar

FROM amazoncorretto:21-alpine

ENV STARLOCO_CONFIG_PATH=/app/config/game.config.properties

COPY ./docker/init-game.sh /init-game.sh
COPY ./docker/game.config.properties /embedded/game.config.properties
COPY ./scripts /embedded/scripts/

COPY --from=build /src/build/libs/game.jar /app/game.jar

RUN chmod +x /init-game.sh

VOLUME ["/app/config"]
WORKDIR /app

CMD ["/init-game.sh"]
