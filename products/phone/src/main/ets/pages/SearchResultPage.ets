import { SearchResultView } from '@mk/home/Index';

@Entry
@Component
struct SearchResultPage {
  @State message: string = 'Hello World';

  build() {
    Column(){
      SearchResultView()
    }
  }
}