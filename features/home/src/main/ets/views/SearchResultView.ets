import { Log } from '@abner/log'
import { router } from '@kit.ArkUI'
import { MkGoodsItem } from '@mk/basic'
import { MkGoods } from '../components/MkGoods'

// 联合类型
export type SortField = 'publishTime' | 'orderNum' | 'price'

export type SortMethod = 'desc' | 'asc'

// 提交给服务器的参数
export interface SearchParams {
  keyword: string
  sortField: SortField
  sortMethod: SortMethod
  page: number
  pageSize: number
}

// 筛选条件
export interface SortCompAttr {
  field: SortField
  label: string
}


// 路由参数
interface RouterParam {
  keyword: string
}


@Component
export struct SearchResultView {
  // 顶部安全区域
  @StorageProp('safeTop') safeTop: number = 0
  // mock 数据
  @State data: MkGoodsItem[] = new Array(8).fill({
    "id": "4033959",
    "name": "3秒快速拆琴轻松保养odin奥丁12半音阶口琴",
    "price": 329,
    "picture": "https://yanxuan-item.nosdn.127.net/937a8e46a9284e8f7e00e13911ecfbe7.png",
    "payCount": 0
  })
  // 查询参数
  @State
  @Watch('paramsChange')
  params: SearchParams =
    {
      keyword: '',
      sortField: 'publishTime',
      sortMethod: 'desc',
      page: 1,
      pageSize: 10
    }
  // 筛选条件
  sortList: SortCompAttr[] = [
    { label: '时间', field: 'publishTime' },
    { label: '销量', field: 'orderNum' },
    { label: '价格', field: 'price' }
  ]
  // 控制器
  scroller = new Scroller()

  aboutToAppear(): void {
    const params = router.getParams() as RouterParam
    this.params.keyword = params.keyword
    // TODO 查询数据
  }

  paramsChange() {
    Log.info(this.params)
  }

  build() {
    Column() {
      // 搜索区域
      Row() {
        Image($r('app.media.ic_public_left'))
          .width(24)
          .aspectRatio(1)
          .fillColor($r('app.color.white'))
          .margin(13)
          .onClick(() => {
            router.back()
          })
        Search({ placeholder: '商品关键字...', value: this.params.keyword })
          .searchIcon({ src: $r('app.media.ic_public_search'), color: $r('app.color.gray') })
          .placeholderColor($r('app.color.gray'))
          .placeholderFont({ size: 14 })
          .backgroundColor($r('app.color.white'))
          .textFont({ size: 14 })
          .layoutWeight(1)
          .padding(0)
          .margin(0)
          .height(36)
          .caretStyle({ color: $r('app.color.red') })
          .onSubmit((value) => {

          })
      }
      .padding({ top: this.safeTop, right: 16 })
      .linearGradient({ angle: 135, colors: [[$r('app.color.linear_begin'), 0], [$r('app.color.linear_end'), 1]] })

      // list
      Row() {
        ForEach(this.sortList, (item: SortCompAttr) => {
          // 筛选组件
          SortItemComp({
            label: item.label,
            field: item.field,
            sortField: this.params.sortField,
            sortMethod: this.params.sortMethod,

          })
        })
        Text('筛选')
          .fontSize(14)
          .fontColor($r('app.color.gray'))
      }
      .padding({ left: 16, right: 16 })
      .height(50)
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .border({ width: { bottom: 0.5 }, color: $r('app.color.border') })

      WaterFlow({ scroller: this.scroller }) {
        ForEach(this.data, (item: MkGoodsItem) => {
          FlowItem() {
            MkGoods({ goods: item, smallImage: true })
          }
        })
      }
      .columnsTemplate("1fr 1fr")
      .columnsGap(0.5)
      .rowsGap(0.5)
      .layoutWeight(1)
    }
  }
}

@Component
struct SortItemComp {
  // 筛选字段
  field: SortField = 'publishTime'
  // 显示的文本
  label: string = ''
  // 状态变量，接收父组件的状态属性
  // 父组件的筛选字段
  @Prop sortField: SortField = 'publishTime'
  // 父组件的排序方法
  @Prop sortMethod: SortMethod = 'desc'

  // TODO 点击筛选条件，回传  sortField 和 sortMethod 给父组件（回调函数）


  build() {
    Row() {
      Text(this.label)
        .fontWeight(500)
        .fontSize(14)
        .fontColor(this.sortField === this.field ? $r('app.color.black') : $r('app.color.gray'))
      Column() {
        Image($r('app.media.ic_public_up'))
          .width(15)
          .height(6)
          .fillColor(this.sortField === this.field && this.sortMethod === 'asc' ? $r('app.color.black') :
          $r('app.color.gray'))
        Image($r('app.media.ic_public_down'))
          .width(15)
          .height(6)
          .fillColor(this.sortField === this.field && this.sortMethod === 'desc' ? $r('app.color.black') :
          $r('app.color.gray'))
      }
      .justifyContent(FlexAlign.Center)
    }
    .onClick(() => {

    })
  }
}