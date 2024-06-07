import { AxiosRequestConfig, AxiosResponse } from '@ohos/axios'
import { httpInstance, HttpResponse } from '@mk/basic/Index'
import { Banner } from '../models'

export const getBannerApi = () => {
  return httpInstance<null, AxiosResponse<HttpResponse<Banner[]>, null>, null>({
    url: '/home/banner'
  })
}
