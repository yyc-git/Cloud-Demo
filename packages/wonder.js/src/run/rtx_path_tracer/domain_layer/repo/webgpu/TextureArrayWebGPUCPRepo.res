

open WebGPUCPPOType

let _getTextureArray = () => CPRepo.getWebGPU().textureArray

let _setTextureArray = textureArray =>
  CPRepo.setWebGPU({...CPRepo.getWebGPU(), textureArray: textureArray})

let getLayerIndex = imageId => _getTextureArray().layerIndexMap->ImmutableHashMap.get(imageId)

let setLayerIndex = (imageId, layerIndex) => {
  let {layerIndexMap} as textureArray = _getTextureArray()

  _setTextureArray({
    ...textureArray,
    layerIndexMap: layerIndexMap->ImmutableHashMap.set(imageId, layerIndex),
  })
}

let getTextureArrayView = () => _getTextureArray().textureArrayView

let setTextureArrayView = textureArrayView =>
  _setTextureArray({
    ..._getTextureArray(),
    textureArrayView: textureArrayView->Some,
  })

let getTextureSampler = () => _getTextureArray().textureSampler

let setTextureSampler = textureSampler =>
  _setTextureArray({
    ..._getTextureArray(),
    textureSampler: textureSampler->Some,
  })

let getTextureArrayLayerSize = () => _getTextureArray().layerSize

let setTextureArrayLayerSize = (width, height) =>
  _setTextureArray({..._getTextureArray(), layerSize: (width, height)})
