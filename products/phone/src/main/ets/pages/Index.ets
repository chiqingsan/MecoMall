import { HomeView } from '@mk/home/Index';
import { CategoryView } from '@mk/category/Index';
import { CartView } from '@mk/cart/Index';
import { MyView } from '@mk/my/Index';
import { Log } from '@abner/log';

interface TabItem {
  text: string
  normal: ResourceStr
  active: ResourceStr
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State activeIndex: number = 0
  list: TabItem[] = [
    { text: '首页', normal: $r('app.media.ic_public_home_normal'), active: $r('app.media.ic_public_home_active') },
    { text: '分类', normal: $r('app.media.ic_public_pro_normal'), active: $r('app.media.ic_public_pro_active') },
    { text: '购物袋', normal: $r('app.media.ic_public_cart_normal'), active: $r('app.media.ic_public_cart_active') },
    { text: '我的', normal: $r('app.media.ic_public_my_normal'), active: $r('app.media.ic_public_my_active') },
  ]

  aboutToAppear(): void {
    // Log.info(new Object({ name: "chiqingsan", age: 18 }))
  }

  build() {
    Tabs({ barPosition: BarPosition.End }) {
      ForEach(this.list, (item: TabItem, index: number) => {
        TabContent() {
          if (index == 0) {
            HomeView()
          } else if (index == 1) {
            CategoryView()
          } else if (index == 2) {
            CartView()
          } else {
            MyView()
          }
        }
        .tabBar(this.TabItemBuilder(item, index))
      })
    }
    .scrollable(false)
    .onTabBarClick(index => {
      this.activeIndex = index
    })
  }

  @Builder
  TabItemBuilder(item: TabItem, index: number) {
    Column() {
      Image(this.activeIndex === index ? item.active : item.normal)
        .width(24)
        .aspectRatio(1)
      Text(item.text)
        .fontColor($r('app.color.black'))
        .fontSize(12)
    }
    .justifyContent(FlexAlign.SpaceEvenly)
    .height(50)
  }
}