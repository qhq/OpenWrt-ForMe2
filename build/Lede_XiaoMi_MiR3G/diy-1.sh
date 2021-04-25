#!/bin/bash
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# 基本不需要添加啥插件了,我搜集了各位大神的插件都集成一个软件包直接打入源码里面了
# 要了解增加了什么东西，就到我的专用软件包里面看看看吧，如果还是没有你需要的插件，请不要一下子就拉取别人的插件包
# 相同的文件都拉一起，因为有一些可能还是其他大神修改过的容易造成编译错误的
# 想要什么插件就单独的拉取什么插件就好，或者告诉我，我把插件放我的插件包就行了
# 软件包地址：https://github.com/281677160/openwrt-package
# 拉取插件请看《各种命令的简单介绍》第4条、第5条说明,不管大神还是新手请认真的看看,再次强调请不要一下子就拉取别人一堆插件的插件包,容易造成编译错误的

# 取消-注释的源（如内置：ssr-plus）
# sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# 添加-第三方源（添加至：feeds.conf.default文件内）
# sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default
# sed -i '$a src-git kenzok https://github.com/kenzok8/openwrt-packages' feeds.conf.default
# sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default


# --------------------单独添加插件部分--------------------

# 添加钉钉机器人推送
git clone https://github.com/zzsj0928/luci-app-pushbot.git package/luci-app-pushbot 
