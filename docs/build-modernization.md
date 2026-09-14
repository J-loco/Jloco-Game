# StarLoco-Game: build modernization plan

Status: done (2026-09-14). Results in "Outcome" at the end.

## Context

StarLoco-Login was migrated to a modern Gradle build (see `StarLoco-Login/docs/modernization.md`).
The game server's build has problems that don't need a tool change to fix:

| # | Problem | Consequence |
|---|---|---|
| B1 | `.gitignore` excludes `gradlew`, `gradlew.bat` and `gradle/` | A fresh clone has no wrapper: builds depend on whatever Gradle is installed (`build.sh` and `release.yaml` call a global `gradle`) |
| B2 | `build.gradle` runs `'git rev-parse …'.execute()` | The build fails where `git` isn't installed (Docker build stages, some CI images) |
| B3 | 25 jars vendored in `libs/`, pulled in with `fileTree` | No visible versions, and 7 of them are never imported. The vendored `javassist.jar` (2014) duplicates the javassist that `reflections` 0.10.2 needs; which one ends up in the fat jar depends on classpath order. |
| B4 | The Docker image copies `build/libs/game.jar` | `./gradlew jar` must be run by hand before `docker compose build starloco_game`, otherwise the image silently ships an old jar |
| B5 | `release.yaml` uses outdated or unpinned actions (`actions/checkout@master`, `docker/*@v2/v4`, the unmaintained `marvinpinto/action-automatic-releases@latest`), and there is no CI on push | Releases are fragile; nothing checks that `master` builds |

Goal: same build setup as StarLoco-Login, **without changing runtime behaviour**. Library upgrades are a separate,
later step (see "Not in this plan").

## Scope

### 1. Wrapper and line endings
- Stop ignoring `gradlew`, `gradlew.bat`, `gradle/`, and upgrade the wrapper to Gradle 9.7.1 (same as the login server).
- Add `.gitattributes`: `gradlew` and `*.sh` in LF (a CRLF checkout breaks them in Linux containers), `*.bat` in CRLF,
  jars binary.
- `build.sh` calls `./gradlew jar` instead of a global `gradle`.

### 2. Kotlin DSL build with a version catalog
- `settings.gradle.kts` (with the foojay toolchain resolver) and `build.gradle.kts` replace the Groovy files.
- The Java 21 toolchain and `options.release = 21` are kept.
- The version comes from `git describe`, falling back to `dev` when git is missing (fixes B2).
- Layout unchanged: sources stay in `src/` and resources in `src/resources/`. Moving 263 files to `src/main/java`
  would only add churn (and break the line references in CLAUDE.md).
- The `jar` task still builds the fat `game.jar` with `Main-Class: org.starloco.locos.kernel.Main`, so `start.bat`,
  `build.sh` and `docker/init-game.sh` keep working.

### 3. Dependencies from Maven Central, same versions
All versions go in `gradle/libs.versions.toml` and **keep the version of the jar they replace**:

| Library | Version | Used by |
|---|---|---|
| HikariCP | 4.0.3 | database pools |
| commons-lang | 2.6 | 46 files |
| mina-core | 2.0.9 | game and exchange sockets |
| mysql-connector-java | 5.1.44 | JDBC (`com.mysql.jdbc.Statement` imports) |
| slf4j-api / logback-classic | 1.7.9 / 1.1.2 | logging (logback levels set in code) |
| jjwt api/impl/jackson | 0.11.5 (+ jackson-databind 2.12.6.1 pinned) | character switch token |
| jansi | 1.7 | `kernel/Main` console colours |
| joda-time | 2.6 | `guild/GuildMember` |
| snakeyaml | 1.11 | `lang/LangEnum` translations |
| reflections | 0.10.2 (already from Central) | message/handler discovery |

- **Still vendored in `libs/`** (not on Maven Central, referenced explicitly by name, no more `fileTree`):
  `luna-all-shaded-0.4.2-SNAPSHOT.jar` (Lua VM) and `jep.jar` (`com.singularsys.jep`, `common/ConditionParser`).
- **Removed** (never imported):
  - `commons-cli`, `commons-logging`, `config` (typesafe), `fastutil`, `protobuf-java`, `log4j`;
  - `javassist.jar`: `reflections` brings the version it needs;
  - the direct jackson jars: they come transitively from jjwt-jackson, pinned to the same version;
  - `redis.clients:jedis`: no code references it; the Redis container stays in compose.
- **Check that nothing runtime-only was lost:**
  - `jdeps` on the runtime classpath reports no missing packages;
  - the game server starts in Docker, loads its data and Lua scripts, and authenticates with the login server;
  - a player logs in.

### 4. Docker builds the jar (fixes B4)
- `docker/Dockerfile` gets a build stage (`eclipse-temurin:21-jdk-alpine`, Gradle cache mount) running `./gradlew jar`.
  The runtime stage stays `amazoncorretto:21-alpine` with the same `init-game.sh`.
- A `.dockerignore` keeps the build context small and secret-free: `.git`, `.env`, `build`, `.gradle`, `db-init`,
  `db-correction`, `config`, `logs`, `game.sql`.
- The "run `./gradlew jar` first" notes are removed from the compose comments and the CLAUDE.md files.

### 5. CI and release (fixes B5)
- `.github/workflows/ci.yml` on push/PR:
  - `./gradlew build` on Temurin 21 with `gradle/actions/setup-gradle`, uploading `game.jar`;
  - a Docker image build.
- `release.yaml` rewritten like StarLoco-Login's: current action versions, the Docker Hub push, a GitHub release with
  `game.jar` (softprops/action-gh-release).
