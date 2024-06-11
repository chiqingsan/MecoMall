import { BreakPointKey, BreakPointType, CategoryItem, CategoryItemChild, MkNavbar } from '@mk/basic'
import { router } from '@kit.ArkUI'

@Component
export struct CategoryView {
  @StorageProp("categories") categories: CategoryItem[] = []
  @StorageProp(BreakPointKey) breakPointKey: string = "sm"
  @State activeIndex: number = 0

  build() {
    Column() {
      MkNavbar({
        title: "分类",
        showRightIcon: true,
        rightIcon: $r("app.media.ic_public_search"),
        rightClickHandler: () => {
          router.pushUrl({ url: "pages/SearchPage" })
        }
      })
      Row() {
        Column() {
          ForEach(this.categories, (item: CategoryItem, i) => {
            Text(item.name)// 文本
              .backgroundColor(this.activeIndex === i ? $r('app.color.black') : $r('app.color.white'))
              .fontSize(14)
              .fontColor(this.activeIndex === i ? $r('app.color.white') : $r('app.color.black'))
              .textAlign(TextAlign.Center)
              .width('100%')
              .height(56)
              .onClick(() => {
                this.activeIndex = i
              })

          })
        }
        .width(88)
        .border({ width: { right: 0.5 }, color: $r('app.color.under') })

        Scroll() {
          Column() {
            // 顶部图片
            Image(this.categories[this.activeIndex]?.picture)
              .width('100%')
              .height(this.breakPointKey === "sm" ? 136 : 316)
              .objectFit(ImageFit.Contain)
              .backgroundColor('#f6f6f6')
              .borderRadius(8)
              .margin({ bottom: 8 })
            GridRow({
              columns: new BreakPointType({
                sm: 2,
                md: 3,
                lg: 4
              }).getValue(this.breakPointKey)
            , gutter: 8
            }) {
              // 子分类
              ForEach(this.categories[this.activeIndex]?.children, (sub: CategoryItemChild) => {
                GridCol() {
                  Column() {
                    // 图片
                    Image(sub.picture)
                      .width(64)
                      .aspectRatio(1)
                    Text(sub.name)// 文本
                      .fontSize(14)
                      .fontColor($r('app.color.text'))
                      .margin({ top: 8 })
                  }
                  .height('100%')
                  .justifyContent(FlexAlign.Center)
                }
                .aspectRatio(1)
                .backgroundColor('#f6f6f6')
                .borderRadius(8)
              })
            }
          }
          .padding(8)
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
      }
      .layoutWeight(1)
      .alignItems(VerticalAlign.Top)
    }
    .width('100%')
    .height('100%')
  }
}