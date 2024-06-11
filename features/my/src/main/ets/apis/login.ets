import { fetchData, MkUser } from '@mk/basic/Index'

export interface loginData {
  account: string
  password: string
}

export const LoginApi = (data: loginData) => {
  return fetchData<MkUser, loginData>({
    url: "/login",
    method: "post",
    data
  })
}