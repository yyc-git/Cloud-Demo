type t = {
  mutable config: option<IConfigDp.config>,
  mutable sceneGraphRepo: option<ISceneGraphRepoDp.sceneGraphRepo>,
  mutable imageRepo: option<IImageRepoDp.imageRepo>,
  mutable timeRepo: option<ITimeRepoDp.timeRepo>,
  mutable pipelineRepo: option<IPipelineRepoDp.pipelineRepo>,
  mutable time: option<ITimeDp.time>,
  mutable webgpuCore: option<IWebGPUCoreDp.webgpuCore>,
  mutable webgpuRayTracing: option<IWebGPURayTracingDp.webgpuRayTracing>,
}

let dpContainer = {
  config: None,
  sceneGraphRepo: None,
  timeRepo: None,
  imageRepo: None,
  pipelineRepo: None,
  time: None,
  webgpuCore: None,
  webgpuRayTracing: None,
}

let unsafeGetConfigDp = () => dpContainer.config->OptionSt.unsafeGet

let setConfigDp = dp => {
  dpContainer.config = dp->Some

  ()
}

let _unsafeGetSceneGraphRepoDp = () => dpContainer.sceneGraphRepo->OptionSt.unsafeGet

let unsafeGetSceneRepoDp = () => _unsafeGetSceneGraphRepoDp().sceneRepo

let unsafeGetGameObjectRepoDp = () => _unsafeGetSceneGraphRepoDp().gameObjectRepo

let unsafeGetTransformRepoDp = () => _unsafeGetSceneGraphRepoDp().transformRepo

let unsafeGetBSDFMaterialRepoDp = () => _unsafeGetSceneGraphRepoDp().bsdfMaterialRepo

let unsafeGetGeometryRepoDp = () => _unsafeGetSceneGraphRepoDp().geometryRepo

let unsafeGetDirectionLightRepoDp = () => _unsafeGetSceneGraphRepoDp().directionLightRepo

let unsafeGetBasicCameraViewRepoDp = () => _unsafeGetSceneGraphRepoDp().basicCameraViewRepo

let unsafeGetPerspectiveCameraProjectionRepoDp = () =>
  _unsafeGetSceneGraphRepoDp().perspectiveCameraProjectionRepo

// let unsafeGetGlobalTempRepoDp = () => {
//   _unsafeGetSceneGraphRepoDp().globalTempRepo;
// };

let unsafeGetPipelineRepoDp = () => dpContainer.pipelineRepo->OptionSt.unsafeGet

let setPipelineRepoDp = dp => {
  dpContainer.pipelineRepo = dp->Some

  ()
}

let setSceneGraphRepoDp = dp => {
  dpContainer.sceneGraphRepo = dp->Some

  ()
}

let unsafeGetTimeRepoDp = () => dpContainer.timeRepo->OptionSt.unsafeGet

let setTimeRepoDp = dp => {
  dpContainer.timeRepo = dp->Some

  ()
}

let unsafeGetTimeDp = () => dpContainer.time->OptionSt.unsafeGet

let setTimeDp = dp => {
  dpContainer.time = dp->Some

  ()
}

let unsafeGetWebGPUCoreDp = () => dpContainer.webgpuCore->OptionSt.unsafeGet

let setWebGPUCoreDp = dp => {
  dpContainer.webgpuCore = dp->Some

  ()
}

let unsafeGetWebGPURayTracingDp = () => dpContainer.webgpuRayTracing->OptionSt.unsafeGet

let setWebGPURayTracingDp = dp => {
  dpContainer.webgpuRayTracing = dp->Some

  ()
}

let unsafeGetImageRepoDp = () => dpContainer.imageRepo->OptionSt.unsafeGet

let setImageRepoDp = dp => {
  dpContainer.imageRepo = dp->Some

  ()
}
