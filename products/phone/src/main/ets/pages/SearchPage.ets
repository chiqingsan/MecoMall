import { SearchView } from '@mk/home/Index';

@Entry
@Component
struct SearchPage {
  @State message: string = 'Hello World';

  build() {
    Column() {
      SearchView()
    }
  }
}