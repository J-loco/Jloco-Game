plugins {
    java
}

group = "org.starloco.locos"
// Version from git ("dev" without git, e.g. in the Docker build).
version = runCatching {
    providers.exec {
        commandLine("git", "describe", "--tags", "--always", "--dirty")
        isIgnoreExitValue = true
    }.standardOutput.asText.get().trim()
}.getOrNull()?.takeIf { it.isNotEmpty() } ?: "dev"

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}

// Historical layout: sources directly in src/, classpath resources (translations, names) in src/resources/.
sourceSets {
    main {
        java.setSrcDirs(listOf("src"))
        resources.setSrcDirs(listOf("src/resources"))
    }
}

repositories {
    mavenCentral()
}

dependencies {
    implementation(libs.hikaricp)
    implementation(libs.commons.lang)
    implementation(libs.mina.core)
    implementation(libs.mysql.connector)
    implementation(libs.slf4j.api)
    implementation(libs.logback.classic)
    implementation(libs.jjwt.api)
    implementation(libs.jansi)
    implementation(libs.joda.time)
    implementation(libs.snakeyaml)
    implementation(libs.reflections)

    runtimeOnly(libs.jjwt.impl)
    runtimeOnly(libs.jjwt.jackson)

    // Not published on Maven Central: the Lua VM (org.classdump.luna) and the Jep expression parser
    // (com.singularsys.jep, used by common/ConditionParser).
    implementation(files("libs/luna-all-shaded-0.4.2-SNAPSHOT.jar", "libs/jep.jar"))

    constraints {
        // jjwt-jackson 0.11.5 is built against this version; keep it whatever other libraries ask for.
        runtimeOnly(libs.jackson.databind)
    }
}

tasks.withType<JavaCompile>().configureEach {
    options.encoding = "UTF-8"
    options.release = 21
}

// Self-contained game.jar (start.bat, build.sh and docker/init-game.sh run `java -jar game.jar`).
tasks.jar {
    archiveFileName = "game.jar"
    duplicatesStrategy = DuplicatesStrategy.EXCLUDE
    manifest {
        attributes(
            "Main-Class" to "org.starloco.locos.kernel.Main",
            "Implementation-Version" to project.version,
        )
    }
    dependsOn(configurations.runtimeClasspath)
    from({ configurations.runtimeClasspath.get().map { if (it.isDirectory) it else zipTree(it) } })
    // Signatures of the bundled libraries would not match the merged jar.
    exclude("META-INF/*.SF", "META-INF/*.DSA", "META-INF/*.RSA")
}