- Both lint clean with actionlint.

## Not in this plan (and why)

- **Error Prone with `-Werror`** (as in the login server): it would fail on thousands of warnings in this codebase.
  It can be added later in warning-only mode, one package at a time.
- **Spotless formatting:** it formats whole files, so touching one line of `fight/Fight.java` (5,800 lines) would
  reformat all of it. Worth doing only as one dedicated formatting commit agreed in advance.
- **Library upgrades** (MINA 2.2, MariaDB Connector/J instead of mysql-connector 5.1, jjwt 0.12+, logback 1.5+,
  snakeyaml 2): these change runtime behaviour and need testing in game. They are a separate step, and much easier
  once versions sit in the catalog. Done afterwards: see "Library upgrades" below.
- **Unit tests:** the game has none; the `test` source set and JUnit can come with the first tested change.

## Verification

1. `./gradlew build` passes with the wrapper on a clean checkout, and `game.jar` has the same main class and no missing
   dependencies (`jdeps --missing-deps` on the runtime classpath).
2. `docker compose build starloco_game` works **without** running `./gradlew jar` first (with `build/` deleted).
3. `docker compose up -d starloco_game`:
   - the server loads its data;
   - it logs "The login server has validated the connection";
   - the login server logs "Game server 601 authenticated".
4. A scripted client logs in through the login server and is sent to server 601; the game server loads the account.
5. actionlint passes on both workflows.

## Outcome (2026-09-14)

- `game.jar`: 29 MB → 9 MB. Only never-imported libraries left it (fastutil, jedis with gson/org.json/commons-pool,
  log4j, protobuf, typesafe-config, commons-cli/logging). Every game class and resource is identical.
- `jdeps --missing-deps`, old jar (from the previous image) against the new one: the only newly missing package is
  `com.google.gson`, used by the optional `org.reflections.serializers.JsonSerializer`, which the game doesn't use.
- `docker compose build starloco_game` with no `build/` directory: the image builds the jar itself.
- The rebuilt server:
  - loaded its data and Lua scripts;
  - was validated by the login server ("Game server 601 authenticated");
  - received a scripted login ("Loading account #14").
  - The only error at startup is a data issue (extra monster 2432 has no map).
- `./gradlew build` passes; `ci.yml` and `release.yaml` pass actionlint. The old release workflow's Docker Hub README
  sync step (`peter-evans/dockerhub-description@v2`) was dropped.

## Library upgrades (2026-09-14)

| Library | Before | After | Code change |
|---|---|---|---|
| JDBC driver | mysql-connector-java 5.1.44 | MariaDB Connector/J 3.5.10 | `DatabaseManager` uses a `jdbc:mariadb://` URL; `com.mysql.jdbc.Statement` imports became `java.sql.Statement` (6 DAOs) |
| HikariCP | 4.0.3 | 7.1.0 | none |
| commons-lang | 2.6 | commons-lang3 3.20.0 | package rename for `NotImplementedException` (45 files) |
| `StringEscapeUtils.unescapeJava` | commons-lang 2.6 | `common/JavaEscapes` | see below |
| MINA | 2.0.9 | 2.2.9 | none |
| slf4j / logback | 1.7.9 / 1.1.2 | 2.0.19 / 1.6.3 | none |
| jjwt | 0.11.5 | 0.13.0 | `GameClient.switchCharacter` uses the non-deprecated builder (`issuer()`, `Jwts.SIG.HS256`) |
| jansi | 1.7 | 2.4.3 | `AnsiConsole.out` is now a method |
| snakeyaml | 1.11 | 2.7 | none |
| joda-time | 2.6 | removed | `GuildMember` uses `java.time` |

Unchanged: reflections 0.10.2 (latest release), and the vendored `luna` and `jep`.

**Details:**
- **`unescapeJava`:** commons-lang3 and commons-text decode differently from commons-lang 2.6: octal escapes, and
  unknown or trailing backslashes. On 500,000 generated strings, commons-text decoded 69,939 of the 159,000 that
  contain a backslash differently (44%). `CryptManager` decrypts client data with it, so `common/JavaEscapes`
  reimplements the 2.6 behaviour: on 2,000,000 generated strings (720,953 with a backslash) it matches
  commons-lang 2.6 exactly.
- **Logging:** the MariaDB driver logs every query with its values at DEBUG, and the game runs with logback's
  default DEBUG configuration. `DatabaseManager` sets `org.mariadb.jdbc` to WARN. It also fixes the HikariCP
  `PoolBase` logger name, which had "DEBUG " in front of it and so was never silenced.
- **Fat jar:** it no longer carries the libraries' `module-info.class` files (a merged jar isn't a module).
- **Missing dependencies:** `jdeps` reports none for classes of the game, `luna` or `jep`. The new unresolved
  packages are optional features of the libraries (MariaDB Unix sockets and AWS/GSSAPI authentication, logback
  SMTP/servlet/XZ, HikariCP metrics, reflections' gson serializer).

**Checked against the running stack** (test accounts removed afterwards):
- the server started and loaded its data and Lua scripts; the login server validated it;
- a scripted player went through the login server to game server 601:
  - ticket (`ATK0`), character list;
  - character creation (`AAK`, an INSERT reading the generated id back through the new driver);
  - selection (`ASK`), entering the world (`GDM` map data);
  - on disconnect the character was saved (map, cell, logged = 0);
  - it was then deleted through the game (`AD`);
- character switch: the game server's HS256 token (jjwt 0.13) was accepted by the login server;
- no exception or warning in the game log.

The module-info exclusion and the driver log level were built after those checks; restart `starloco_game` to run
them.
