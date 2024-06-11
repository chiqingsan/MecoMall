import { GoodsView } from '@mk/home/Index';

@Entry
@Component
struct GoodsPage {
  @State message: string = 'Hello World';

  build() {
    Column() {
      GoodsView()
    }
    .height('100%')
    .width('100%')
  }
}