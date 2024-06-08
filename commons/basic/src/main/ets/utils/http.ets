import axios, { InternalAxiosRequestConfig, AxiosError, AxiosResponse, AxiosRequestConfig } from '@ohos/axios'

interface HttpResponse<T> {
  code: string
  msg: string
  result: T
}

// 实例化 通用配置
const httpInstance = axios.create({
  baseURL: 'https://meikou-api.itheima.net/',
  timeout: 5000
})

// 拦截器配置
// 请求拦截器
// token配置等
httpInstance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  return config
}, (error: AxiosError) => {
  return Promise.reject(error)
})


// 添加响应拦截器
// 错误统一处理等
httpInstance.interceptors.response.use((response: AxiosResponse) => {
  return response
}, (error: AxiosError) => {
  return Promise.reject(error)
})


function fetchData<T, D = null>(config: AxiosRequestConfig<D>): Promise<AxiosResponse<HttpResponse<T>, null>> {
  return httpInstance<null, AxiosResponse<HttpResponse<T>>, D>(config)
}

export { httpInstance, HttpResponse, fetchData }