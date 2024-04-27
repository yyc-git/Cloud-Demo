type gpuObject

type adapterObject

type windowObject

type deviceObject

type contextObject

type swapChainObject

type queueObject

type shaderModuleObject

type bindGroupLayoutObject

type pipelineLayoutObject

type bufferUsageObject = int

type bufferObject

type shaderStageObject = int

type bindGroupObject

type samplerObject

type textureViewObject

type renderPipelineObject

type computePipelineObject

type commandEncoderObject

type textureUsageObject = int

type textureObject

type commandBufferObject

type textureFormat = string

@bs.deriving(abstract)
type adapterDescriptor = {
  window: windowObject,
  @bs.optional
  preferredBackend: string,
}

type windowDescriptor = {"width": int, "height": int, "title": string, "resizable": bool}

type swapChainConfig = {"device": deviceObject, "format": textureFormat}

type code

type shaderModuleDescriptor = {"code": code}

type glslPath = string

type loadGLSL = glslPath => code

type pipelineLayoutConfig = {"bindGroupLayouts": array<bindGroupLayoutObject>}

type bufferDescriptor = {"size": int, "usage": bufferUsageObject}

type bindingPoint = int

@bs.deriving(abstract)
type layoutBinding = {
  binding: bindingPoint,
  visibility: shaderStageObject,
  @bs.as("type")
  type_: string,
  @bs.optional
  hasDynamicOffset: bool,
  @bs.optional
  viewDimension: string,
}

type bindGroupLayoutDescriptor = {"entries": array<layoutBinding>}

@bs.deriving(abstract)
type binding = {
  binding: bindingPoint,
  @bs.optional
  buffer: bufferObject,
  @bs.optional
  sampler: samplerObject,
  @bs.optional
  textureView: textureViewObject,
  @bs.optional
  offset: int,
  size: int,
}

type bindGroupDescriptor = {"layout": bindGroupLayoutObject, "entries": array<binding>}

@bs.deriving(abstract)
type vertexStage = {
  @bs.as("module")
  module_: shaderModuleObject,
  entryPoint: string,
}

@bs.deriving(abstract)
type fragmentStage = {
  @bs.as("module")
  module_: shaderModuleObject,
  entryPoint: string,
}

@bs.deriving(abstract)
type vertexAttribute = {
  shaderLocation: int,
  offset: int,
  format: string,
}

@bs.deriving(abstract)
type vertexBuffer = {
  arrayStride: int,
  @bs.optional
  stepMode: string,
  attributes: array<vertexAttribute>,
}

@bs.deriving(abstract)
type vertexState = {
  indexFormat: string,
  @bs.optional
  vertexBuffers: array<vertexBuffer>,
}

@bs.deriving(abstract)
type rasterizationState = {
  @bs.optional
  frontFace: string,
  @bs.optional
  cullMode: string,
}

@bs.deriving(abstract)
type blendDescriptor = {
  @bs.optional
  srcFactor: string,
  @bs.optional
  dstFactor: string,
  @bs.optional
  operation: string,
}

@bs.deriving(abstract)
type colorState = {
  format: textureFormat,
  alphaBlend: blendDescriptor,
  colorBlend: blendDescriptor,
}

@bs.deriving(abstract)
type stencilStateFaceDescriptor = {
  @bs.optional
  compare: string,
  @bs.optional
  failOp: string,
  @bs.optional
  depthFailOp: string,
  @bs.optional
  passOp: string,
}

@bs.deriving(abstract)
type depthStencilState = {
  depthWriteEnabled: bool,
  depthCompare: string,
  format: string,
  stencilFront: stencilStateFaceDescriptor,
  stencilBack: stencilStateFaceDescriptor,
}

@bs.deriving(abstract)
type pipelineRenderDescriptor = {
  layout: pipelineLayoutObject,
  @bs.optional
  sampleCount: int,
  vertexStage: vertexStage,
  fragmentStage: fragmentStage,
  primitiveTopology: string,
  vertexState: vertexState,
  rasterizationState: rasterizationState,
  colorStates: array<colorState>,
  @bs.optional
  depthStencilState: depthStencilState,
}

