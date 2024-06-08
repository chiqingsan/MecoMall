import { router } from '@kit.ArkUI'

@Component
export struct MkNavbar {
  @Prop title: string = ''
  @Prop leftIcon: ResourceStr = $r('app.media.ic_public_left')
  @Prop rightIcon: ResourceStr = $r('app.media.ic_public_more')
  @Prop showLeftIcon: boolean = true
  @Prop showRightIcon: boolean = false
  @Prop color: ResourceColor = $r('app.color.black')
  @Prop bg: ResourceColor = $r('app.color.white')
  // storage
  @StorageProp('topHeight') safeTop: number = 0
  @BuilderParam customTitle: () => void = this.DefaultTitleBuilder

  // 右侧按钮的点击事件
  rightClickHandler: () => void = () => {
  }

  @Builder
  DefaultTitleBuilder() {
    Text(this.title)
      .fontSize(16)
      .fontWeight(500)
      .layoutWeight(1)
      .textAlign(TextAlign.Center)
      .fontColor(this.color)
  }

  build() {
    Row() {
      Row() {
        if (this.showLeftIcon) {
          Image(this.leftIcon)
            .width(24)
            .aspectRatio(1)
            .fillColor(this.color)
            .onClick(() => {
              router.back()
            })
        }
      }
      .width(50)
      .aspectRatio(1)
      .justifyContent(FlexAlign.Center)

      this.customTitle()

      Row() {
        if (this.showRightIcon) {
          Image(this.rightIcon)
            .width(24)
            .aspectRatio(1)
            .fillColor(this.color)
            .onClick(() => {
              this.rightClickHandler && this.rightClickHandler()
            })
        }
      }
      .width(50)
      .aspectRatio(1)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height(50 + this.safeTop)
    .backgroundColor(this.bg)
    .padding({ top: this.safeTop })
  }
}