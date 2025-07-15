plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // This hardcodes the NDK version that the plugins require.
    ndkVersion = "27.0.12077973"

    // This sets a modern and stable Android SDK version.
    compileSdk = 34
    
    namespace = "com.example.myapp"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    defaultConfig {
        applicationId = "com.example.myapp"
        minSdk = 21 // Default Flutter minSdk
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // You can add other Android dependencies here if needed.
}