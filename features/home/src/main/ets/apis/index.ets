import { fetchData } from '@mk/basic/Index'
import { ApiResult, Banner, CategoryItem, MkGoodsItem } from '../models'

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
