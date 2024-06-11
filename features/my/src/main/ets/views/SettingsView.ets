import { auth, MkCell, MkCellGroup, MkNavbar, MkUser } from '@mk/basic'
// import { MkCell, MkCellGroup } from '@mk/basic'
import { router } from '@kit.ArkUI'

@Component
export struct SettingsView {
  @StorageProp(auth.KEY) user: MkUser = {} as MkUser

  @Builder
  ProfileBuilder() {
    Row({ space: 8 }) {
      Image(this.user.avatar)
        .width(50)
        .aspectRatio(1)
        .borderRadius(25)
      Column({ space: 4 }) {
        Text(this.user.nickname || this.user.account)
          .fontColor($r('app.color.black'))
          .fontWeight(500)
        Text('账号名：' + this.user.account)
          .fontColor($r('app.color.gray'))
          .fontSize(12)
      }
      .alignItems(HorizontalAlign.Start)
    }
    .padding({ top: 16, bottom: 16 })
  }

  build() {
    Column() {
      MkNavbar({ title: '设置' })
      Column({ space: 8 }) {
        MkCellGroup() {
          MkCell({
            hasBorder: false, customLabel: () => {
              this.ProfileBuilder()
            }
          })
        }

        MkCellGroup() {
          MkCell({ label: '收货地址管理' })
          MkCell({ label: '账号安全' })
          MkCell({ label: '消息设置' })
          MkCell({ label: '隐私设置' })
          MkCell({ label: '通用设置', hasBorder: false })
        }

        MkCellGroup() {
          MkCell({ label: '退出登录', hasBorder: false })
            .onClick(() => {
              AlertDialog.show(
                {
                  title: '退出提醒',
                  message: '确定要退出登录吗？',
                  autoCancel: true,
                  alignment: DialogAlignment.Bottom,
                  gridCount: 4,
                  offset: { dx: 0, dy: -20 },
                  primaryButton: {
                    value: '取消',
                    fontColor: $r("app.color.black"),
                    action: () => {
                    }
                  },
                  secondaryButton: {
                    enabled: true,
                    defaultFocus: true,
                    style: DialogButtonStyle.HIGHLIGHT,
                    value: '退出登录',
                    backgroundColor: $r("app.color.black"),
                    fontColor: $r("app.color.white"),
                    action: () => {
                      auth.removeUser()
                      router.back()
                    }
                  }
                }
              )
            })
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.under'))
  }
}