#
# Be sure to run `pod lib lint HWShareUtility.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HWShareUtility'
  
  #  子库的spec依赖其他subspec
  #  s.subspec 'Core' do |cs|
  #    cs.dependency 'HWShareUtility/ObjectMapping'
  #    cs.dependency 'HWShareUtility/Network'
  #    cs.dependency 'HWShareUtility/CoreData'
  #  end
  #  嵌套的字库依赖
  #  s.subspec 'Level_1' do |sp|
  #    sp.subspec 'Level_2' do |ssp|
  #    end
  #  end
  
  s.version          = '0.1.0'
  s.summary          = 'A share utility'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
    VB分享工具类，支持Facebook、Wechat、短信、邮件（系统自带的）、WhatsApp
                       DESC
  
  s.homepage         = 'https://github.com/Lemon-s/HWShareUtility.git'
  #   s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  #  作者及其邮箱
  s.author           = { 'shiliming' => '1025124154@qq.com' }
  s.source           = { :git => 'https://github.com/Lemon-s/HWShareUtility.git', :tag => s.version.to_s }
  #   s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  #  pod库文档的URL地址
  #  s.documentation_url = 'https://www.baidu.com'
  
  s.ios.deployment_target = '8.0'
  
  #  源文件,物理真实路径非层级路径,注意与s.dependency路径的不同
  s.source_files = 'HWShareUtility/Classes/**/*.{h,m}'
  
  # 配置资源文件,注意:.bundle，.png，.txt等资源文件，这些资源文件会被复制到target的mainBundle中，要注意避免发生命名重复的问题
  #  s.resources = 'HWShareUtility/Assets/**/*'
  
  #  配置指定bundle的资源文件（可以解决resources导致的命名冲突问题）,键表示bundles的名称，值表示文件格式
  #   s.resource_bundles = {
  #     'HWShareUtility' => ['HWShareUtility/Assets/*.png']
  #   }
  
  #  配置公有的头文件（.h）,如果不指定那么source_files中的所有header都被认为是公共的
  s.public_header_files = 'HWShareUtility/Classes/**/VBShareUtility.h'
  #  配置私有头文件
  #  s.private_header_files = 'HWShareUtility/Classes/Private/*.h'
  
  #  配置需要引用的非系统的framework
  #  s.vendored_frameworks = 'HWShareUtility/Frameworks/**/*.framework'
  
  #  配置需要引用的非系统静态库
  #  注意:这里的.a静态库名字必须要带lib前缀，如果引用的静态库名字没lib前缀会导致编译报错，只需要重命名加上即可）
  #  s.vendored_libraries = 'HWShareUtility/Libraries/libxxx.a','HWShareUtility/Libraries/libxxx.a'
  
  #  配置需要引用的系统的framework
    s.frameworks = 'UIKit', 'Foundation','MessageUI'
  #  s.ios.framework  = 'UIKit'
  #  s.osx.framework  = 'AppKit'
  
  #  配置依赖的系统库,注意:这里的写法需要忽略lib前缀
  #  s.libraries = 'c++','sqlite3'
  
  #  配置依赖的第三方库（pod库或者自身的subspec）,层级路径非真实物理路径
  s.dependency 'Masonry'
  s.dependency 'YYCategories'
  s.dependency 'FBSDKCoreKit', '4.40.0'
  s.dependency 'FBSDKShareKit', '4.40.0'
  s.dependency 'WechatOpenSDK', '1.8.4'
  
  #  支持的cocoapods版本
  #  s.cocoapods_version = '>= 1.0'
  
  #  当前pod库是否弃用
  #  s.deprecated = true
  #  给当前弃用的pod库设置新名字,通过新名字来使用pod库
  #  s.deprecated_in_favor_of = 'NewPodName'
  
  #  模块的pch文件注入的内容,上下两种方式效果一样
#    s.prefix_header_contents = '#import "VBShareGlobal.h"', '#import "VBSharePannelView.h"', '#import <Masonry.h>', '#import <YYCategories.h>', '#import <WXApi.h>', '#import <FBSDKShareKit/FBSDKShareKit.h>', '#import <MessageUI/MessageUI.h>'
    s.prefix_header_contents = <<-PCHContent
                                  #import "VBShareGlobal.h"
                                  #import "VBSharePannelView.h"
                                  #import <Masonry.h>
                                  #import <YYCategories.h>
                                  #import <WXApi.h>
                                  #import <FBSDKShareKit/FBSDKShareKit.h>
                                  #import<MessageUI/MessageUI.h>
                                  PCHContent
  
  #  配置pch文件,如果不配置的话,系统会默认创建一个pch(在Support Files文件夹下)
  #  s.prefix_header_file = 'HWShareUtility/Classes/xxxx.pch'
end


#Podspecs应该放在pod库的根目录，要相对于pod库的根来指定文件的路径。

#   *         匹配所有文件
#   c*        匹配名字以c开头的文件。
#   *c        匹配名字以c结束的文件。
#   c         匹配名字含有c的，包含c在开头和结尾的情况。
#   **        目录递归地匹配。也就是包含子目录
#   ?         匹配任何一个字符
#   {a,b}     匹配文件名包含a或b的，可以写两个或多个字
#   [abcdef]  匹配字符集中的任何一个字符
#例子：以JSONKit为例
#   "JSONKit.?"    #=> ["JSONKit.h", "JSONKit.m"]
#   "*.[a-z][a-z]" #=> ["CHANGELOG.md", "README.md"]
#   "*.[^m]*"      #=> ["JSONKit.h"]
#   "*.{h,m}"      #=> ["JSONKit.h", "JSONKit.m"]
#   "*"            #=> ["CHANGELOG.md", "JSONKit.h", "JSONKit.m", "README.md"]
