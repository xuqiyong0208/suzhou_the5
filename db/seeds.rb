# encoding: utf-8
require File.expand_path('../config/application', __dir__)

#管理员
begin
  Admin.create(email:"qing_cai@jkshklgz.com", username:"qing_cai", password: "watforever932706")
rescue Exception => boom
  puts "admin rescue... #{boom.class}-#{boom.message}"
  puts "-------------------------------------------------------\n\n"
end

#主分类
begin
  Category.create(title: "茶叶", name:"cha_ye")
  Category.create(title: "杨梅", name:"yang_mei")
  Category.create(title: "荔枝", name:"li_zhi")
  Category.create(title: "大米", name:"da_mi")
  Category.create(title: "猪肉及蔬菜", name:"zhu_rou_ji_shu_cai")
  Category.create(title: "鸡头米", name:"ji_tou_mi")
  Category.create(title: "大闸蟹", name:"da_zha_xie")
  Category.create(title: "苹果", name:"ping_guo")
  Category.create(title: "赣南脐橙", name:"gan_nan_qi_cheng")
  Category.create(title: "赣南沙田柚", name:"gan_nan_sha_tian_you")
  Category.create(title: "砂糖橘", name:"sha_tang_ju")
  Category.create(title: "菌菇礼包", name:"jun_gu_li_bao")

  #子分类
  Category.create(title: "大红袍", name:"da_hong_pao", father: "cha_ye")
  Category.create(title: "铁观音（清香型）", name:"tie_guan_yin", father: "cha_ye")
  Category.create(title: "铁观音（浓香型）", name:"tie_guan_yin2", father: "cha_ye")
  Category.create(title: "福鼎白茶", name:"fu_ding_bai_cha", father: "cha_ye")
  Category.create(title: "正山小种", name:"zheng_shan_xiao_zhong", father: "cha_ye")
  Category.create(title: "茉莉花茶（龙珠）", name:"mo_li_hua_cha", father: "cha_ye")

  Category.create(title: "碳梅", name:"tan_mei", father: "yang_mei")
  Category.create(title: "东魁A", name:"dong_kui_A", father: "yang_mei")
  Category.create(title: "东魁B", name:"dong_kui_B", father: "yang_mei")

  Category.create(title: "糯米糍", name:"nuo_mi_ci", father: "li_zhi")
  Category.create(title: "桂味", name:"gui_wei", father: "li_zhi")
  Category.create(title: "妃子笑", name:"fei_zi_xiao", father: "li_zhi")

  Category.create(title: "富硒米", name:"fu_xi_mi", father: "da_mi")
  Category.create(title: "糙米", name:"cao_mi", father: "da_mi")
  Category.create(title: "有机大米", name:"you_ji_da_mi", father: "da_mi")

  Category.create(title: "黑毛猪", name:"hei_mao_zhu", father: "zhu_rou_ji_shu_cai")
  Category.create(title: "巴马香猪", name:"ba_ma_xiang_zhu", father: "zhu_rou_ji_shu_cai")
  Category.create(title: "藏香猪", name:"cang_xiang_zhu", father: "zhu_rou_ji_shu_cai")
  Category.create(title: "肉禽蔬菜礼包", name:"rou_qin_shu_cai_li_bao", father: "zhu_rou_ji_shu_cai")

  Category.create(title: "套袋富士", name:"tao_dai_fu_shi", father: "ping_guo")
  Category.create(title: "冰糖心", name:"bing_tang_xin", father: "ping_guo")
rescue Exception => boom
  puts "category rescue... #{boom.class}-#{boom.message}"
  puts "-------------------------------------------------------\n\n"
end

#公司介绍
if !Intro.first

  intro_content = %q{<p>这里是公司介绍的正文。</p>
<p>可以在在后台管理系统修改此处的文本内容</p>
<p>以下是示例文本</p>

<p>专注于创新和探索交互式设计开发，致力于为品牌提供全新的数字化营销服务，为企业提供策略咨询、创意设计、定制开发、运营及推广等全方位服务。</p>

<p>我们强调个性定制化的方式与客户沟通，通过新创意、新技术、新媒体的结合运用，为客户提供整合的数字化交互解决方案与全方位的视觉传播服务。</p>

<p>Aidimedia focus on innovation and explore interactive design and development, is committed to the brand new digital marketing services, providing full-service strategic consulting, creative design, custom development, operations and marketing.</p>

<p>We emphasize personalized customized way to communicate with customers, using a combination of new ideas, new technologies, new media, to provide customers with integrated digital interactive solutions and a full range of visual communication services.</p>

<p>公司介绍正文结束</p>
}

  Intro.create(content:intro_content)
end


#联系我们
if !Contact.first

  contact_content = %q{<p>这里填写"联系我们"的正文。</p>
<p>可以在在后台管理系统修改此处的文本内容</p>
<p>以下是示例文本</p>

<p>客户服务</p>
<p>24小时全国服务热线：400-788-3333</p>
<p>客户服务邮箱：mz_kf@meizu.com</p>
<p>售后维修邮递信息：珠海市唐家湾高新区留诗路2号厂房1楼，519085，赵胜，400-788-3333</p>

<p>市场推广及品牌合作业务咨询：mz-marketing@meizu.com</p>

<p>认证店加盟、经销商服务咨询：0756-6116236，business@meizu.com</p>

<p>B2C电子商务渠道业务咨询：e-business@meizu.com</p>

<p>魅族软件中心第三方开发者软件的销售、结算等相关事务：mzdn@meizu.com</p>

<p>联系我们正文结束</p>
}

  Contact.create(content:contact_content)
end

puts "finish"