@bs.deriving(abstract)
type computeStage = {
  @bs.as("module")
  module_: shaderModuleObject,
  entryPoint: string,
}

@bs.deriving(abstract)
type pipelineComputeDescriptor = {
  layout: pipelineLayoutObject,
  computeStage: computeStage,
}

@bs.deriving(abstract)
type commandEncoderDescriptor = {
  @bs.optional
  label: string,
}

@bs.deriving(abstract)
type samplerDescriptor = {
  magFilter: string,
  minFilter: string,
  addressModeU: string,
  addressModeV: string,
  addressModeW: string,
}

type extend3D = {"width": int, "height": int, "depth": int}

@bs.deriving(abstract)
type textureDescriptor = {
  size: extend3D,
  arrayLayerCount: int,
  mipLevelCount: int,
  sampleCount: int,
  dimension: string,
  format: textureFormat,
  usage: textureUsageObject,
}

type passEncoderRenderObject

type clearColor = {"r": float, "g": float, "b": float, "a": float}

type colorAttachment = {
  "clearColor": clearColor,
  "loadOp": string,
  "storeOp": string,
  "attachment": textureViewObject,
}

type depthStencilAttachment = {
  "clearDepth": float,
  "depthLoadOp": string,
  "depthStoreOp": string,
  "clearStencil": int,
  "stencilLoadOp": string,
  "stencilStoreOp": string,
  "attachment": textureViewObject,
}

@bs.deriving(abstract)
type passEncoderRenderDescriptor = {
  colorAttachments: array<colorAttachment>,
  @bs.optional
  depthStencilAttachment: depthStencilAttachment,
}

type vertexCount = int
type indexCount = int
type instanceCount = int
type firstVertex = int
type firstIndex = int
type firstInstance = int
type baseVertex = firstVertex

type passEncoderComputeObject

@bs.deriving(abstract)
type passEncoderComputeDescriptor = {
  @bs.optional
  label: string,
}

type x = int
type y = int
type z = int

type textureUsage = {
  copy_src: textureUsageObject,
  copy_dst: textureUsageObject,
  sampled: textureUsageObject,
  storage: textureUsageObject,
  output_attachment: textureUsageObject,
}

type swapChain = {
  getCurrentTextureView: (unit, swapChainObject) => textureViewObject,
  present: swapChainObject => unit,
}

type queue = {submit: (array<commandBufferObject>, queueObject) => unit}

type shaderStage = {
  compute: shaderStageObject,
  fragment: shaderStageObject,
  vertex: shaderStageObject,
}

type bufferUsage = {
  storage: bufferUsageObject,
  uniform: bufferUsageObject,
  indirect: bufferUsageObject,
  vertex: bufferUsageObject,
  index: bufferUsageObject,
  map_read: bufferUsageObject,
  map_write: bufferUsageObject,
  copy_src: bufferUsageObject,
  copy_dst: bufferUsageObject,
}

type buffer = {
  setSubFloat32Data: (int, Js.Typed_array.Float32Array.t, bufferObject) => unit,
  setSubUint8Data: (int, Js.Typed_array.Uint8Array.t, bufferObject) => unit,
  setSubUint32Data: (int, Js.Typed_array.Uint32Array.t, bufferObject) => unit,
}

@bs.deriving(abstract)
type textureViewDescriptor = {
  format: textureFormat,
  @bs.optional
  dimension: string,
  @bs.optional
  aspect: string,
  @bs.optional
  baseMipLevel: int,
  @bs.optional
  mipLevelCount: int,
  @bs.optional
  baseArrayLayer: int,
  @bs.optional
  arrayLayerCount: int,
}

type texture = {createView: (textureViewDescriptor, textureObject) => textureViewObject}

