'use strict';

var Most = require("most");
var Curry = require("bs-platform/lib/js/curry.js");
var Log$Wonderjs = require("../../../../../../../../../construct/domain_layer/library/log/Log.bs.js");
var ListSt$Wonderjs = require("../../../../../../../../../construct/domain_layer/library/structure/ListSt.bs.js");
var Result$Wonderjs = require("../../../../../../../../../construct/domain_layer/library/structure/Result.bs.js");
var Tuple2$Wonderjs = require("../../../../../../../../../construct/domain_layer/library/structure/tuple/Tuple2.bs.js");
var Contract$Wonderjs = require("../../../../../../../../../construct/domain_layer/library/contract/Contract.bs.js");
var OptionSt$Wonderjs = require("../../../../../../../../../construct/domain_layer/library/structure/OptionSt.bs.js");
var JobEntity$Wonderjs = require("../../../../../../../../../construct/domain_layer/domain/pipeline/pipeline/entity/JobEntity.bs.js");
var ListResult$Wonderjs = require("../../../../../../../../../construct/domain_layer/library/structure/ListResult.bs.js");
var DirectionVO$Wonderjs = require("../../../../../../../../../construct/domain_layer/domain/scene/scene_graph/value_object/DirectionVO.bs.js");
var IntensityVO$Wonderjs = require("../../../../../../../../../construct/domain_layer/domain/scene/scene_graph/value_object/IntensityVO.bs.js");
var SceneRunAPI$Wonderjs = require("../../../../../../../../../construct/external_layer/api/domain/SceneRunAPI.bs.js");
var CameraCPRepo$Wonderjs = require("../../../../../../repo/pipeline/CameraCPRepo.bs.js");
var WebGPUCPRepo$Wonderjs = require("../../../../../../repo/webgpu/WebGPUCPRepo.bs.js");
var ConfigDpRunAPI$Wonderjs = require("../../../../../../../../../construct/external_layer/api/dependency/ConfigDpRunAPI.bs.js");
var StorageBufferVO$Wonderjs = require("../../../../../../../../../construct/domain_layer/domain/webgpu/core/value_object/StorageBufferVO.bs.js");
var UniformBufferVO$Wonderjs = require("../../../../../../../../../construct/domain_layer/domain/webgpu/core/value_object/UniformBufferVO.bs.js");
var WebGPUCoreDpRunAPI$Wonderjs = require("../../../../../../../../../construct/external_layer/api/dependency/WebGPUCoreDpRunAPI.bs.js");
var DirectionLightRunAPI$Wonderjs = require("../../../../../../../../../construct/external_layer/api/domain/DirectionLightRunAPI.bs.js");
var TypeArrayCPRepoUtils$Wonderjs = require("../../../../../../../infrastructure_layer/dependency/repo/utils/TypeArrayCPRepoUtils.bs.js");
var PathTracingPassCPRepo$Wonderjs = require("../../../../../../repo/pipeline/PathTracingPassCPRepo.bs.js");
var WebGPURayTracingDpRunAPI$Wonderjs = require("../../../../../../../../../construct/external_layer/api/dependency/WebGPURayTracingDpRunAPI.bs.js");

function create(param) {
  return JobEntity$Wonderjs.create("init_pathTracing");
}

