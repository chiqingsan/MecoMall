import { LoginView } from '@mk/my/Index'

@Entry
@Component
struct Login {
  build() {
    Column() {
      LoginView()
    }
    .height('100%')
    .width('100%')
  }
}