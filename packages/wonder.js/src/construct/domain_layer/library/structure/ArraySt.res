let reduceOneParam = (arr, param, func) => Belt.Array.reduceU(arr, param, func)

let reduceOneParami = (arr, param, func) => {
  let mutableParam = ref(param)
  for i in 0 to Js.Array.length(arr) - 1 {
    mutableParam := func(. mutableParam.contents, Array.unsafe_get(arr, i), i)
  }
  mutableParam.contents
}

let includes = (arr, value) => Js.Array.includes(value, arr)

let sliceFrom = (arr, index) => Js.Array.sliceFrom(index, arr)

let unsafeGetFirst = arr => Array.unsafe_get(arr, 0)

let push = (arr, value) => {
  Js.Array.push(value, arr)->ignore

  arr
}

let forEach = (arr, func) => Js.Array.forEach(func, arr)
