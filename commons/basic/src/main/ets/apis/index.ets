import { GoodsItems } from '../models'
import { fetchData } from '../utils'

export const getGuessLikeApi = (limit: number = 6) => {
  return fetchData<GoodsItems>({
    url: "/home/goods/guessLike",
    params: { limit }
  })
}