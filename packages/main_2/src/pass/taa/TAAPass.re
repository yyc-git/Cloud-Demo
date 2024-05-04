open RaytracingFramework;

open WebGPU;

open StateType;

let _initFrameData =
    (
      device,
      swapChainFormat,
      (
        (resolutionBufferSize, resolutionBuffer),
        (pixelBufferSize, pixelBuffer),
        (historyPixelBufferSize, historyPixelBuffer),
        (taaBufferSize, taaBuffer),
      ),
      (fragmentShaderName, addStaticBindGroupDataFunc, setPipelineFunc),
      state,
    ) => {
  let gbufferBindGroupLayout =
    device
    |> Device.createBindGroupLayout({
         "entries": [|
           BindGroupLayout.layoutBinding(
             ~binding=0,
             ~visibility=ShaderStage.fragment,
             ~type_="sampler",
             (),
           ),
           BindGroupLayout.layoutBinding(
             ~binding=1,
             ~visibility=ShaderStage.fragment,
             ~type_="sampled-texture",
             (),
           ),
         |],
       });

  let otherBindGroupLayout =
    device
    |> Device.createBindGroupLayout({
         "entries": [|
           BindGroupLayout.layoutBinding(
             ~binding=0,
             ~visibility=ShaderStage.fragment,
             ~type_="storage-buffer",
             (),
           ),
           BindGroupLayout.layoutBinding(
             ~binding=1,
             ~visibility=ShaderStage.fragment,
             ~type_="storage-buffer",
             (),
           ),
           BindGroupLayout.layoutBinding(
             ~binding=2,
             ~visibility=ShaderStage.fragment,
             ~type_="uniform-buffer",
             (),
           ),
           BindGroupLayout.layoutBinding(
             ~binding=3,
             ~visibility=ShaderStage.fragment,
             ~type_="uniform-buffer",
             (),
           ),
         |],
       });

  let gbufferBindGroup =
    device
    |> Device.createBindGroup({
         "layout": gbufferBindGroupLayout,
         "entries": [|
           BindGroup.binding(
             ~binding=0,
             ~sampler=GBufferUtils.createLinearSampler(device),
             ~size=0,
             (),
           ),
           BindGroup.binding(
             ~binding=1,
             ~textureView=
               Pass.unsafeGetTextureView(
                 "motionVectorDepthSpecularRenderTargetView",
                 state,
               ),
             ~size=0,
             (),
           ),
         |],
       });

  let otherBindGroup =
    device
    |> Device.createBindGroup({
         "layout": otherBindGroupLayout,
         "entries": [|
           BindGroup.binding(
             ~binding=0,
             ~buffer=pixelBuffer,
             ~offset=0,
             ~size=pixelBufferSize,
             (),
           ),
           BindGroup.binding(
             ~binding=1,
             ~buffer=historyPixelBuffer,
             ~offset=0,
             ~size=historyPixelBufferSize,
             (),
           ),
           BindGroup.binding(
             ~binding=2,
             ~buffer=resolutionBuffer,
             ~offset=0,
             ~size=resolutionBufferSize,
             (),
           ),
           BindGroup.binding(
             ~binding=3,
             ~buffer=taaBuffer,
             ~offset=0,
             ~size=taaBufferSize,
             (),
           ),
         |],
       });

  let state =
    state
    |> addStaticBindGroupDataFunc(0, gbufferBindGroup)
    |> addStaticBindGroupDataFunc(1, otherBindGroup);

  let baseShaderPath = "src/pass/taa/shaders";

  let vertexShaderModule =
    device
    |> Device.createShaderModule({
         "code": WebGPUUtils.loadShaderFile({j|$(baseShaderPath)/taa.vert|j}),
       });
  let fragmentShaderModule =
    device
    |> Device.createShaderModule({
         "code":
           WebGPUUtils.loadShaderFile(
             {j|$(baseShaderPath)/$(fragmentShaderName).frag|j},
           ),
       });

  let pipeline =
    device
    |> Device.createRenderPipeline(
         Pipeline.Render.descriptor(
           ~layout=
             device
             |> Device.createPipelineLayout({
                  "bindGroupLayouts": [|
                    gbufferBindGroupLayout,
                    otherBindGroupLayout,
                  |],
                }),
           ~vertexStage={
             Pipeline.Render.vertexStage(
               ~module_=vertexShaderModule,
               ~entryPoint="main",
             );
           },
           ~fragmentStage={
             Pipeline.Render.fragmentStage(
               ~module_=fragmentShaderModule,
               ~entryPoint="main",
             );
           },
           ~primitiveTopology="triangle-list",
           ~vertexState=
             Pipeline.Render.vertexState(~indexFormat="uint32", ()),
           ~rasterizationState=Pipeline.Render.rasterizationState(),
           ~colorStates=[|
             Pipeline.Render.colorState(
               ~format=swapChainFormat,
               ~alphaBlend=Pipeline.Render.blendDescriptor(),
               ~colorBlend=Pipeline.Render.blendDescriptor(),
             ),
           |],
           (),
         ),
       );

  state |> setPipelineFunc(pipeline);
};

