# 现有 Flutter 项目支持鸿蒙示例

![](https://upload-images.jianshu.io/upload_images/25776880-f6bf0857190712a0.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

通过模块化，鸿蒙壳工程，结合 FVM 管理多版本 Flutter SDK，保持原 Flutter 代码纯净，最小化修改，完成鸿蒙化的适配示例。

## 准备工作

### 1. 安装 FVM

安装 [FVM](https://fvm.app/)，更多安装方式参考 fvm 官方文档

```bash
curl -fsSL https://fvm.app/install.sh | bash
```

### 2.使用 FVM 安装 Flutter SDK

分别安装官方的Flutter版本（我这里用的比较旧，版本为 3.3.10），以及[鸿蒙社区的 3.22.0](https://gitee.com/harmonycommando_flutter/flutter) 版本

提示：安装鸿蒙定制版本的 Flutter SDK，建议使用 `git clone` 命令行（我一开始直接 download zip，出现下载不全的现象）

## 现有 Flutter 工程架构

完成准备工作后，调整现有 Flutter 的工程结构，简化后大致如下：

```dart
.
├── apps  #该目录用于存放各端应用壳工程 (示例如下)
│   ├── app  #对应Android、IOS、Windows等原Flutter框架支持的平台
│   └── app_ohos  #对应HarmonyOS平台
│
├── modules  #该目录用于存放各业务模块 (示例如下)
│   ├── home_module  #首页
│   ├── trade_module  #交易结算
│   └── memeber_module  #会员管理
│
├── common  # 该目录用于存放公共库 (示例如下)
│   ├── network 
│   ├── tools  
│   └── widgets  
│
└── README.md

```

如上所示， `/apps/app` 为我们现有的 Flutter 壳工程目录，`modules`及`common`目录是我们项目开发中封装的业务模块库及公共组件库。（当然，不一定要放在同一目录下，这里也为方便大家观察学习）

### 壳工程解耦，将`统一布局`及`三方库依赖`放在下层模块中

例如，在`home_module`模块中添加外部三方库，封装后再提供给壳工程使用。

在 `/modules/home_module/pubspec.yaml` 中添加几个典型的三方库作为示例

```dart
name: home_module
description: home_module
version: 0.0.1
homepage:

environment:
  sdk: '>=2.18.6 <3.0.0'
  flutter: ">=1.17.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^7.3.0  // 演示纯 Dart 实现的三方状态管理库
  dio: ^4.0.6           // 演示纯 Dart 实现的三方网络库
  fluttertoast: 8.1.2   // 演示依赖系统底层实现的三方库（需要鸿蒙化适配）
```

封装组件 `HomePage` 提供给壳工程，用于显示主页

![image.png](https://upload-images.jianshu.io/upload_images/25776880-bbbfa06680cc23bf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### App 壳工程

在 `/apps/app/pubspec.yaml` 中对各个业务模块及公共组件库进行依赖项添加

```dart
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  home_module:
    path: '../../module/home_module'
  ... 省略其他  
```

通过依赖 `home_module` 显示封装的首页组件

![image.png](https://upload-images.jianshu.io/upload_images/25776880-2e4a72a5291f14de.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在 Android、IOS 等平台使用通用版本的 Flutter SDK 即可
```dart
fvm use 3.3.10
```
点击运行，效果如下：

![image.png](https://upload-images.jianshu.io/upload_images/25776880-e8e7c66c24ce01e3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![flutter_app.gif](https://upload-images.jianshu.io/upload_images/25776880-ce38c81ec120fb09.gif?imageMogr2/auto-orient/strip)


### 鸿蒙壳工程

首先，我们需要在 `/apps` 目录下创建一个鸿蒙壳工程

+ #### 第一步，使用 FVM 将 Flutter 版本切换到鸿蒙化的版本

```dart
fvm use custom_3.22.0
```

+ #### 第二步，进入 `/apps` 目录，使用命令行创建 `app_ohos` 项目

```dart
fvm flutter create --template app --platforms ohos --org com.rex.flutter app_ohos
```

![image.png](https://upload-images.jianshu.io/upload_images/25776880-7c0c1ff4f3dd0a0d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

+ #### 添加依赖项

```dart
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  home_module:
    path: '../../module/home_module'
  ... 省略其他  
```
同样，通过依赖 `home_module` 显示封装的首页组件
![image.png](https://upload-images.jianshu.io/upload_images/25776880-f48fee58e3aa9f58.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

+ #### 三方库鸿蒙化适配

通过 `dependency_overrides` **替换需要鸿蒙化的底层模块中用到的三方库**，例如`app_ohos`依赖底层库`home_module`中使用到了`fluttertoast`，该库需要进行鸿蒙化替换。

```dart
// app_ohos/pubsec.yaml 
dependency_overrides:
  fluttertoast:
    git:
      url: "https://gitee.com/openharmony-sig/flutter_fluttertoast.git"
      ref: "master"
```
注意点：
> 1. app_ohos/pubsec.yaml 中的 dependency_overrides, 仅添加需要鸿蒙化的三方库
> 
> 2. 如何判断三方库是否需要鸿蒙化，简而言之，如果三方库由纯 Dart 实现，则不需要单独适配，直接使用；如果三方库依赖系统底层实现，则需要鸿蒙化适配。
> 
> 3. 三方库的适配情况，可以查询 Gitee/Github，或者查阅表格 [Flutter三方库适配计划](https://docs.qq.com/sheet/DVVJDWWt1V09zUFN2)

+ #### 运行调试

用 Deveco 打开apps/app\_ohos/ohos 目录。

在 Deveco 左上角 打开 File -> Project Structure..., 点击 Siging Configs, 勾选 Automatically generate signature, 对鸿蒙项目签名。

在 app_ohos 目录下，使用 fvm flutter run，或者点击运行按钮，运行flutter项目。

PS1：注意添加应用权限
![image.png](https://upload-images.jianshu.io/upload_images/25776880-e4b04881b10cd347.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

PS2：没有真机的同学可以使用模拟器运行
![image.png](https://upload-images.jianshu.io/upload_images/25776880-4a19a5cd18d3efa5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

运行效果如下：

![flutter_app_ohos.gif](https://upload-images.jianshu.io/upload_images/25776880-adf5f79ec71b7dd9.gif?imageMogr2/auto-orient/strip)


## 总结：

1. 通过 FVM 管理多个 Flutter SDK 版本，仅在鸿蒙调测打包时，切换到 ohos-flutter SDK
2. 通过 apps 壳工程，将鸿蒙化适配的代码，尽量在 app_ohos 项目中完成。通过 pub 包管理的 `dependency_overrides` 配置，逐个替换鸿蒙化的三方库
3. Flutter 项目进行模块化、组件化、插件化拆分，职责分离，平台抽象，不同平台组合打包，有效解决平台不一致问题





