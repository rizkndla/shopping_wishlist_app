android {
    compileSdk = 34
    
    defaultConfig {
        applicationId = "com.example.shopping_wishlist_app"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
        
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }
    
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
        isCoreLibraryDesugaringEnabled = true
    }
    
    kotlinOptions {
        jvmTarget = "21"
    }
    
    // TAMBAHKAN KONFIGURASI TEST OPTIONS
    testOptions {
        unitTests {
            isIncludeAndroidResources = true
            all {
                it.jvmArgs("-noverify")
            }
        }
    }
    
    buildTypes {
        debug {
            isTestCoverageEnabled = true
        }
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    
    // TAMBAHKAN BUILD FEATURES
    buildFeatures {
        buildConfig = true
    }
}

// KONFIGURASI TOOLCHAIN KHUSUS UNTUK TEST
tasks.withType<Test>().configureEach {
    javaLauncher.set(
        javaToolchains.launcherFor {
            languageVersion.set(JavaLanguageVersion.of(21))
        }
    )
}

androidComponents {
    onVariants(selector().all()) { variant ->
        variant.instrumentationRunnerArguments.put(
            "notClass",
            "org.junit.internal.runners.JUnit38ClassRunner"
        )
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    
    // Test dependencies
    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test.ext:junit:1.1.5")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.5.1")
    
    // Flutter dependencies
    implementation(project(":flutter"))
}