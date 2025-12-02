import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // MUST be last
}

val keystoreProperties = Properties()
val keystorePropertiesFile = file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
    println("DEBUG KEYSTORE → $keystoreProperties")
} else {
    println("⚠️ WARNING: key.properties file NOT found!")
}

android {
    namespace = "com.bathao.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    signingConfigs {
        create("release") {

            // These MUST NOT be null
            keyAlias = keystoreProperties["keyAlias"]?.toString() ?: ""
            keyPassword = keystoreProperties["keyPassword"]?.toString() ?: ""
            storePassword = keystoreProperties["storePassword"]?.toString() ?: ""

            val storeFilePath = keystoreProperties["storeFile"]?.toString()

            storeFile = if (storeFilePath != null) {
                file(storeFilePath)
            } else {
                println("⚠️ storeFile is NULL in key.properties")
                null
            }
        }
    }

    defaultConfig {
        applicationId = "com.bathao.app"
        multiDexEnabled = true
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.android.material:material:1.11.0")
}
