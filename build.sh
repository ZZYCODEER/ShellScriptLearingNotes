#! bin/bash
#为了简化，默认工程的workspace、project、target名字相同


#=================项目路径配置===============
PROJECT_PATH="/Users/zhangzhongyang/Desktop/git/dfc_v3"
WORKSPACE_NAME='dfc_v2.xcworkspace'
Archive_PATH='/Users/zhangzhongyang/Desktop/archive'
IPA_PATH='/Users/zhangzhongyang/Desktop/ipa'
mkdir Archive_PATH

cd $PROJECT_PATH
git pull

APP_BUILD_LOCATION=${PROJECT_PATH}/Build/
#删除旧的编译目录
rm -rf ${APP_BUILD_LOCATION}

#创建ARCHIVE目录
mkdir -p IPA_PATH

#开始打包
XCCONFIG_PATH=${PROJECT_PATH}/dfc_v2/appconfig

xcodebuild -workspace ${WORKSPACE_NAME} -scheme $1 -config $1 -archivePath ${Archive_PATH}/$1.xcarchive clean archive

#创建ipa
IPA_LOCATION=${IPA_PATH}/$1
#删除旧的ipa
rm -rf IPA_LOCATION
mkdir -p IPA_LOCATION
xcodebuild -exportArchive -exportOptionsPlist ${PROJECT_PATH}/dfc_v2/exportArchive.plist -archivePath ${Archive_PATH}/$1.xcarchive -exportPath ${IPA_LOCATION}

IPA_FILE_LOCATION=${IPA_PATH}/$1/$1.ipa


#检查ipa是否创建成功
if [ -f $IPA_FILE_LOCATION ]; then
echo "ipa已经创建:"${IPA_FILE_LOCATION}
else
echo "打包失败"
exit 0
fi


#输出总用时
echo "===Finished. Total time: ${SECONDS}s==="

#蒲公英上的User Key
uKey="4c1fae6816ae743b2fa3debfdf4ebeaf"
#蒲公英上的API Key
apiKey="831beb159d6908f453c21c59b8b68c47"


#执行上传至蒲公英的命令
echo "++++++++++++++upload+++++++++++++"
curl -F "file=@${IPA_LOCATION}" -F "uKey=${uKey}" -F "_api_key=${apiKey}" http://www.pgyer.com/apiv1/app/upload


#上传
if [ $# -ge 2 ];then
fir p ${IPA_FILE_LOCATION} -T $2
else
echo "请填写fir-token上传"
fi











