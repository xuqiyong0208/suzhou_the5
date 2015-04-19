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
  Category.create(title: "茶叶", name:"cha_ye", logo_class:"n1")
  Category.create(title: "杨梅", name:"yang_mei", logo_class:"n2")
  Category.create(title: "荔枝", name:"li_zhi", logo_class:"n3")
  Category.create(title: "大米", name:"da_mi", logo_class:"n4")
  Category.create(title: "猪肉及蔬菜", name:"zhu_rou_ji_shu_cai", logo_class:"n5")
  Category.create(title: "鸡头米", name:"ji_tou_mi", logo_class:"n6")
  Category.create(title: "大闸蟹", name:"da_zha_xie", logo_class:"n7")
  Category.create(title: "苹果", name:"ping_guo", logo_class:"n8")
  Category.create(title: "赣南脐橙", name:"gan_nan_qi_cheng", logo_class:"n9")
  Category.create(title: "赣南沙田柚", name:"gan_nan_sha_tian_you", logo_class:"n10")
  Category.create(title: "砂糖橘", name:"sha_tang_ju", logo_class:"n11")
  Category.create(title: "菌菇礼包", name:"jun_gu_li_bao", logo_class:"n12")

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


puts "finish"