type passEncoderRender = {
  setPipeline: (renderPipelineObject, passEncoderRenderObject) => unit,
  setBindGroup: (bindingPoint, bindGroupObject, passEncoderRenderObject) => unit,
  setDynamicBindGroup: (bindingPoint, bindGroupObject, array<int>, passEncoderRenderObject) => unit,
  setVertexBuffer: (int, bufferObject, passEncoderRenderObject) => unit,
  setIndexBuffer: (bufferObject, passEncoderRenderObject) => unit,
  draw: (vertexCount, instanceCount, firstVertex, firstInstance, passEncoderRenderObject) => unit,
  drawIndexed: (
    indexCount,
    instanceCount,
    firstIndex,
    baseVertex,
    firstInstance,
    passEncoderRenderObject,
  ) => unit,
  endPass: passEncoderRenderObject => unit,
}

type passEncoderCompute = {
  setPipeline: (computePipelineObject, passEncoderComputeObject) => unit,
  setBindGroup: (bindingPoint, bindGroupObject, passEncoderComputeObject) => unit,
  setDynamicBindGroup: (
    bindingPoint,
    bindGroupObject,
    array<int>,
    passEncoderComputeObject,
  ) => unit,
  dispatchX: (x, passEncoderComputeObject) => unit,
  endPass: passEncoderComputeObject => unit,
}

type passEncoder = {
  render: passEncoderRender,
  compute: passEncoderCompute,
}

type bufferCopyView = {
  "buffer": bufferObject,
  "bytesPerRow": int,
  "arrayLayer": int,
  "mipLevel": int,
  "textureArrayLayerHeight": int,
}

type origin3D = {"x": int, "y": int, "z": int}

type textureCopyView = {
  "texture": textureObject,
  "arrayLayer": int,
  "mipLevel": int,
  "origin": origin3D,
}

type commandEncoder = {
  beginRenderPass: (passEncoderRenderDescriptor, commandEncoderObject) => passEncoderRenderObject,
  beginComputePass: (
    passEncoderComputeDescriptor,
    commandEncoderObject,
  ) => passEncoderComputeObject,
  finish: commandEncoderObject => commandBufferObject,
  copyBufferToTexture: (bufferCopyView, textureCopyView, extend3D, commandEncoderObject) => unit,
}

type device = {
  getQueue: deviceObject => queueObject,
  createShaderModule: (shaderModuleDescriptor, deviceObject) => shaderModuleObject,
  createPipelineLayout: (pipelineLayoutConfig, deviceObject) => pipelineLayoutObject,
  createBuffer: (bufferDescriptor, deviceObject) => bufferObject,
  createBindGroupLayout: (bindGroupLayoutDescriptor, deviceObject) => bindGroupLayoutObject,
  createBindGroup: (bindGroupDescriptor, deviceObject) => bindGroupObject,
  createRenderPipeline: (pipelineRenderDescriptor, deviceObject) => renderPipelineObject,
  createComputePipeline: (pipelineComputeDescriptor, deviceObject) => computePipelineObject,
  createCommandEncoder: (commandEncoderDescriptor, deviceObject) => commandEncoderObject,
  createSampler: (samplerDescriptor, deviceObject) => samplerObject,
  createTexture: (textureDescriptor, deviceObject) => textureObject,
}

type context = {
  getSwapChainPreferredFormat: (deviceObject, contextObject) => Js.Promise.t<textureFormat>,
  configureSwapChain: (swapChainConfig, contextObject) => swapChainObject,
}

type window = {
  make: windowDescriptor => windowObject,
  getContext: windowObject => contextObject,
  pollEvents: windowObject => unit,
  shouldClose: windowObject => bool,
  getWidth: windowObject => int,
  getHeight: windowObject => int,
}

type adapter = {
  requestDevice: ({"extensions": array<string>}, adapterObject) => Js.Promise.t<deviceObject>,
}

type gpu = {requestAdapter: adapterDescriptor => Js.Promise.t<adapterObject>}

type capacity = {getTextureArrayMaxLayerCount: unit => int}

type webgpuCore = {
  textureUsage: textureUsage,
  texture: texture,
  swapChain: swapChain,
  queue: queue,
  shaderStage: shaderStage,
  bufferUsage: bufferUsage,
  buffer: buffer,
  passEncoder: passEncoder,
  commandEncoder: commandEncoder,
  device: device,
  context: context,
  window: window,
  adapter: adapter,
  gpu: gpu,
  loadGLSL: loadGLSL,
  capacity: capacity,
}
