# MoodPocket
曾冰洁 151220004 zengzbj@foxmail.com

## 应用介绍
此款应用在普通的日记功能基础上，添加了心情值的记录、描述、统计功能，有助于管理情绪、改善情绪状态。
<img src="https://github.com/zengbingjie/MoodPocket/raw/master/Screenshots/0.png" width="500">

## 功能介绍
#### 一、日记功能
* 在首页可以看到最近添加的日记，会显示最近心情的总结；
* 点击日记可以编辑，点击右上角图标可以添加新日记，日记内容包括文字，图片，心情值，标签，收藏；
* 图片可选择照片图库/查看大图/删除，标签可滑动删除，可自定义添加；
* 编辑界面点击Cancel可选择删除/返回；
![](https://github.com/zengbingjie/MoodPocket/raw/master/Screenshots/1.png)

#### 二、未来的信
* 点击首页右上角图标可以添加写给未来的信，发送后直到设置的接收日期那天，没有入口可以查看；
* 如果当天有收到信件，首页会有一个显眼提示，点击可进入查看，阅后(返回后)即焚。
![](https://github.com/zengbingjie/MoodPocket/raw/master/Screenshots/2.png)

#### 三、日历查看
* 日历可左右拖动，也可使用按钮滑动，点击日期可查看当天日记记录；
* 当天的日期用不同的颜色显示，以提示用户；
* 日记有更新或删除时，会通知此界面刷新数据。
![](https://github.com/zengbingjie/MoodPocket/raw/master/Screenshots/3.png)

#### 四、心情统计
* 折线图可左右拖动，也可使用按钮切换，下方有提示不同的颜色代表的意义；
* 点击右上角按钮可以切换以周为单位显示，和以年为单位显示；
* 未来的数据暂时是随机函数产生；
* 折线图下方是所有心情的统计；
* 日记有更新或删除时，会通知此界面刷新数据。
<img src="https://github.com/zengbingjie/MoodPocket/raw/master/Screenshots/4.png" width="500">

#### 五、app密码
* 可设置app密码，如果打开密码功能，每次进入app都需要输入密码；
* 打开密码功能后方可修改、关闭密码，前提是输入正确的当前密码。
<img src="https://github.com/zengbingjie/MoodPocket/raw/master/Screenshots/5.png" width="500">

## 不足之处和有待添加的功能
#### 一、不足
* 因为CollectionView不像TableView自带事先定义好的删除功能框架，尝试多种方法都无法正确方便且优雅地在首页删除日记，只好把删除功能放在编辑日记的返回过程中，这个问题有待解决。
* 因为刚上手的时候还不太熟练，留下了很多代码结构上的遗留问题，比较混乱，也有不符合swift理念的地方，但时间紧迫没有选择再重构，先追求功能实现了。
* 交互界面的Layout暂时对于5s及以下小屏用户不是很友好。

#### 二、后续
* 编辑日记时点击图片可以选择拍照
* 在首页可以选择某个标签分类或收藏的日记
* 日历和折线图可以自由选择时间，可以一键返回今日
* 登录功能和服务器存储
* 使统计功能更加完善
* 使用一定算法来实现未来心情预测
* 改进上述不足之处

## 其他说明
在MyLineChart.swift文件中约有四百行代码是github上的第三方代码[zemirco/swift-linechart](https://github.com/zemirco/swift-linechart).

## 结束语
之前在app store上直接搜各种与心情有关的关键字，找到的app都有点丑有点难用，结果这几天突然发现纪念碑谷开发者做了一个叫[Moodnotes](https://www.myzaker.com/article/588980571bc8e04e3000000d/)的心情追踪app，统计功能比较完善，界面也比较优雅，还有心理学角度的分析和建议，需要25RMB，还是可以接受。暂时借用了它的app icon。它让我反省了自己写的app的问题，没有关注于统计与追踪，而把大量时间花费在了别的功能和界面的雕琢上，也导致写日记的界面不够简洁优雅，有些遗憾。所以有时间了会利用一些第三方库来画图表，做更好用、更有意义的心情追踪。
