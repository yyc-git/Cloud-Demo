open Wonder_jest

let _ = describe("test end_render job", () => {
  open Expect
  open Expect.Operators
  open Sinon

  let sandbox = getSandboxDefaultVal()

  let _prepare = () => {
    let window = WebGPUDependencyTool.createWindowObject()
    WebGPUCPTool.setWindow(window)
    let swapChain = WebGPUDependencyTool.createSwapChainObject()
    WebGPUCPTool.setSwapChain(swapChain)

    (window, swapChain)
  }

  beforeEach(() => {
    sandbox := createSandbox()
    TestCPTool.init(
      ~sandbox,
      ~renderPipelineData={
        name: "render",
        firstGroup: "frame",
        groups: list{
          {
            name: "frame",
            link: Concat,
            elements: list{{name: "end_render", type_: Job}},
          },
        },
      },
      (),
    )
  })
  afterEach(() => restoreSandbox(refJsObjToSandbox(sandbox.contents)))

  testPromise("present", () => {
    let (window, swapChain) = _prepare()
    let present = createEmptyStub(refJsObjToSandbox(sandbox.contents))

    WebGPUDependencyTool.build(~sandbox, ~present, ())->WebGPUDependencyTool.set

    DirectorCPTool.initAndRender(
      ~handleSuccessFunc=() => present->expect->SinonTool.toCalledWith([swapChain]),
      (),
    )
  })
  testPromise("poll events", () => {
    let (window, swapChain) = _prepare()
    let pollEvents = createEmptyStub(refJsObjToSandbox(sandbox.contents))

    WebGPUDependencyTool.build(~sandbox, ~pollEvents, ())->WebGPUDependencyTool.set

    DirectorCPTool.initAndRender(
      ~handleSuccessFunc=() => pollEvents->expect->SinonTool.toCalledWith([window]),
      (),
    )
  })
})
