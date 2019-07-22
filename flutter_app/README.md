# About flutter_app

关于项目的一些问题（不是很专业的术语，希望能帮解决问题）

## Question

1、multi_image_picker 依赖库的版本问题

报错代码：
	Suggestion: use a compatible library with a minSdk of at most 16,
                or increase this project's minSdk version to at least 19,
                or use tools:overrideLibrary="com.vitanov.multiimagepicker" to force usage (may lead to runtime failures)
解决:
	试着去尝试第三种方式添加依赖还是会报错
	因为插件库和本身的SDK版本不兼容的问题，只好强行提升本身的Sdk版本
	在项目的flutter_app\android\app\build.gradle
	找到
		android {
		    compileSdkVersion 28

		    lintOptions {
		        disable 'InvalidPackage'
		    }

		    defaultConfig {
		        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
		        applicationId "com.example.flutter_app"
		        minSdkVersion 16	//将次更改成最低版本的SDK
		        targetSdkVersion 28
		        versionCode flutterVersionCode.toInteger()
		        versionName flutterVersionName
		        testInstrumentationRunner "android.support.test.runner.AndroidJUnitRunner"
		    }

		    buildTypes {
		        release {
		            // TODO: Add your own signing config for the release build.
		            // Signing with the debug keys for now, so `flutter run --release` works.
		            signingConfig signingConfigs.debug
		        }
		    }
		}