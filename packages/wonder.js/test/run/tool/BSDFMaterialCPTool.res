open Wonderjs

let buildRepoWithTwoMaterialsAndMapData = sandbox => {
  open ImageRepoType

  let material1 = 2->Obj.magic
  let material2 = 3->Obj.magic

  let diffuseColor1 = (1., 0., 0., 1.)
  let diffuseColor2 = (0., 1., 0., 0.5)
  let emissionColor1 = (1., 1., 0.)
  let emissionColor2 = (0., 0.5, 0.5)
  let alphaCutoff1 = 0.0
  let alphaCutoff2 = 0.5
  let specular1 = 0.5
  let specular2 = 1.0
  let specularColor1 = (0.5, 0., 0.)
  let specularColor2 = (0.5, 1., 0.)
  let roughness1 = 0.5
  let roughness2 = 1.5
  let metalness1 = 1.0
  let metalness2 = 2.0
  let transmission1 = 0.0
  let transmission2 = 0.5
  let ior1 = 1.0
  let ior2 = 2.0
  let isDoubleSide1 = true
  let isDoubleSide2 = false
  let diffuseMapImageWrapData1 = (0, 0)
  let diffuseMapImageWrapData2 = (0, 0)
  let channelRoughnessMetallicMapImageWrapData1 = (2, 0)
  let channelRoughnessMetallicMapImageWrapData2 = (2, 0)
  // let emissionMapImageWrapData1 = (0, 0);
  let emissionMapImageWrapData2 = (2, 2)
  let normalMapImageWrapData1 = (1, 0)
  // let normalMapImageWrapData2 = (1, 1);
  let transmissionMapImageWrapData1 = (0, 2)
  let transmissionMapImageWrapData2 = (0, 2)
  // let specularMapImageWrapData1 = (1, 1);
  let specularMapImageWrapData2 = (2, 2)

  let id1 = "i1"
  let id2 = "i2"
  let id3 = "i3"
  let id4 = "i4"
  let id5 = "i5"
  let id6 = "i6"
  let id7 = "i7"
  let imageData1 = {
    width: 2,
    height: 1,
    data: Js.Typed_array.Uint8Array.make([1]),
  }
  let imageData2 = {
    width: 2,
    height: 2,
    data: Js.Typed_array.Uint8Array.make([1, 2]),
  }
  let imageData3 = {
    width: 2,
    height: 2,
    data: Js.Typed_array.Uint8Array.make([
      3,
      2,
      1,
      5,
      100,
      150,
      101,
      1,
      102,
      150,
      101,
      3,
      97,
      150,
      101,
      5,
    ]),
  }
  let imageData4 = {
    width: 4,
    height: 2,
    data: Js.Typed_array.Uint8Array.make([1, 3, 2]),
  }
  let imageData5 = {
    width: 2,
    height: 4,
    data: Js.Typed_array.Uint8Array.make([0, 4]),
  }
  let imageData6 = {
    width: 2,
    height: 4,
    data: Js.Typed_array.Uint8Array.make([1, 2]),
  }
  let imageData7 = {
    width: 2,
    height: 4,
    data: Js.Typed_array.Uint8Array.make([3, 4]),
  }

  (
    (
      SceneGraphRepoDependencyTool.buildBSDFMaterialRepo(
        ~sandbox,
        ~isSame=(material1, material2) => material1 == material2,
        ~getId=material => material->Obj.magic,
        ~getDiffuseColor=material =>
          switch material {
          | material when material == material1 => diffuseColor1
          | material when material == material2 => diffuseColor2
          },
        ~getEmissionColor=material =>
          switch material {
          | material when material == material1 => emissionColor1
          | material when material == material2 => emissionColor2
          },
        ~getAlphaCutoff=material =>
          switch material {
          | material when material == material1 => alphaCutoff1
          | material when material == material2 => alphaCutoff2
          },
        ~getSpecular=material =>
          switch material {
          | material when material == material1 => specular1
          | material when material == material2 => specular2
          },
        ~getSpecularColor=material =>
          switch material {
          | material when material == material1 => specularColor1
          | material when material == material2 => specularColor2
          },
        ~getRoughness=material =>
          switch material {
          | material when material == material1 => roughness1
          | material when material == material2 => roughness2
          },
        ~getMetalness=material =>
          switch material {
          | material when material == material1 => metalness1
          | material when material == material2 => metalness2
          },
        ~getTransmission=material =>
          switch material {
          | material when material == material1 => transmission1
          | material when material == material2 => transmission2
          },
        ~getIOR=material =>
          switch material {
          | material when material == material1 => ior1
          | material when material == material2 => ior2
          },
        ~isDoubleSide=material =>
          switch material {
          | material when material == material1 => isDoubleSide1
          | material when material == material2 => isDoubleSide2
          },
        ~getDiffuseMapImageId=material =>
          switch material {
          | material when material == material1 => Js.Nullable.return(id2)
          | material when material == material2 => Js.Nullable.return(id2)
          },
        ~getChannelRoughnessMetallicMapImageId=material =>
          switch material {
          | material when material == material1 => Js.Nullable.return(id1)
          | material when material == material2 => Js.Nullable.return(id1)
          },
        ~getEmissionMapImageId=material =>
          switch material {
          | material when material == material1 => Js.Nullable.null
          | material when material == material2 => Js.Nullable.return(id4)
          },
        ~getNormalMapImageId=material =>
          switch material {
          | material when material == material1 => Js.Nullable.return(id3)
          | material when material == material2 => Js.Nullable.null
          },
        ~getTransmissionMapImageId=material =>
          switch material {
          | material when material == material1 => Js.Nullable.return(id6)
          | material when material == material2 => Js.Nullable.return(id6)
          },
        ~getSpecularMapImageId=material =>
          switch material {
          | material when material == material1 => Js.Nullable.null
          | material when material == material2 => Js.Nullable.return(id7)
          },
        ~getDiffuseMapImageWrapData=material =>
          switch material {
          | material when material == material1 => Js.Nullable.return(diffuseMapImageWrapData1)
          | material when material == material2 => Js.Nullable.return(diffuseMapImageWrapData2)
          },
        ~getChannelRoughnessMetallicMapImageWrapData=material =>
          switch material {
          | material when material == material1 =>
            Js.Nullable.return(channelRoughnessMetallicMapImageWrapData1)
          | material when material == material2 =>
            Js.Nullable.return(channelRoughnessMetallicMapImageWrapData2)
          },
        ~getEmissionMapImageWrapData=material =>
          switch material {
          | material when material == material1 => Js.Nullable.null
          | material when material == material2 => Js.Nullable.return(emissionMapImageWrapData2)
          },
        ~getNormalMapImageWrapData=material =>
          switch material {
          | material when material == material1 => Js.Nullable.return(normalMapImageWrapData1)
          | material when material == material2 => Js.Nullable.null
          },
        ~getTransmissionMapImageWrapData=material =>
          switch material {
          | material when material == material1 => Js.Nullable.return(transmissionMapImageWrapData1)
          | material when material == material2 => Js.Nullable.return(transmissionMapImageWrapData1)
          },
        ~getSpecularMapImageWrapData=material =>
          switch material {
          | material when material == material1 => Js.Nullable.null
          | material when material == material2 => Js.Nullable.return(specularMapImageWrapData2)
          },
        (),
      ),
      ImageRepoDependencyTool.build(
        ~sandbox,
        ~getData=id =>
          switch id {
          | id when id == id1 => Js.Nullable.return(imageData1)
          | id when id == id2 => Js.Nullable.return(imageData2)
          | id when id == id3 => Js.Nullable.return(imageData3)
          | id when id == id4 => Js.Nullable.return(imageData4)
          | id when id == id5 => Js.Nullable.return(imageData5)
          | id when id == id6 => Js.Nullable.return(imageData6)
          | id when id == id7 => Js.Nullable.return(imageData7)
          },
        (),
      ),
    ),
    (
      (
        (material1, material2),
        (
          (diffuseColor1, diffuseColor2),
          ((specular1, specular2), (specularColor1, specularColor2)),
          (roughness1, roughness2),
          (metalness1, metalness2),
          (transmission1, transmission2),
          (ior1, ior2),
        ),
      ),
      (
        (id1, id2, id3, id4, id5, id6, id7),
        (imageData1, imageData2, imageData3, imageData4, imageData5, imageData6, imageData7),
      ),
    ),
  )
}
