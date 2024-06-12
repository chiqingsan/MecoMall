import { router, window } from '@kit.ArkUI'
import { windowManager } from '@mk/basic/Index'
import { AudioSearchComp } from '../components/AudioSearchComp'

@Component
export struct SearchView {
  @StorageProp('topHeight') safeTop: number = 0
  @State keyword: string = ''

  aboutToAppear(): void {
    windowManager.settingStatusBar(true)
  }

  aboutToDisappear(): void {
    windowManager.settingStatusBar(false)
  }

  build() {
    Column() {
      // search
      Row() {
        Image($r('app.media.ic_public_left'))
          .width(24)
          .aspectRatio(1)
          .fillColor($r('app.color.white'))
          .margin(13)
          .onClick(() => {
            router.back()
          })
        Search({ placeholder: '商品关键字...', value: this.keyword })
          .searchIcon({ src: $r('app.media.ic_public_search'), color: $r('app.color.gray') })
          .placeholderColor($r('app.color.gray'))
          .placeholderFont({ size: 14 })
          .searchButton('搜索', { fontSize: 14, fontColor: $r('app.color.red') })
          .backgroundColor($r('app.color.white'))
          .textFont({ size: 14 })
          .layoutWeight(1)
          .padding(0)
          .margin(0)
          .height(36)
          .caretStyle({ color: $r('app.color.red') })
          .defaultFocus(true)
          .onSubmit((value) => {
            router.pushUrl({
              url: "pages/SearchResultPage",
              params: {
                keyword: value
              }
            })
          })

      }
      .padding({ top: this.safeTop, right: 16 })
      .linearGradient({ angle: 135, colors: [[$r('app.color.linear_begin'), 0], [$r('app.color.linear_end'), 1]] })


      AudioSearchComp({
        onChange: (keyword) => {
          this.keyword = keyword
        },
        onComplete: (keyword) => {
          this.keyword = keyword
          router.pushUrl({
            url: "pages/SearchResultPage",
            params: { keyword }
          })
        }
      })
    }
  }
}