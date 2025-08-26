//import java.util.Properties
//import java.io.FileInputStream
//
//val keystorePropertiesFile = rootProject.file("key.properties")
//val keystoreProperties = Properties()
//
//if (keystorePropertiesFile.exists()) {
//    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
//}
//
//plugins {
//    id("com.android.application")
//    id("kotlin-android")
//    id("dev.flutter.flutter-gradle-plugin")
//    id("com.google.gms.google-services")
//}
//
//android {
//    namespace = "com.ciggytech.funandentertainment"
//    compileSdk = flutter.compileSdkVersion
//    ndkVersion = "27.0.12077973"
//
//    defaultConfig {
//        applicationId = "com.ciggytech.funandentertainment"
//        minSdk = flutter.minSdkVersion
//        targetSdk = flutter.targetSdkVersion
//        versionCode = flutter.versionCode
//        versionName = flutter.versionName
//    }
//
//    signingConfigs {
//        create("release") {
//            storeFile = file(keystoreProperties["storeFile"] as String)
//            storePassword = keystoreProperties["storePassword"] as String
//            keyAlias = keystoreProperties["keyAlias"] as String
//            keyPassword = keystoreProperties["keyPassword"] as String
//        }
//    }
//
//    buildTypes {
//        getByName("release") {
//            isMinifyEnabled = false
//            isShrinkResources = false
//            signingConfig = signingConfigs.getByName("release")
//            proguardFiles(
//                getDefaultProguardFile("proguard-android-optimize.txt"),
//                "proguard-rules.pro"
//            )
//        }
//    }
//
//    compileOptions {
//        sourceCompatibility = JavaVersion.VERSION_11
//        targetCompatibility = JavaVersion.VERSION_11
//    }
//
//    kotlinOptions {
//        jvmTarget = JavaVersion.VERSION_11.toString()
//    }
//}
//
//flutter {
//    source = "../.."
//}



import java.util.Properties
import java.io.FileInputStream

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Required for Firebase
}

android {
    namespace = "com.ciggytech.funandentertainment"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.ciggytech.funandentertainment"
        minSdk = 21
        targetSdk = 35
        versionCode = 2
        versionName = "1.1"

    }

    signingConfigs {
        create("release") {
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("release")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase BoM - this manages all Firebase versions
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))

    // Example Firebase SDKs (add more based on what you use)
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-messaging")
    implementation("com.google.firebase:firebase-database")

    // Required for Flutter embedding and other basics
    implementation("androidx.core:core-ktx:1.10.1")
}
