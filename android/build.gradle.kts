allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

plugins {
    // Google Services plugin
    id("com.google.gms.google-services") version "4.4.2" apply false
    // ✅ Kotlin plugin (updated to fix your build issue)
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
