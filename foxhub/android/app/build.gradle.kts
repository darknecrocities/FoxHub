plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle plugin must come last
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.foxhub"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        // ✅ Updated for Java 11 (fixes Java 8 warnings)
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.foxhub"
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true // Prevent 64K method limit errors
    }

    // ✅ Use debug signing temporarily to avoid key.jks error
    signingConfigs {
        getByName("debug") {
            // Default debug key automatically handled by Android Studio
        }
    }

    buildTypes {
        getByName("debug") {
            isMinifyEnabled = false
        }
        getByName("release") {
            // ✅ Use debug signing temporarily (for testing builds)
            signingConfig = signingConfigs.getByName("debug")

            // Enable shrinking and obfuscation
            isMinifyEnabled = true
            isShrinkResources = true

            // ProGuard settings
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Add ML Kit dependencies to fix missing class errors
    implementation("com.google.mlkit:text-recognition:16.0.0")
    implementation("com.google.mlkit:text-recognition-chinese:16.0.0")
    implementation("com.google.mlkit:text-recognition-devanagari:16.0.0")
    implementation("com.google.mlkit:text-recognition-japanese:16.0.0")
    implementation("com.google.mlkit:text-recognition-korean:16.0.0")

    // ✅ Multidex support for large apps
    implementation("androidx.multidex:multidex:2.0.1")
}
