import { AxiosRequestConfig, AxiosResponse } from '@ohos/axios'
import { fetchData, httpInstance, HttpResponse } from '@mk/basic/Index'
import { Banner } from '../models'

export const getBannerApi = () => {
  return fetchData<Banner[]>({
    url: '/home/banner'
  })
}
