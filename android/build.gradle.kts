// In android/build.gradle.kts

plugins {
    // DO NOT specify versions here.
    // The Flutter plugin will apply the correct versions automatically.
    id("com.android.application") apply false
    id("org.jetbrains.kotlin.android") apply false
    id("dev.flutter.flutter-gradle-plugin") apply false
}

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}