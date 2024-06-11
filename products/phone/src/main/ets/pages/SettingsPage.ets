import { SettingsView } from '@mk/my/Index';

@Entry
@Component
struct SettingPage {
  @State message: string = 'Hello World';

  build() {
    Column() {
      SettingsView()
    }
    .height('100%')
    .width('100%')
  }
}