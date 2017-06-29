#!/bin/bash

#=================签名参数===============
#从xcconfig文件中取值


#=================项目路径配置===============
PROJECT_PATH='/Users/souche/Documents/souche/DFC_HTTP/dfc_v3'
WORKSPACE_NAME='dfc_v2.xcworkspace'
Archive_PATH='/Users/souche/Desktop/archive'
IPA_PATH='/Users/souche/Desktop/ipa'
#EXPORT_PLIST_PATH='/Users/souche/Documents/souche/DFC_HTTP/dfc_v3/dfc_v2'


#===================================脚本开始=================================================
#使用帮助
if [ $# == 0 ];then
echo "===========================如何使用============================="
echo " eg: ./build [scheme] [token] '版本描述中间不要留空格', 不传token默认用当前已经登录的fir token"
echo " scheme list:"
echo " Chebaba"
echo " token list:"


echo " ---- 特定测试版本"
echo " 9a40b9ce553c60e37f8acfcceea890fc  韩冲 =>dfc4dev  测试环境开发版 开发提测用 215964659@qq.com 123456"
echo " 6060f367caa8cfc218046dc352b218fd  小辉 =>dfc4test 测试环境稳定版 线上生产环境的版本 499175791@qq.com 123456" 
echo " da189a816f7a80e920da3e5b7ba4e937  张庭 =>dfc4beta 预发环境版本 justzt@gmail.com zt4firim"

echo "================================================================"
exit
fi

#update code from gitlab
cd $PROJECT_PATH
#git checkout .
git pull

#update pod
#pod install --repo-update
pod update --verbose

#删除旧的编译目录
APP_BUILD_LOCATION=${PROJECT_PATH}/Build/
rm -rf ${APP_BUILD_LOCATION}
#创建dfc目录

#key auth
#security unlock-keychain "-p" "s" "/Users/souche/Library/Keychains/login.keychain"
security unlock-keychain "-p" "123456" "/Users/souche/Library/Keychains/login.keychain"

#创建ARCHIVE目录
mkdir -p IPA_PATH
#Archive_NAME = $1.xcarchive

#开始打包
cd ${PROJECT_PATH}
pwd
#xcodebuild -workspace ${WORKSPACE_NAME}  -scheme $1 CODE_SIGN_IDENTITY="${CODESIGN_NAME}" PROVISIONING_PROFILE="${PROVISIONING_NAME}" clean build

XCCONFIG_PATH=${PROJECT_PATH}/dfc_v2/appconfig

#xcodebuild -workspace ${WORKSPACE_NAME} -scheme Enterprise -xcconfig ${XCCONFIG_PATH}/$1.xcconfig -archivePath ${Archive_PATH}/$1.xcarchive archive
xcodebuild -workspace ${WORKSPACE_NAME} -scheme $1 -config $1 -archivePath ${Archive_PATH}/$1.xcarchive clean archive

#创建ipa
IPA_LOCATION=${IPA_PATH}/$1
#删除旧的ipa
rm -rf IPA_LOCATION
mkdir -p ${IPA_PATH}/$1
xcodebuild -exportArchive -exportOptionsPlist ${PROJECT_PATH}/dfc_v2/exportArchive.plist -archivePath ${Archive_PATH}/$1.xcarchive -exportPath ${IPA_LOCATION}


IPA_FILE_LOCATION=${IPA_PATH}/$1/$1.ipa

#检查ipa是否创建成功
if [ -f $IPA_FILE_LOCATION ]; then
echo "ipa已经创建:"${IPA_FILE_LOCATION}
else
echo "打包失败"
exit 0
fi


#上传
if [ $# -ge 2 ];then
        fir p ${IPA_FILE_LOCATION} -T $2
else
	echo "请填写fir-token上传"
fi