function _buildDirectionLightBufferData(device, sceneGameObject) {
  return Result$Wonderjs.bind(Contract$Wonderjs.requireCheck((function (param) {
                    return Contract$Wonderjs.test(Log$Wonderjs.buildAssertMessage("only has one direction light", "not"), (function (param) {
                                  return Contract$Wonderjs.Operators.$eq(DirectionLightRunAPI$Wonderjs.getLightCount(sceneGameObject), 1);
                                }));
                  }), Curry._1(ConfigDpRunAPI$Wonderjs.unsafeGet(undefined).getIsDebug, undefined)), (function (param) {
                return Result$Wonderjs.mapSuccess(Result$Wonderjs.bind(Result$Wonderjs.mapSuccess(OptionSt$Wonderjs.get(ListSt$Wonderjs.head(DirectionLightRunAPI$Wonderjs.getAllLights(sceneGameObject))), (function (light) {
                                      return [
                                              IntensityVO$Wonderjs.value(DirectionLightRunAPI$Wonderjs.getIntensity(light)),
                                              DirectionVO$Wonderjs.value(DirectionLightRunAPI$Wonderjs.getDirection(light))
                                            ];
                                    })), (function (param) {
                                  var directionLightBufferData = new Float32Array(8);
                                  return Result$Wonderjs.mapSuccess(ListResult$Wonderjs.mergeResults({
                                                  hd: TypeArrayCPRepoUtils$Wonderjs.setFloat1(0, param[0], directionLightBufferData),
                                                  tl: {
                                                    hd: TypeArrayCPRepoUtils$Wonderjs.setFloat3(4, param[1], directionLightBufferData),
                                                    tl: /* [] */0
                                                  }
                                                }), (function (param) {
                                                return directionLightBufferData;
                                              }));
                                })), (function (directionLightBufferData) {
                              var bufferSize = directionLightBufferData.byteLength;
                              var buffer = StorageBufferVO$Wonderjs.createFromDevice(device, bufferSize, WebGPUCoreDpRunAPI$Wonderjs.unsafeGet(undefined).bufferUsage.copy_dst | WebGPUCoreDpRunAPI$Wonderjs.unsafeGet(undefined).bufferUsage.storage, undefined);
                              Curry._3(WebGPUCoreDpRunAPI$Wonderjs.unsafeGet(undefined).buffer.setSubFloat32Data, 0, directionLightBufferData, StorageBufferVO$Wonderjs.value(buffer));
                              return [
                                      buffer,
                                      bufferSize
                                    ];
                            }));
              }));
}

function _createShaderBindingTable(device) {
  var baseShaderPath = "src/run/rtx_path_tracer/domain_layer/domain/shader/ray_tracing";
  var rayGenShaderModule = Curry._2(WebGPUCoreDpRunAPI$Wonderjs.unsafeGet(undefined).device.createShaderModule, {
        code: Curry._1(WebGPUCoreDpRunAPI$Wonderjs.unsafeGet(undefined).loadGLSL, "" + baseShaderPath + "/ray_generation.rgen")
      }, device);
  var rayRChitShaderModule = Curry._2(WebGPUCoreDpRunAPI$Wonderjs.unsafeGet(undefined).device.createShaderModule, {
        code: Curry._1(WebGPUCoreDpRunAPI$Wonderjs.unsafeGet(undefined).loadGLSL, "" + baseShaderPath + "/ray_closest_hit.rchit")
      }, device);
  var rayRAhitShaderModule = Curry._2(WebGPUCoreDpRunAPI$Wonderjs.unsafeGet(undefined).device.createShaderModule, {
        code: Curry._1(WebGPUCoreDpRunAPI$Wonderjs.unsafeGet(undefined).loadGLSL, "" + baseShaderPath + "/ray_anyhit_shadow.rahit")
      }, device);
  var rayMissShaderModule = Curry._2(WebGPUCoreDpRunAPI$Wonderjs.unsafeGet(undefined).device.createShaderModule, {
        code: Curry._1(WebGPUCoreDpRunAPI$Wonderjs.unsafeGet(undefined).loadGLSL, "" + baseShaderPath + "/ray_miss.rmiss")
      }, device);
  var rayMissShadowShaderModule = Curry._2(WebGPUCoreDpRunAPI$Wonderjs.unsafeGet(undefined).device.createShaderModule, {
        code: Curry._1(WebGPUCoreDpRunAPI$Wonderjs.unsafeGet(undefined).loadGLSL, "" + baseShaderPath + "/ray_miss_shadow.rmiss")
      }, device);
  return Curry._2(WebGPURayTracingDpRunAPI$Wonderjs.unsafeGet(undefined).device.createRayTracingShaderBindingTable, {
              stages: [
                {
                  module: rayGenShaderModule,
                  stage: WebGPURayTracingDpRunAPI$Wonderjs.unsafeGet(undefined).shaderStage.ray_generation
                },
                {
                  module: rayRChitShaderModule,
                  stage: WebGPURayTracingDpRunAPI$Wonderjs.unsafeGet(undefined).shaderStage.ray_closest_hit
                },
                {
                  module: rayRAhitShaderModule,
                  stage: WebGPURayTracingDpRunAPI$Wonderjs.unsafeGet(undefined).shaderStage.ray_any_hit
                },
                {
                  module: rayMissShaderModule,
                  stage: WebGPURayTracingDpRunAPI$Wonderjs.unsafeGet(undefined).shaderStage.ray_miss
                },
                {
                  module: rayMissShadowShaderModule,
                  stage: WebGPURayTracingDpRunAPI$Wonderjs.unsafeGet(undefined).shaderStage.ray_miss
                }
              ],
              groups: [
                {
                  type: "general-hit-group",
                  generalIndex: 0
                },
                {
                  type: "triangles-hit-group",
                  closestHitIndex: 1
                },
                {
                  type: "triangles-hit-group",
                  anyHitIndex: 2
                },
                {
                  type: "general",
                  generalIndex: 3
                },
                {
                  type: "general",
                  generalIndex: 4
                }
              ]
            }, device);
}

