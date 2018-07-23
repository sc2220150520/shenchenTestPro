# LDCPWebViewController

[![CI Status](http://img.shields.io/travis/SongLi/LDCPWebViewController.svg?style=flat)](https://travis-ci.org/SongLi/LDCPWebViewController)
[![Version](https://img.shields.io/cocoapods/v/LDCPWebViewController.svg?style=flat)](http://cocoadocs.org/docsets/LDCPWebViewController)
[![License](https://img.shields.io/cocoapods/l/LDCPWebViewController.svg?style=flat)](http://cocoadocs.org/docsets/LDCPWebViewController)
[![Platform](https://img.shields.io/cocoapods/p/LDCPWebViewController.svg?style=flat)](http://cocoadocs.org/docsets/LDCPWebViewController)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

LDCPWebViewController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "LDCPWebViewController"

## Author

SongLi, chuangyi0128@gmail.com

## License

LDCPWebViewController is available under the MIT license. See the LICENSE file for more info.

## Version

* 1.0.0
    1. 回滚之前的拆分，重新拆分PopWebViewController与JSApi

* 1.0.1
    1. 精简资源文件和程序代码
    2. JsBridge资源文件外部可配

* 1.0.2
    1. 适配各类屏幕
    2. 修改HookProtocol

* 1.0.3
    1. 增加进度条

* 1.0.4
    1. 更改进度条控件

* 1.0.5
    1. 修改.js.txt被作为源文件而非资源文件导致读取错误的问题

* 1.1.0
    1. 配合common库更新大版本
    2. 最低支持版本提到iOS 6.0

* 1.1.1
    1. 配合common库拆分

* 1.1.2
    1. delegate添加关闭按钮回调

* 1.1.3
    1. 调整popWebViewController的代理方法
    2. 增加originUrlString和CurrentUrlString标识外部传入的url和当前的url

* 1.1.4
    1. 重新打tag

* 1.1.5
    1. 修改View底色

* 1.1.6
    1. 去除对LDCPCommon pod中的图片资源引用

* 1.1.7
    1. PopWebViewController出现消失时增加Notification

* 1.1.8
    1. 修复图片错误问题

* 1.1.9
    1. 增加PopWeb关闭时的通知

* 1.1.10
    1. 增加页面出现&消失时的Js通知

* 1.1.11
    1. 增加js文件的rightBarButtonItem点击消息optionMenu;
    2. 支持系统滑动返回手势

* 1.1.12
    去除滑动返回手势功能代码

* 1.1.13
    1.JSBridge去中心化及优化
    2.其他细节及问题调整

* 1.1.14
    1.[问题修复]页面内跳转fragment不显示loading。
    
* 1.1.15
    1.修改文件资源获取方式; 
    2.添加关闭当前PopWebViewController的接口.
