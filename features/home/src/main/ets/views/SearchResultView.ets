import { Log } from '@abner/log'
import { promptAction, router } from '@kit.ArkUI'
import { MkGoodsItem, MyDataSource } from '@mk/basic'
import { MkGoods } from '@mk/basic/src/main/ets/components/MkGoods'
import { getSearchApi } from '../apis'
import { PullToRefresh } from "@ohos/pulltorefresh"

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
  @StorageProp('topHeight') safeTop: number = 0
  // mock 数据
  @State data: MyDataSource<MkGoodsItem> = new MyDataSource()
  // 查询参数
  @State @Watch('paramsChange') params: SearchParams =
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
  total: number = 0

  aboutToAppear() {
    try {
      const params = router.getParams() as RouterParam
      this.params.keyword = params.keyword
    } catch (e) {
      Log.error(e)
    }
    // TODO 查询数据
    this.queryTheData()
  }

  paramsChange() {
    Log.info(this.params)
  }

  async queryTheData() {
    const res = await getSearchApi(this.params)
    res.data.result.pageData.items.forEach((item: MkGoodsItem) => {
      this.data.pushData(item)
    })
    // this.data = res.data.result.pageData.items
    this.total = res.data.result.pageData.counts
    // Log.info(res)
  }

  searchData(value: string) {
    this.params.keyword = value
    this.params.page = 1
    this.queryTheData()
  }

  // 刷新数据
  refreshTheData() {
    // this.data = []
    this.data.clear()
    this.params.page = 1
    this.queryTheData()
    return ""
  }

  // 加载更多
  async loadMore() {
    if (this.params.page < this.total) {
      this.params.page++
      const res = await getSearchApi(this.params)
      res.data.result.pageData.items.forEach((item: MkGoodsItem) => {
        this.data.pushData(item)
      })
      // this.data.push(...res.data.result.pageData.items as MkGoodsItem[])
    } else {
      promptAction.showToast({ message: "没有更多数据啦~" })
    }
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
            this.searchData(value)
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
            onClickItem: (sortField: SortField, sortMethod: SortMethod) => {
              this.params.sortField = sortField
              this.params.sortMethod = sortMethod
              this.queryTheData()
            }
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


      PullToRefresh({
        data: $data,
        scroller: this.scroller,
        customList: () => {
          this.myListBuilder()
        },
        onRefresh: async () => {
          this.refreshTheData()
          return ""
        },
        onLoadMore: async () => {
          this.loadMore()
          return ""
        }
      })


    }
  }

  @Builder
  myListBuilder() {
    WaterFlow({ scroller: this.scroller }) {
      LazyForEach(this.data, (item: MkGoodsItem) => {
        FlowItem() {
          MkGoods({ goods: item, smallImage: true })
        }
      }, (item: MkGoodsItem) => item.id)
    }
    .columnsTemplate("1fr 1fr")
    .columnsGap(0.5)
    .rowsGap(0.5)
    .layoutWeight(1)
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
  onClickItem = (sortField: SortField, sortMethod: SortMethod) => {

  }

  MyOnClick() {
    // 排序字段相同,修改排序方式
    if (this.field == this.sortField) {
      this.onClickItem(this.field, this.sortMethod == 'asc' ? 'desc' : 'asc')
    } else {
      // 排序字段不同，排序方式 desc，修改排序字段
      this.onClickItem(this.field, 'desc')
    }
  }

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
      this.MyOnClick()
    })
  }
}