import { fetchData } from '@mk/basic/Index'
import { ApiResult, Banner, CategoryItem, Goods, MkGoodsItem, SearchResult } from '../models'
import { SearchParams } from '../views'

// 轮播图
export const getBannerApi = () => {
  return fetchData<Banner[]>({
    url: '/home/banner'
  })
}

// 分类
export const getCategoryApi = () => {
  return fetchData<CategoryItem[]>({
    url: '/home/category/head'
  })
}

export const getPreferenceApi = () => {
  return fetchData<ApiResult>({
    url: '/hot/preference'
  })
}

export const getHotApi = () => {
  return fetchData<ApiResult>({
    url: '/hot/inVogue'
  })
}

export const getOneApi = () => {
  return fetchData<ApiResult>({
    url: '/hot/oneStop'
  })
}

export const getNewApi = () => {
  return fetchData<MkGoodsItem[]>({
    url: '/home/new?limit=10'
  })
}

export const getRecommendApi = (limit: number) => {
  return fetchData<MkGoodsItem[]>({
    url: '/home/recommend',
    params: { limit }
  })
}

export const getSearchApi = (data: SearchParams) => {
  return fetchData<SearchResult, SearchParams>({
    url: '/search/all',
    method: 'post',
    data
  })
}


export const getDetailsApi = (id: string) => {
  return fetchData<Goods>({
    url: '/goods',
    params:{
      id:id
    }
  })
}
