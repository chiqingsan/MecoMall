import { fetchData } from '@mk/basic/Index'
import { Banner, CategoryItem } from '../models'

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
