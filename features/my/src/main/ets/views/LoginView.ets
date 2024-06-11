import { auth, MkNavbar } from '@mk/basic/Index'
import { promptAction, router } from '@kit.ArkUI'
import { LoginApi, loginData } from '../apis'
import { Log } from '@abner/log'


@Component
export struct LoginView {
  @State @Watch('onInput') account: string = 'zhousg'
  @State @Watch('onInput') password: string = '123456'
  @State valid: boolean = true
  @State agree: boolean = false

  onInput() {
    this.valid = this.account && this.password ? true : false
  }

  async onSubmit() {
    if (!this.agree) {
      return promptAction.showToast({ message: '请先勾选协议' })
    }
    if (!this.valid) {
      return promptAction.showToast({ message: "请输入账号和密码" })
    }

    const res = await LoginApi({
      account: this.account,
      password: this.password
    } as loginData)

    Log.info(res.data)
    if (res.data.code === "1") {
      auth.saveUser(res.data.result)
      router.back()
    } else {
      promptAction.showToast({ message: "登录出错" })
    }
  }

  @Styles
  form() {
    .width('100%')
    .height(42)
    .padding({
      left: 16,
      right: 16,
      top: 0,
      bottom: 0
    })
  }

  build() {
    Column() {
      MkNavbar()
      Column({ space: 16 }) {
        Text('账号密码登录')
          .fontSize(18)
          .fontColor($r('app.color.black'))
          .width('100%')
          .fontWeight(500)
          .margin({ bottom: 10 })
        TextInput({ placeholder: '请输入账号', text: $$this.account })
          .placeholderColor($r('app.color.gray'))
          .placeholderFont({ size: 14 })
          .form()
        TextInput({ placeholder: '请输入密码', text: $$this.password })
          .type(InputType.Password)
          .showPasswordIcon(false)
          .placeholderColor($r('app.color.gray'))
          .placeholderFont({ size: 14 })
          .form()

        Row({ space: 4 }) {
          Checkbox()
            .select($$this.agree)
            .width(12)
            .aspectRatio(1)
            .selectedColor($r('app.color.black'))
            .mark({ size: 10, strokeWidth: 1 })
          Text() {
            Span('查看并同意')
            Span('《隐私条款》')
              .fontColor('#007DFB')
            Span('和')
            Span('《用户协议》')
              .fontColor('#007DFB')
          }
          .width('100%')
          .fontSize(12)
          .fontColor($r('app.color.gray'))
        }

        Button('登录')
          .backgroundColor(this.valid ? $r('app.color.black') : '#D4D2D9')
          .fontColor($r('app.color.white'))
          .form()
          .onClick(() => {
            this.onSubmit()
          })

        Row() {
          Blank()
          Text('忘记密码')
            .fontColor('#007DFB')
            .fontSize(12)
        }
        .width('100%')

        Column({ space: 16 }) {
          Stack() {
            Text()
              .width(200)
              .height(1)
              .backgroundColor($r('app.color.under'))
            Text('其他登录方式')
              .width(100)
              .fontSize(12)
              .backgroundColor($r('app.color.white'))
              .fontColor($r('app.color.text'))
              .textAlign(TextAlign.Center)
          }

          Row() {
            // 后续放置华为登录
          }
        }
        .margin({ top: 200 })
      }
      .padding(30)
    }
    .width('100%')
    .height('100%')
  }
}