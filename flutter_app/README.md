# About flutter_app

关于项目的一些问题（不是很专业的术语，希望能帮解决问题）
或许你有更好的方案解决可以发邮箱联系我,让我认识到自己的愚蠢
邮箱：qinshibin0412@163.com

## Question

一、安装经验分享：
	至于怎么安装网上有一堆教程很方便，这里就不去细说了，当然我这里本身是前端开发，有很多东西不是很理解
	首先，第一次我用的是JAVA11作为环境AS会报错找不到SDK，我确定环境变量是没有错误的，百度了一下（原谅我穷逼，买不起翻墙的工具，当然不要钱的我也不会蹭，好菜鸡哦），说一般安装完JAVA都会有一个jre文件，可是我这里没有，我没有办法就继续爬坑，java8很好的帮我解决了这个问题，这个也是我一直不明白的地方。
	其次，还有一127.0.0.1的报错问题，以为是自己没有数据库的问题，找了半天发现这东西和虚拟机有关系，错误代码我也忘记保存了，如果以后各位像我这样菜鸡的开发的话，我很忧伤，毕竟这样的人不多了，解决办法就是，你的虚拟机不要超过8.1版本就可以了轻松解决这个问题。
	关于虚拟机，百度能找到的只有夜神，和雷电，当然AS.VS上也有自己的虚拟机，开发可以使用，版本测试的话建议使用雷电，因为夜神配置麻烦了，看了一本各路大神的操作，不是我等辣鸡能理解的。
	最后，希望还在爬坑的技术人员找到理想的归宿，完结。
	祝大家天天大吉吧！！！


二、开发问题

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
		        minSdkVersion 16	//将minSdkVersion更改成最低版本的SDK
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

程序崩溃问题：
	
	This error should no longer be present in version 3 of the plugin, as I've migrated it from the deprecated Android Support Library to AndroidX. If you are using multi_image_picker 3.* do not do this.

需要将原来的老项目迁移，迁移步骤 Google 官方有给出流程，首先在 gradle.properties 文件中添加

	// 表示使用 androidx
	android.useAndroidX=true
	// 表示将第三方库迁移到 androidx
	android.enableJetifier=true

然后菜单栏 Refactor -> Migrate to Androidx 就可以了，Android Studio 会自动把你项目中的依赖切换到 Androidx，并且修改项目中使用到依赖库的路径


三、打包问题

1、APP签名问题
错误代码：

	Keystore was tampered with, or password was incorrect

解决：起初一直以为是APP密匙的问题，认真对了keyPassword和storePassword几次都是正确的，那么这个时候我就怀疑是不是我自己的环境配错了，起初修改android目录下的builder文件，指定导包的key文件地址，发现一直失败，后面我就放弃了这种方法的实现，用最原始的方法解决，当然也有些技术大佬能够想明白这些问题，我的方案只适合解决暂时的问题
	
	release {
            keyAlias keystoreProperties['keyAlias'] 		
            keyPassword keystoreProperties['keyPassword'] 		
            storeFile file(keystoreProperties['storeFile']) 	
            storePassword keystoreProperties['storePassword']
        }

2、第三方http库 debug模式正常release模式没有反应，打包好发布的版本一直请求不到借口，完全没有反应，当然我本身不知道怎么测试打包好的APK，那么只有继续踩坑，最终是Android开发模式中，打包的时候要给个联网的权限。在调试模式下，默认情况下启用服务扩展和多个权限（在flutter中）当您处于发布模式时，您必须手动在androidmanifest.xml中添加Internet权限。（就像您在本机开发中添加它一样）导航到android-> app-> src-> main-> AndroidManifest.xml并在应用程序范围之外添加此行。

	<uses-permission android:name="android.permission.INTERNET" />