let _initFirstFrameData =
    (
      device,
      swapChainFormat,
      (
        (resolutionBufferSize, resolutionBuffer),
        (pixelBufferSize, pixelBuffer),
        (historyPixelBufferSize, historyPixelBuffer),
        (taaBufferSize, taaBuffer),
      ),
      state,
    ) => {
  _initFrameData(
    device,
    swapChainFormat,
    (
      (resolutionBufferSize, resolutionBuffer),
      (pixelBufferSize, pixelBuffer),
      (historyPixelBufferSize, historyPixelBuffer),
      (taaBufferSize, taaBuffer),
    ),
    (
      "taa_firstFrame",
      Pass.TAAPass.addFirstFrameStaticBindGroupData,
      Pass.TAAPass.setFirstFramePipeline,
    ),
    state,
  );
};

let _initOtherFrameData =
    (
      device,
      swapChainFormat,
      (
        (resolutionBufferSize, resolutionBuffer),
        (pixelBufferSize, pixelBuffer),
        (historyPixelBufferSize, historyPixelBuffer),
        (taaBufferSize, taaBuffer),
      ),
      state,
    ) => {
  _initFrameData(
    device,
    swapChainFormat,
    (
      (resolutionBufferSize, resolutionBuffer),
      (pixelBufferSize, pixelBuffer),
      (historyPixelBufferSize, historyPixelBuffer),
      (taaBufferSize, taaBuffer),
    ),
    (
      "taa_otherFrame",
      Pass.TAAPass.addOtherFrameStaticBindGroupData,
      Pass.TAAPass.setOtherFramePipeline,
    ),
    state,
  );
};

let init = (device, window, swapChainFormat, state) => {
  let (resolutionBufferData, resolutionBuffer) =
    RTXBuffer.ResolutionBuffer.unsafeGetBufferData(state);
  let (pixelBufferSize, pixelBuffer) =
    RTXBuffer.PixelBuffer.unsafeGetBufferData(state);
  let (historyPixelBufferSize, historyPixelBuffer) =
    RTXBuffer.HistoryPixelBuffer.unsafeGetBufferData(state);
  let (taaBufferData, taaBuffer) =
    RTXBuffer.TAABuffer.unsafeGetBufferData(state);

  state
  |> Pass.TAAPass.markFirstFrame
  |> _initFirstFrameData(
       device,
       swapChainFormat,
       (
         (
           RTXBuffer.ResolutionBuffer.getBufferSize(resolutionBufferData),
           resolutionBuffer,
         ),
         (pixelBufferSize, pixelBuffer),
         (historyPixelBufferSize, historyPixelBuffer),
         (RTXBuffer.TAABuffer.getBufferSize(taaBufferData), taaBuffer),
       ),
     )
  |> _initOtherFrameData(
       device,
       swapChainFormat,
       (
         (
           RTXBuffer.ResolutionBuffer.getBufferSize(resolutionBufferData),
           resolutionBuffer,
         ),
         (pixelBufferSize, pixelBuffer),
         (historyPixelBufferSize, historyPixelBuffer),
         (RTXBuffer.TAABuffer.getBufferSize(taaBufferData), taaBuffer),
       ),
     );
};

let execute = (device, queue, swapChain, state) => {
  let backBufferView = swapChain |> SwapChain.getCurrentTextureView();

  let commandEncoder =
    device |> Device.createCommandEncoder(CommandEncoder.descriptor());
  let renderPass =
    commandEncoder
    |> CommandEncoder.beginRenderPass(
         {
           PassEncoder.Render.descriptor(
             ~colorAttachments=[|
               {
                 "clearColor": {
                   "r": 0.0,
                   "g": 0.0,
                   "b": 0.0,
                   "a": 1.0,
                 },
                 "loadOp": "clear",
                 "storeOp": "store",
                 "attachment": backBufferView,
               },
             |],
             (),
           );
         },
       );

  let (staticBindGroupDataArr, pipeline) =
    Pass.TAAPass.isFirstFrame(state)
      ? (
        Pass.TAAPass.getFirstFrameStaticBindGroupDataArr(state),
        Pass.TAAPass.unsafeGetFirstFramePipeline(state),
      )
      : (
        Pass.TAAPass.getOtherFrameStaticBindGroupDataArr(state),
        Pass.TAAPass.unsafeGetOtherFramePipeline(state),
      );

  renderPass |> PassEncoder.Render.setPipeline(pipeline);

  staticBindGroupDataArr
  |> Js.Array.forEach(({setSlot, bindGroup}: staticBindGroupData) => {
       renderPass |> PassEncoder.Render.setBindGroup(setSlot, bindGroup)
     });

  renderPass |> PassEncoder.Render.draw(3, 1, 0, 0);
  renderPass |> PassEncoder.Render.endPass;

  queue |> Queue.submit([|commandEncoder |> CommandEncoder.finish|]);

  state |> Pass.TAAPass.markNotFirstFrame;
};