function exec(param) {
  return Most.just(Result$Wonderjs.bind(Tuple2$Wonderjs.collectOption(WebGPUCPRepo$Wonderjs.getDevice(undefined), WebGPUCPRepo$Wonderjs.getQueue(undefined)), (function (param) {
                    var device = param[0];
                    PathTracingPassCPRepo$Wonderjs.setShaderBindingTable(_createShaderBindingTable(device));
                    var cameraBindGroupLayout = Curry._2(WebGPUCoreDpRunAPI$Wonderjs.unsafeGet(undefined).device.createBindGroupLayout, {
                          entries: [{
                              binding: 0,
                              visibility: WebGPURayTracingDpRunAPI$Wonderjs.unsafeGet(undefined).shaderStage.ray_generation,
                              type: "uniform-buffer"
                            }]
                        }, device);
                    PathTracingPassCPRepo$Wonderjs.setCameraBindGroupLayout(cameraBindGroupLayout);
                    return Result$Wonderjs.bind(Result$Wonderjs.mapSuccess(OptionSt$Wonderjs.get(CameraCPRepo$Wonderjs.getCameraBufferData(undefined)), (function (param) {
                                      PathTracingPassCPRepo$Wonderjs.addStaticBindGroupData(1, Curry._2(WebGPUCoreDpRunAPI$Wonderjs.unsafeGet(undefined).device.createBindGroup, {
                                                layout: cameraBindGroupLayout,
                                                entries: [{
                                                    binding: 0,
                                                    buffer: UniformBufferVO$Wonderjs.value(param[0]),
                                                    offset: 0,
                                                    size: param[1].byteLength
                                                  }]
                                              }, device));
                                      
                                    })), (function (param) {
                                  var directionLightBindGroupLayout = Curry._2(WebGPUCoreDpRunAPI$Wonderjs.unsafeGet(undefined).device.createBindGroupLayout, {
                                        entries: [{
                                            binding: 0,
                                            visibility: WebGPURayTracingDpRunAPI$Wonderjs.unsafeGet(undefined).shaderStage.ray_closest_hit,
                                            type: "storage-buffer"
                                          }]
                                      }, device);
                                  PathTracingPassCPRepo$Wonderjs.setDirectionLightBindGroupLayout(directionLightBindGroupLayout);
                                  return Result$Wonderjs.mapSuccess(_buildDirectionLightBufferData(device, SceneRunAPI$Wonderjs.getSceneGameObject(undefined)), (function (param) {
                                                return PathTracingPassCPRepo$Wonderjs.addStaticBindGroupData(2, Curry._2(WebGPUCoreDpRunAPI$Wonderjs.unsafeGet(undefined).device.createBindGroup, {
                                                                layout: directionLightBindGroupLayout,
                                                                entries: [{
                                                                    binding: 0,
                                                                    buffer: StorageBufferVO$Wonderjs.value(param[0]),
                                                                    offset: 0,
                                                                    size: param[1]
                                                                  }]
                                                              }, device));
                                              }));
                                }));
                  })));
}

exports.create = create;
exports._buildDirectionLightBufferData = _buildDirectionLightBufferData;
exports._createShaderBindingTable = _createShaderBindingTable;
exports.exec = exec;
/* most Not a pure module */
